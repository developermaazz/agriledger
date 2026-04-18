import 'package:flutter/material.dart';

import '../../../app/app_dependencies.dart';
import '../../../app/app_router.dart';
import '../../../shared/auth/auth_error_messages.dart';
import '../../../shared/l10n/l10n.dart';
import '../../../shared/snackbar/app_snackbar.dart';
import 'widgets/auth_page_scaffold.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool _busy = false;

  Future<void> _resendLink() async {
    setState(() => _busy = true);
    try {
      await AppDependencies.of(context).authService.sendEmailVerification();
      if (!mounted) return;
      AppSnackBar.show(
        context,
        message: context.l10n.authVerificationEmailSent,
        type: AppSnackType.success,
      );
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.show(
        context,
        message: messageForAuthException(context, e),
        type: AppSnackType.error,
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _reloadVerified() async {
    setState(() => _busy = true);
    try {
      final deps = AppDependencies.of(context);
      await deps.authService.reloadCurrentUser();
      if (!mounted) return;
      final u = deps.authService.currentUser;
      if (u?.emailVerified == true) {
        final completedMessage = context.l10n.authEmailVerificationCompleted;
        AppSnackBar.showAfterRoutePopped(
          message: completedMessage,
          type: AppSnackType.success,
        );
        await deps.authService.signOut();
        if (!mounted) return;
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.login,
          (r) => false,
        );
      } else {
        AppSnackBar.show(
          context,
          message: context.l10n.authVerificationStillPending,
          type: AppSnackType.info,
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return AuthPageScaffold(
      maxWidth: 480,
      child: Material(
        color: cs.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.5)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.l10n.authVerifyTitle,
                style: t.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.authVerifySubtitle,
                style: t.bodyMedium?.copyWith(color: cs.onSurfaceVariant, height: 1.4),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              _LinkTab(
                busy: _busy,
                onResend: _resendLink,
                onContinue: _reloadVerified,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LinkTab extends StatelessWidget {
  const _LinkTab({
    required this.busy,
    required this.onResend,
    required this.onContinue,
  });

  final bool busy;
  final VoidCallback onResend;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilledButton.tonal(
            onPressed: busy ? null : onResend,
            child: Text(context.l10n.authResendVerificationEmail),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: busy ? null : onContinue,
            child: Text(context.l10n.authCheckedVerification),
          ),
          const SizedBox(height: 12),
          Text(
            context.l10n.authVerifySubtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
