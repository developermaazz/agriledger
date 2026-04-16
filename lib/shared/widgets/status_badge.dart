import 'package:flutter/material.dart';

import '../../domain/record_status.dart';

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
        ? 'Completed'
        : isPending
            ? 'Pending'
            : 'Overpaid';
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
