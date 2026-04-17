import 'package:agri_ledger/shared/formatters/money.dart';
import 'package:flutter/material.dart';

import '../../../domain/record_status.dart';
import '../../../models/labour_job.dart';
import '../../../shared/l10n/l10n.dart';
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
        title: Text(context.l10n.labourDetailAppBarTitle(j.serial)),
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
          _kv(context.l10n.labourTotalCostLabel, MoneyFmt.of(j.totalCost)),
          _kv(context.l10n.labourReceivedPaymentLabel, MoneyFmt.of(j.receivedPayment)),
          _kv(context.l10n.labourRemainingAuto, MoneyFmt.of(j.remainingBalance)),
          _kv(context.l10n.commonStatus, _labelStatus(context, j.status)),
          _kv(context.l10n.labourRemarksLabel, j.remarks.isEmpty ? '-' : j.remarks),
        ],
      ),
    );
  }

  String _labelStatus(BuildContext context, String s) {
    if (s == RecordStatuses.pending) return context.l10n.commonPending;
    if (s == RecordStatuses.completed) return context.l10n.commonCompleted;
    if (s == RecordStatuses.overpaid) return context.l10n.commonOverpaid;
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

