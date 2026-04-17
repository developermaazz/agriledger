import 'package:agri_ledger/shared/formatters/money.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../app/app_dependencies.dart';
import '../../../models/cash_entry.dart';
import '../../../shared/l10n/l10n.dart';
import '../../../shared/widgets/detail_metric_tile.dart';

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
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final loc = Localizations.localeOf(context).toString();
    final dateStr = DateFormat.yMMMMd(loc).format(e.date);

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        scrolledUnderElevation: 0,
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
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    cs.secondaryContainer.withValues(alpha: 0.9),
                    cs.surfaceContainerLow,
                  ],
                ),
                border: Border.all(
                  color: cs.outlineVariant.withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cs.surface.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.account_balance_wallet_rounded,
                      size: 28,
                      color: cs.secondary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          marketName,
                          style: t.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          dateStr,
                          style: t.bodyLarge?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            DetailMetricTile(
              icon: Icons.south_west_rounded,
              label: context.l10n.cashAmountReceivedLabel,
              value: MoneyFmt.of(e.amountReceived),
              accent: cs.primary,
            ),
            DetailMetricTile(
              icon: Icons.north_east_rounded,
              label: context.l10n.cashPaymentsLabel,
              value: MoneyFmt.of(e.payments),
              accent: cs.tertiary,
            ),
            DetailMetricTile(
              icon: Icons.history_rounded,
              label: context.l10n.cashPreviousCashLabel,
              value: MoneyFmt.of(e.previousCash),
            ),
            DetailMetricTile(
              icon: Icons.savings_outlined,
              label: context.l10n.cashCashAvailableLabel,
              value: MoneyFmt.of(e.cashAvailable),
              accent: cs.secondary,
            ),
            DetailMetricTile(
              icon: Icons.balance_rounded,
              label: context.l10n.cashBalanceLabel,
              value: MoneyFmt.of(e.balance),
              accent: e.balance != 0 ? cs.error : cs.secondary,
            ),
            const SizedBox(height: 8),
            Material(
              color: cs.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: cs.outlineVariant.withValues(alpha: 0.45),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.notes_rounded, size: 20, color: cs.primary),
                        const SizedBox(width: 8),
                        Text(
                          context.l10n.cashRemarksLabel,
                          style: t.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      e.remarks.isEmpty ? '—' : e.remarks,
                      style: t.bodyMedium?.copyWith(
                        height: 1.45,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
