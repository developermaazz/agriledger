import 'package:flutter/material.dart';

import '../../../domain/record_status.dart';
import '../../../models/labour_job.dart';
import '../../../shared/widgets/status_badge.dart';

class LabourDetailsScreen extends StatelessWidget {
  const LabourDetailsScreen({
    super.key,
    required this.job,
  });

  final LabourJob job;

  @override
  Widget build(BuildContext context) {
    final j = job;
    return Scaffold(
      appBar: AppBar(
        title: Text('Labour #${j.serial}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${j.dateStart.toString().split(' ').first} → ${j.dateEnd.toString().split(' ').first}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  StatusBadge(status: j.status),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          _kv('Total cost', j.totalCost.toStringAsFixed(2)),
          _kv('Received payment', j.receivedPayment.toStringAsFixed(2)),
          _kv('Remaining balance', j.remainingBalance.toStringAsFixed(2)),
          _kv('Status', _labelStatus(j.status)),
          _kv('Remarks', j.remarks.isEmpty ? '-' : j.remarks),
        ],
      ),
    );
  }

  String _labelStatus(String s) {
    if (s == RecordStatuses.pending) return 'Pending';
    if (s == RecordStatuses.completed) return 'Completed';
    if (s == RecordStatuses.overpaid) return 'Overpaid';
    return s;
  }

  Widget _kv(String k, String v) {
    return Card(
      child: ListTile(
        title: Text(k),
        subtitle: Text(v),
      ),
    );
  }
}

