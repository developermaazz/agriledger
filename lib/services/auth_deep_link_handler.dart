import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

enum PendingAuthKind { resetPassword, emailVerifiedFromLink, linkError }

/// Holds pending Firebase Auth action codes from email links (verify / reset).
class AuthDeepLinkHandler {
  AuthDeepLinkHandler({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  final ValueNotifier<PendingAuthAction?> pending =
      ValueNotifier<PendingAuthAction?>(null);

  /// Parse `__/auth/action?mode=...&oobCode=...` style links.
  Future<void> handleUri(Uri uri) async {
    final qp = uri.queryParameters;
    final mode = qp['mode'];
    final oobCode = qp['oobCode'];
    if (oobCode == null || oobCode.isEmpty) return;
    switch (mode) {
      case 'resetPassword':
        pending.value = PendingAuthAction(
          kind: PendingAuthKind.resetPassword,
          oobCode: oobCode,
        );
        break;
      case 'verifyEmail':
        try {
          await _auth.applyActionCode(oobCode);
          await _auth.currentUser?.reload();
          pending.value = const PendingAuthAction(
            kind: PendingAuthKind.emailVerifiedFromLink,
          );
        } on FirebaseAuthException catch (e) {
          pending.value = PendingAuthAction(
            kind: PendingAuthKind.linkError,
            message: e.message ?? e.code,
          );
        }
        break;
      default:
        break;
    }
  }

  void clear() {
    pending.value = null;
  }
}

class PendingAuthAction {
  const PendingAuthAction({
    required this.kind,
    this.oobCode,
    this.message,
  });

  final PendingAuthKind kind;
  final String? oobCode;
  final String? message;
}
