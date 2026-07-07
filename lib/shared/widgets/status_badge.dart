import 'package:flutter/material.dart';

import '../../app/theme/app_tokens.dart';
import '../../domain/record_status.dart';
import '../l10n/l10n.dart';

/// Pill badge for a record status. Uses theme-aware semantic tokens (completed →
/// success, pending → danger, overpaid → warning) so it adapts to dark mode.
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final isDone = status == RecordStatuses.completed;
    final isPending = status == RecordStatuses.pending;

    final (Color fg, Color container, String label) = isDone
        ? (
            tokens.onSuccessContainer,
            tokens.successContainer,
            context.l10n.commonCompleted
          )
        : isPending
            ? (
                tokens.onDangerContainer,
                tokens.dangerContainer,
                context.l10n.commonPending
              )
            : (
                tokens.onWarningContainer,
                tokens.warningContainer,
                context.l10n.commonOverpaid
              );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: container,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: fg,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
