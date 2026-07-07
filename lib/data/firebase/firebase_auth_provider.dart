// `firebase_auth` also exports a class named `AuthProvider`; hide it so the
// name resolves to our backend-agnostic contract.
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;

import '../../core/error/app_error.dart';
import '../../domain/repositories/auth_provider.dart';
import '../../domain/value/auth_user.dart';

/// Firebase-backed [AuthProvider]: email/password + anonymous sessions.
///
/// Maps Firebase `User`/`UserCredential` onto the neutral [AuthUser] and
/// translates `FirebaseAuthException`s into typed [AuthError]s.
class FirebaseAuthProvider implements AuthProvider {
  FirebaseAuthProvider({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  AuthUser? _map(User? user) => user == null
      ? null
      : AuthUser(
          uid: user.uid,
          email: user.email,
          isAnonymous: user.isAnonymous,
        );

  @override
  Stream<AuthUser?> authStateChanges() => _auth.authStateChanges().map(_map);

  @override
  AuthUser? get currentUser => _map(_auth.currentUser);

  @override
  Future<AuthUser> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return _requireUser(cred);
    } on FirebaseAuthException catch (e) {
      throw _mapAuthException(e);
    }
  }

  @override
  Future<AuthUser> registerWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return _requireUser(cred);
    } on FirebaseAuthException catch (e) {
      throw _mapAuthException(e);
    }
  }

  @override
  Future<void> signOut() => _auth.signOut();

  @override
  Future<AuthUser> signInAnonymously() async {
    try {
      final cred = await _auth.signInAnonymously();
      return _requireUser(cred);
    } on FirebaseAuthException catch (e) {
      throw _mapAuthException(e);
    }
  }

  AuthUser _requireUser(UserCredential cred) {
    final user = _map(cred.user);
    if (user == null) {
      throw const AuthError(AppErrorCode.unknown);
    }
    return user;
  }

  AuthError _mapAuthException(FirebaseAuthException e) {
    final code = switch (e.code) {
      'wrong-password' ||
      'user-not-found' ||
      'invalid-credential' ||
      'INVALID_LOGIN_CREDENTIALS' =>
        AppErrorCode.invalidCredentials,
      'email-already-in-use' => AppErrorCode.emailAlreadyInUse,
      'weak-password' => AppErrorCode.weakPassword,
      'invalid-email' => AppErrorCode.invalidEmail,
      'user-disabled' => AppErrorCode.userDisabled,
      'network-request-failed' => AppErrorCode.network,
      _ => AppErrorCode.unknown,
    };
    return AuthError(code, cause: e);
  }
}
