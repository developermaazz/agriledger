import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Firebase Auth wrapper + helpers for password reset and verification emails.
class AuthService {
  AuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  /// Use [userChanges] so `reload()` updates listeners (emailVerified, etc.).
  Stream<User?> authStateChanges() => _auth.userChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signInWithEmailPassword({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<UserCredential> registerWithEmailPassword({
    required String email,
    required String password,
  }) {
    return _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<UserCredential> signInWithCustomToken(String token) {
    return _auth.signInWithCustomToken(token);
  }

  Future<void> signOut() => _auth.signOut();

  Future<UserCredential> signInAnonymously() => _auth.signInAnonymously();

  Future<void> sendEmailVerification() async {
    final u = _auth.currentUser;
    if (u == null) return;
    final settings = ActionCodeSettings(
      url: _actionContinueUrl(),
      handleCodeInApp: true,
      androidPackageName: 'com.agriledger.agriledger',
      androidInstallApp: true,
      iOSBundleId: 'com.agriledger.agriledger',
    );
    await u.sendEmailVerification(settings);
  }

  Future<void> reloadCurrentUser() async {
    await _auth.currentUser?.reload();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(
      email: email.trim(),
      actionCodeSettings: ActionCodeSettings(
        url: _actionContinueUrl(),
        handleCodeInApp: true,
        androidPackageName: 'com.agriledger.agriledger',
        androidInstallApp: true,
        iOSBundleId: 'com.agriledger.agriledger',
      ),
    );
  }

  Future<void> confirmPasswordReset({
    required String code,
    required String newPassword,
  }) {
    return _auth.confirmPasswordReset(code: code, newPassword: newPassword);
  }

  /// Web only: control session vs persistent login.
  Future<void> setRememberMe(bool remember) async {
    if (kIsWeb) {
      await _auth.setPersistence(
        remember ? Persistence.LOCAL : Persistence.SESSION,
      );
    }
  }

  String _actionContinueUrl() {
    // Must be in Firebase Console → Authorized domains.
    return 'https://agriledger-fd203.firebaseapp.com/__/auth/action';
  }
}
