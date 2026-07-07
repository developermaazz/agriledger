/// Stable, backend-agnostic error codes surfaced to the UI.
///
/// The presentation layer maps these to localized, user-friendly messages
/// (see `app_error_l10n.dart`) — screens never inspect backend-specific
/// exception types (Firestore, FirebaseAuth, sqlite, …).
enum AppErrorCode {
  /// No authenticated session.
  notSignedIn,

  /// A completed shipment/labour record cannot be edited or deleted.
  recordLocked,

  /// A market still referenced by shipments cannot be deleted.
  marketInUse,

  /// A referenced market does not exist.
  marketNotFound,

  /// Wrong password / unknown user / bad credentials.
  invalidCredentials,

  /// Registration with an email that already has an account.
  emailAlreadyInUse,

  /// Password does not meet the backend's strength requirement.
  weakPassword,

  /// Malformed email address.
  invalidEmail,

  /// The account has been disabled.
  userDisabled,

  /// Connectivity failure.
  network,

  /// Backend rejected the operation (e.g. Firestore rules).
  permissionDenied,

  /// A storage read/write failed.
  storageFailed,

  /// Anything not otherwise classified.
  unknown,
}

/// Typed application error raised by the data/auth/storage layer.
///
/// UI maps [code] to a localized message; [cause] retains the original error
/// (Firestore/FirebaseAuth exception, etc.) for logging without leaking it to
/// the user. Sealed so exhaustive `switch` handling is possible.
sealed class AppError implements Exception {
  const AppError(this.code, {this.cause});

  final AppErrorCode code;
  final Object? cause;

  @override
  String toString() =>
      'AppError(${code.name})${cause == null ? '' : ': $cause'}';
}

/// No authenticated session (was `StateError('Not signed in')`).
final class NotSignedInError extends AppError {
  const NotSignedInError({Object? cause})
      : super(AppErrorCode.notSignedIn, cause: cause);
}

/// A completed shipment/labour record cannot be edited or deleted.
final class RecordLockedError extends AppError {
  const RecordLockedError({Object? cause})
      : super(AppErrorCode.recordLocked, cause: cause);
}

/// A market still referenced by shipments cannot be deleted.
final class MarketInUseError extends AppError {
  const MarketInUseError({Object? cause})
      : super(AppErrorCode.marketInUse, cause: cause);
}

/// A referenced market does not exist (e.g. cash-serial allocation).
final class MarketNotFoundError extends AppError {
  const MarketNotFoundError({Object? cause})
      : super(AppErrorCode.marketNotFound, cause: cause);
}

/// Authentication failure carrying a specific [AppErrorCode].
final class AuthError extends AppError {
  const AuthError(super.code, {super.cause});
}

/// A storage (receipt/attachment) read or write failed.
final class StorageFailedError extends AppError {
  const StorageFailedError({Object? cause})
      : super(AppErrorCode.storageFailed, cause: cause);
}

/// A generic data-layer failure carrying a specific [AppErrorCode]
/// (e.g. [AppErrorCode.permissionDenied], [AppErrorCode.network]).
final class DataError extends AppError {
  const DataError(super.code, {super.cause});
}
