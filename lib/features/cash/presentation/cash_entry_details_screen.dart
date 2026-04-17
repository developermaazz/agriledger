import 'package:agri_ledger/shared/formatters/money.dart';
import 'package:flutter/material.dart';

import '../../../app/app_dependencies.dart';
import '../../../models/cash_entry.dart';
import '../../../shared/l10n/l10n.dart';
class CashEntryDetailsScreen extends StatelessWidget {
  const CashEntryDetailsScreen({
    super.key,
    required this.marketId,
    required this.marketName,
    required this.entry,
  });

  final String marketId;
  final String marketName;
  final CashEntry entry;

  @override
  Widget build(BuildContext context) {
    final e = entry;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.cashEntryDetailsAppBarTitle(marketName, e.serial),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => AppDependencies.of(context)
            .marketCashRepository
            .refreshCashEntriesFromServer(marketId),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
          _kv(context.l10n.cashDateLabel, e.date.toString().split(' ').first),
          _kv(context.l10n.cashAmountReceivedLabel, MoneyFmt.of(e.amountReceived)),
          _kv(context.l10n.cashPaymentsLabel, MoneyFmt.of(e.payments)),
          _kv(context.l10n.cashPreviousCashLabel, MoneyFmt.of(e.previousCash)),
          _kv(context.l10n.cashCashAvailableLabel, MoneyFmt.of(e.cashAvailable)),
          _kv(context.l10n.cashBalanceLabel, MoneyFmt.of(e.balance)),
          _kv(context.l10n.cashRemarksLabel, e.remarks.isEmpty ? '-' : e.remarks),
        ],
        ),
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

