/// Backend-neutral authenticated user.
///
/// Replaces Firebase `User` / `UserCredential` leaking into the UI. Every
/// backend (Firebase, local, …) maps its own identity onto this shape, so the
/// presentation layer never depends on a concrete auth SDK.
class AuthUser {
  const AuthUser({
    required this.uid,
    this.email,
    required this.isAnonymous,
  });

  /// Stable per-account id. Used as the tenant key for all user-scoped data.
  final String uid;

  /// Email for password accounts; `null` for anonymous/guest sessions.
  final String? email;

  /// Whether this is an anonymous/guest session.
  final bool isAnonymous;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthUser &&
          other.uid == uid &&
          other.email == email &&
          other.isAnonymous == isAnonymous;

  @override
  int get hashCode => Object.hash(uid, email, isAnonymous);
}
