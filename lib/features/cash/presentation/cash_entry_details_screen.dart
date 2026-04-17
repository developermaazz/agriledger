import 'package:flutter/material.dart';

import '../../../models/cash_entry.dart';
import '../../../shared/l10n/l10n.dart';

class CashEntryDetailsScreen extends StatelessWidget {
  const CashEntryDetailsScreen({
    super.key,
    required this.marketName,
    required this.entry,
  });

  final String marketName;
  final CashEntry entry;

  @override
  Widget build(BuildContext context) {
    final e = entry;
    return Scaffold(
      appBar: AppBar(
        title: Text('$marketName · #${e.serial}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _kv(context.l10n.cashDateLabel, e.date.toString().split(' ').first),
          _kv(context.l10n.cashAmountReceivedLabel, e.amountReceived.toStringAsFixed(2)),
          _kv(context.l10n.cashPaymentsLabel, e.payments.toStringAsFixed(2)),
          _kv(context.l10n.cashPreviousCashLabel, e.previousCash.toStringAsFixed(2)),
          _kv(context.l10n.cashCashAvailableLabel, e.cashAvailable.toStringAsFixed(2)),
          _kv(context.l10n.cashBalanceLabel, e.balance.toStringAsFixed(2)),
          _kv(context.l10n.cashRemarksLabel, e.remarks.isEmpty ? '-' : e.remarks),
        ],
      ),
    );
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

