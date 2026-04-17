import 'package:flutter/material.dart';

import '../../domain/record_status.dart';
import '../l10n/l10n.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final isDone = status == RecordStatuses.completed;
    final isPending = status == RecordStatuses.pending;
    final color = isDone
        ? Colors.green.shade800
        : isPending
            ? Colors.red.shade800
            : Colors.orange.shade900;
    final label = isDone
        ? context.l10n.commonCompleted
        : isPending
            ? context.l10n.commonPending
            : context.l10n.commonOverpaid;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
