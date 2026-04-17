import 'package:agri_ledger/shared/formatters/money.dart';
import 'package:flutter/material.dart';

import '../../../app/app_dependencies.dart';
import '../../../domain/record_status.dart';
import '../../../models/shipment.dart';
import '../../../shared/l10n/l10n.dart';
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
        title: Text(context.l10n.shipmentDetailAppBarTitle(s.serial)),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            AppDependencies.of(context).shipmentRepository.refreshFromServer(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
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
            _kv(context.l10n.shipmentsBuyerLabel, s.buyerName),
            _kv(context.l10n.shipmentsDateLabel, s.date.toString().split(' ').first),
            _kv(context.l10n.shipmentsQuantityLabel, s.quantity.toStringAsFixed(2)),
            _kv(context.l10n.shipmentsTotalAmountLabel, MoneyFmt.of(s.totalAmount)),
            _kv(context.l10n.shipmentsAmountReceivedLabel, MoneyFmt.of(s.amountReceived)),
            _kv(context.l10n.cashBalanceLabel, MoneyFmt.of(s.balance)),
            _kv(context.l10n.commonStatus, _labelStatus(context, s.status)),
            _kv(context.l10n.shipmentsRemarksLabel, s.remarks.isEmpty ? '-' : s.remarks),
          ],
        ),
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

