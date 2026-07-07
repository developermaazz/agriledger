import '../value/auth_user.dart';

/// Backend-agnostic authentication + session contract.
///
/// Implemented by each backend (Firebase, local, …). Failures are raised as
/// `AppError` (typically `AuthError`) — never a backend-specific exception.
abstract interface class AuthProvider {
  /// Emits the current [AuthUser] on sign-in and `null` on sign-out. Fires on
  /// startup with the persisted session (or `null`).
  Stream<AuthUser?> authStateChanges();

  /// The currently signed-in user, or `null`.
  AuthUser? get currentUser;

  Future<AuthUser> signInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<AuthUser> registerWithEmailPassword({
    required String email,
    required String password,
  });

  /// Creates/uses an anonymous (guest) session with its own [AuthUser.uid].
  Future<AuthUser> signInAnonymously();

  Future<void> signOut();
}
