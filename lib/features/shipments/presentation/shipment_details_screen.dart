import 'package:flutter/material.dart';

import '../../../domain/record_status.dart';
import '../../../models/shipment.dart';
import '../../../shared/widgets/status_badge.dart';

class ShipmentDetailsScreen extends StatelessWidget {
  const ShipmentDetailsScreen({
    super.key,
    required this.shipment,
  });

  final Shipment shipment;

  @override
  Widget build(BuildContext context) {
    final s = shipment;
    return Scaffold(
      appBar: AppBar(
        title: Text('Shipment #${s.serial}'),
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
                      s.marketName,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  StatusBadge(status: s.status),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          _kv('Buyer', s.buyerName),
          _kv('Date', s.date.toString().split(' ').first),
          _kv('Quantity', s.quantity.toStringAsFixed(2)),
          _kv('Total amount', s.totalAmount.toStringAsFixed(2)),
          _kv('Amount received', s.amountReceived.toStringAsFixed(2)),
          _kv('Balance', s.balance.toStringAsFixed(2)),
          _kv('Status', _labelStatus(s.status)),
          _kv('Remarks', s.remarks.isEmpty ? '-' : s.remarks),
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

