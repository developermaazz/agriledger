import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../app/app_navigator.dart';

enum AppSnackType {
  success,
  error,
  warning,
  info,
}

class AppSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    AppSnackType type = AppSnackType.info,
    Duration duration = const Duration(seconds: 3),
    bool clearPrevious = true,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    if (clearPrevious) {
      messenger.clearSnackBars();
    }

    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final (bg, fg, icon) = switch (type) {
      AppSnackType.success => (
          cs.primaryContainer,
          cs.onPrimaryContainer,
          Icons.check_circle_outline,
        ),
      AppSnackType.error => (
          cs.errorContainer,
          cs.onErrorContainer,
          Icons.error_outline,
        ),
      AppSnackType.warning => (
          cs.tertiaryContainer,
          cs.onTertiaryContainer,
          Icons.warning_amber_outlined,
        ),
      AppSnackType.info => (
          cs.secondaryContainer,
          cs.onSecondaryContainer,
          Icons.info_outline,
        ),
    };

    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        duration: duration,
        backgroundColor: bg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: fg.withValues(alpha: 0.12)),
        ),
        content: Row(
          children: [
            Icon(icon, color: fg),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(color: fg),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Shows after [Navigator.pop] when the route context is no longer valid.
  static void showAfterRoutePopped({
    required String message,
    AppSnackType type = AppSnackType.success,
  }) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final ctx = appNavigatorKey.currentContext;
      if (ctx != null && ctx.mounted) {
        show(ctx, message: message, type: type);
      }
    });
  }
}

