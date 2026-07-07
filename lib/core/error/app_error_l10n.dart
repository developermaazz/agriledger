import 'package:flutter/widgets.dart';

import '../../l10n/app_localizations.dart';
import '../../shared/l10n/l10n.dart';
import 'app_error.dart';

/// Maps a typed [AppError] to a localized, user-friendly message.
extension AppErrorL10n on AppError {
  String localizedMessage(AppLocalizations l10n) {
    return switch (code) {
      AppErrorCode.notSignedIn => l10n.errorsNotSignedIn,
      AppErrorCode.recordLocked => l10n.errorsRecordLocked,
      AppErrorCode.marketInUse => l10n.errorsMarketInUse,
      AppErrorCode.marketNotFound => l10n.errorsMarketNotFound,
      AppErrorCode.invalidCredentials => l10n.errorsInvalidCredentials,
      AppErrorCode.emailAlreadyInUse => l10n.errorsEmailInUse,
      AppErrorCode.weakPassword => l10n.errorsWeakPassword,
      AppErrorCode.invalidEmail => l10n.errorsInvalidEmail,
      AppErrorCode.userDisabled => l10n.errorsUserDisabled,
      AppErrorCode.network => l10n.errorsNetwork,
      AppErrorCode.permissionDenied => l10n.errorsFirestoreBlocked,
      AppErrorCode.storageFailed => l10n.errorsStorageFailed,
      AppErrorCode.unknown => l10n.errorsSomethingWentWrong,
    };
  }
}

/// Resolves any thrown [error] to a user-friendly, localized message.
///
/// Typed [AppError]s get their specific message; anything else falls back to a
/// generic message so raw backend errors are never shown to end users.
String appErrorMessage(BuildContext context, Object error) {
  final l10n = context.l10n;
  if (error is AppError) {
    return error.localizedMessage(l10n);
  }
  return l10n.errorsSomethingWentWrong;
}
