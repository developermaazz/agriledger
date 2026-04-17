import 'package:flutter/material.dart';

import '../../../models/cash_entry.dart';

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
          _kv('Date', e.date.toString().split(' ').first),
          _kv('Amount received', e.amountReceived.toStringAsFixed(2)),
          _kv('Payments', e.payments.toStringAsFixed(2)),
          _kv('Previous cash', e.previousCash.toStringAsFixed(2)),
          _kv('Cash available', e.cashAvailable.toStringAsFixed(2)),
          _kv('Balance', e.balance.toStringAsFixed(2)),
          _kv('Remarks', e.remarks.isEmpty ? '-' : e.remarks),
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

