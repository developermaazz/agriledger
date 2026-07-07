import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';

import '../../core/error/app_error.dart';
import '../../domain/repositories/auth_provider.dart';
import '../../domain/value/auth_user.dart';
import 'db/app_database.dart';
import 'local_ids.dart';

/// Local [AuthProvider]: on-device accounts (email/password + anonymous) with a
/// persisted single-session. Passwords are salted + SHA-256 hashed. No network.
class LocalAuthProvider implements AuthProvider {
  LocalAuthProvider(this.db);

  final AppDatabase db;

  final StreamController<AuthUser?> _controller =
      StreamController<AuthUser?>.broadcast();
  AuthUser? _current;

  /// Invoked with the new uid the first time ANY account is created, so the
  /// backend can seed starter data. Set by the factory.
  Future<void> Function(String uid)? onFirstAccount;

  /// Releases the auth-state stream controller. Called on backend disposal.
  Future<void> close() => _controller.close();

  /// Loads the persisted session. Call once at startup.
  Future<void> init() async {
    final session = await (db.select(db.sessionRows)
          ..where((t) => t.id.equals(0)))
        .getSingleOrNull();
    final uid = session?.currentUid;
    if (uid == null) return;
    final acc = await (db.select(db.accounts)..where((t) => t.uid.equals(uid)))
        .getSingleOrNull();
    if (acc != null) {
      _current = _toUser(acc);
    }
  }

  AuthUser _toUser(AccountRow a) =>
      AuthUser(uid: a.uid, email: a.email, isAnonymous: a.isAnonymous);

  /// The current uid, or throws [NotSignedInError]. Used by the local stores.
  String requireUid() {
    final u = _current;
    if (u == null) {
      throw const NotSignedInError();
    }
    return u.uid;
  }

  @override
  AuthUser? get currentUser => _current;

  @override
  Stream<AuthUser?> authStateChanges() async* {
    yield _current;
    yield* _controller.stream;
  }

  @override
  Future<AuthUser> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final e = email.trim();
    final acc = await (db.select(db.accounts)..where((t) => t.email.equals(e)))
        .getSingleOrNull();
    if (acc == null || acc.passwordHash == null || acc.salt == null) {
      throw const AuthError(AppErrorCode.invalidCredentials);
    }
    if (_hash(password, acc.salt!) != acc.passwordHash) {
      throw const AuthError(AppErrorCode.invalidCredentials);
    }
    await _setSession(acc.uid);
    _current = _toUser(acc);
    _controller.add(_current);
    return _current!;
  }

  @override
  Future<AuthUser> registerWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final e = email.trim();
    if (password.length < 6) {
      throw const AuthError(AppErrorCode.weakPassword);
    }
    final existing = await (db.select(db.accounts)
          ..where((t) => t.email.equals(e)))
        .getSingleOrNull();
    if (existing != null) {
      throw const AuthError(AppErrorCode.emailAlreadyInUse);
    }
    final isFirst = await _isFirstAccount();
    final uid = newLocalId();
    final salt = _newSalt();
    await db.into(db.accounts).insert(
          AccountsCompanion.insert(
            uid: uid,
            createdAt: DateTime.now().millisecondsSinceEpoch,
            email: Value(e),
            passwordHash: Value(_hash(password, salt)),
            salt: Value(salt),
            isAnonymous: const Value(false),
          ),
        );
    await _setSession(uid);
    _current = AuthUser(uid: uid, email: e, isAnonymous: false);
    _controller.add(_current);
    if (isFirst) {
      await onFirstAccount?.call(uid);
    }
    return _current!;
  }

  @override
  Future<AuthUser> signInAnonymously() async {
    final isFirst = await _isFirstAccount();
    final uid = newLocalId();
    await db.into(db.accounts).insert(
          AccountsCompanion.insert(
            uid: uid,
            createdAt: DateTime.now().millisecondsSinceEpoch,
            isAnonymous: const Value(true),
          ),
        );
    await _setSession(uid);
    _current = AuthUser(uid: uid, email: null, isAnonymous: true);
    _controller.add(_current);
    if (isFirst) {
      await onFirstAccount?.call(uid);
    }
    return _current!;
  }

  @override
  Future<void> signOut() async {
    await _setSession(null);
    _current = null;
    _controller.add(null);
  }

  Future<bool> _isFirstAccount() async {
    final any = await (db.select(db.accounts)..limit(1)).getSingleOrNull();
    return any == null;
  }

  Future<void> _setSession(String? uid) async {
    await db.into(db.sessionRows).insertOnConflictUpdate(
          SessionRowsCompanion.insert(id: const Value(0), currentUid: Value(uid)),
        );
  }

  String _hash(String password, String salt) =>
      sha256.convert(utf8.encode('$salt::$password')).toString();

  String _newSalt() => newLocalId() + newLocalId();
}
