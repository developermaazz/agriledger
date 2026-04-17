import 'package:agri_ledger/domain/record_status.dart';
import 'package:flutter/material.dart';

import '../../../app/app_dependencies.dart';
import '../../../models/labour_job.dart';
import '../../../models/market.dart';
import '../../../models/shipment.dart';
import '../../../services/market_cash_repository.dart';
import '../../../shared/formatters/money.dart';
import '../../../shared/l10n/l10n.dart';
import '../../../shared/widgets/firestore_error_view.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shipmentsRepo = AppDependencies.of(context).shipmentRepository;
    final labourRepo = AppDependencies.of(context).labourRepository;
    final marketRepo = AppDependencies.of(context).marketRepository;
    final cashRepo = AppDependencies.of(context).marketCashRepository;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.dashboardTitle),
      ),
      body: StreamBuilder<List<Shipment>>(
        stream: shipmentsRepo.watchShipments(),
        builder: (context, shipSnap) {
          return StreamBuilder<List<LabourJob>>(
            stream: labourRepo.watchLabourJobs(),
            builder: (context, labourSnap) {
              return StreamBuilder<List<Market>>(
                stream: marketRepo.watchMarkets(),
                builder: (context, marketSnap) {
                  final firstError =
                      shipSnap.error ?? labourSnap.error ?? marketSnap.error;
                  if (firstError != null) {
                    return FirestoreErrorView(
                      error: firstError,
                      title: context.l10n.dashboardUnableToLoad,
                    );
                  }
                  if (!shipSnap.hasData ||
                      !labourSnap.hasData ||
                      !marketSnap.hasData) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                  final shipments = shipSnap.data!;
                  final labour = labourSnap.data!;
                  final markets = marketSnap.data!;

                  final totalShipments = shipments.length;
                  final totalRevenue =
                      shipments.fold<double>(0, (a, s) => a + s.totalAmount);
                  final totalReceived =
                      shipments.fold<double>(0, (a, s) => a + s.amountReceived);
                  final pendingShipments = shipments
                      .where((s) => s.status == RecordStatuses.pending)
                      .fold<double>(0, (a, s) => a + s.balance);
                  final pendingLabour = labour
                      .where((j) => j.status == RecordStatuses.pending)
                      .fold<double>(0, (a, j) => a + j.remainingBalance);
                  final labourCost =
                      labour.fold<double>(0, (a, j) => a + j.totalCost);

                  return FutureBuilder<double>(
                    future: _sumMarketCash(markets, cashRepo),
                    builder: (context, cashSnap) {
                      if (cashSnap.hasError) {
                        return FirestoreErrorView(
                          error: cashSnap.error!,
                          title: 'Unable to load market cash totals',
                        );
                      }
                      final totalCash = cashSnap.data ?? 0;
                      return ListView(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                        children: [
                          _SectionHeader(title: context.l10n.dashboardOverview),
                          const SizedBox(height: 10),
                          _KpiGrid(
                            children: [
                              _KpiCard(
                                icon: Icons.local_shipping_outlined,
                                label: context.l10n.dashboardTotalShipments,
                                value: '$totalShipments',
                                tone: _KpiTone.neutral,
                              ),
                              _KpiCard(
                                icon: Icons.payments_outlined,
                                label: context.l10n.dashboardTotalRevenue,
                                value: MoneyFmt.of(totalRevenue),
                                tone: _KpiTone.positive,
                              ),
                              _KpiCard(
                                icon: Icons.savings_outlined,
                                label: context.l10n.dashboardAmountReceived,
                                value: MoneyFmt.of(totalReceived),
                                tone: _KpiTone.info,
                              ),
                              _KpiCard(
                                icon: Icons.pending_actions_outlined,
                                label: context.l10n.dashboardPendingShipmentsKpi,
                                value: MoneyFmt.of(pendingShipments),
                                tone: _KpiTone.pending,
                              ),
                              _KpiCard(
                                icon: Icons.account_balance_wallet_outlined,
                                label: context.l10n.dashboardCashAvailable,
                                value: MoneyFmt.of(totalCash),
                                tone: _KpiTone.success,
                              ),
                              _KpiCard(
                                icon: Icons.engineering_outlined,
                                label: context.l10n.dashboardLabourExpenses,
                                value: MoneyFmt.of(labourCost),
                                tone: _KpiTone.warning,
                              ),
                              _KpiCard(
                                icon: Icons.timelapse_outlined,
                                label: context.l10n.dashboardPendingLabourKpi,
                                value: MoneyFmt.of(pendingLabour),
                                tone: _KpiTone.pending,
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          _SectionHeader(title: context.l10n.dashboardPendingShipments),
                          const SizedBox(height: 8),
                          ..._pendingShipments(context, shipments),
                          const SizedBox(height: 14),
                          _SectionHeader(title: context.l10n.dashboardCompletedShipments),
                          const SizedBox(height: 8),
                          ..._completedShipments(context, shipments),
                          const SizedBox(height: 14),
                          _SectionHeader(title: context.l10n.dashboardRecentActivity),
                          const SizedBox(height: 8),
                          ..._recent(context, shipments, labour),
                        ],
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  static Future<double> _sumMarketCash(
    List<Market> markets,
    MarketCashRepository cashRepo,
  ) async {
    double sum = 0;
    for (final m in markets) {
      sum += await cashRepo.latestBalanceForMarket(m.id);
    }
    return sum;
  }

  static List<Widget> _pendingShipments(BuildContext context, List<Shipment> all) {
    final list =
        all.where((s) => s.status == RecordStatuses.pending).take(8).toList();
    if (list.isEmpty) {
      return [const _L10nText('dashboardNone')];
    }
    return list
        .map(
          (s) => Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    radius: 18,
                    backgroundColor:
                        Theme.of(context).colorScheme.errorContainer,
                    foregroundColor:
                        Theme.of(context).colorScheme.onErrorContainer,
                    child: const Icon(Icons.local_shipping_outlined, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${s.marketName} · ${s.buyerName}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          context.l10n.dashboardBalanceLabel(MoneyFmt.of(s.balance)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  _AmountChip(
                    value: MoneyFmt.of(s.balance),
                    tone: _ChipTone.pending,
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();
  }

  static List<Widget> _completedShipments(BuildContext context, List<Shipment> all) {
    final list = all
        .where((s) => s.status == RecordStatuses.completed)
        .take(5)
        .toList();
    if (list.isEmpty) {
      return [const _L10nText('dashboardNone')];
    }
    return list
        .map(
          (s) => Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.green.shade800,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    radius: 18,
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    foregroundColor:
                        Theme.of(context).colorScheme.onPrimaryContainer,
                    child: const Icon(Icons.check_circle_outline, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${s.marketName} · ${s.buyerName}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          s.date.toString().split(' ').first,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  _AmountChip(
                    value: MoneyFmt.of(s.totalAmount),
                    tone: _ChipTone.success,
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();
  }

  static List<Widget> _recent(BuildContext context, List<Shipment> s, List<LabourJob> l) {
    final items = <_RecentItem>[];
    for (final x in s) {
      items.add(
        _RecentItem(
          time: x.updatedAt ?? x.date,
          text:
              'Shipment #${x.serial} ${x.marketName} · recv ${MoneyFmt.of(x.amountReceived)}',
        ),
      );
    }
    for (final x in l) {
      items.add(
        _RecentItem(
          time: x.updatedAt ?? x.dateEnd,
          text:
              'Labour #${x.serial} paid ${MoneyFmt.of(x.receivedPayment)}',
        ),
      );
    }
    items.sort((a, b) => b.time.compareTo(a.time));
    final top = items.take(10).toList();
    if (top.isEmpty) {
      return [const _L10nText('dashboardNoRecentUpdates')];
    }
    return top
        .map(
          (e) => _RecentTimelineTile(item: e),
        )
        .toList();
  }
}

/// Small helper to keep "const" call sites where possible.
class _L10nText extends StatelessWidget {
  const _L10nText(this.keyName);

  final String keyName;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = switch (keyName) {
      'dashboardNone' => l10n.dashboardNone,
      'dashboardNoRecentUpdates' => l10n.dashboardNoRecentUpdates,
      _ => keyName,
    };
    return Text(text);
  }
}

class _RecentItem {
  _RecentItem({required this.time, required this.text});

  final DateTime time;
  final String text;
}

class _KpiGrid extends StatelessWidget {
  const _KpiGrid({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        final cols = w > 840 ? 4 : (w > 560 ? 3 : 2);
        return GridView.count(
          crossAxisCount: cols,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1.8,
          children: children,
        );
      },
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.icon,
    required this.label,
    required this.value,
    this.tone = _KpiTone.neutral,
  });

  final IconData icon;
  final String label;
  final String value;
  final _KpiTone tone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final (bg, fg) = switch (tone) {
      _KpiTone.pending => (cs.errorContainer, cs.onErrorContainer),
      _KpiTone.warning => (cs.tertiaryContainer, cs.onTertiaryContainer),
      _KpiTone.positive => (cs.primaryContainer, cs.onPrimaryContainer),
      _KpiTone.success => (cs.secondaryContainer, cs.onSecondaryContainer),
      _KpiTone.info => (cs.surfaceContainerHighest, cs.onSurface),
      _KpiTone.neutral => (cs.surfaceContainerHighest, cs.onSurface),
    };
    return Card(
      elevation: 0,
      color: bg,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: fg.withValues(alpha: 0.88)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: fg.withValues(alpha: 0.88),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: fg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _KpiTone {
  neutral,
  pending,
  warning,
  positive,
  success,
  info,
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: t.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

enum _ChipTone { pending, success, neutral }

class _AmountChip extends StatelessWidget {
  const _AmountChip({required this.value, required this.tone});

  final String value;
  final _ChipTone tone;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final (bg, fg) = switch (tone) {
      _ChipTone.pending => (cs.errorContainer, cs.onErrorContainer),
      _ChipTone.success => (cs.secondaryContainer, cs.onSecondaryContainer),
      _ChipTone.neutral => (cs.surfaceContainerHigh, cs.onSurface),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        value,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: fg,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _RecentTimelineTile extends StatelessWidget {
  const _RecentTimelineTile({required this.item});

  final _RecentItem item;

  @override
  Widget build(BuildContext context) {
    final isShipment = item.text.startsWith('Shipment');
    final cs = Theme.of(context).colorScheme;
    final icon = isShipment ? Icons.local_shipping_outlined : Icons.engineering_outlined;
    final iconBg = isShipment ? cs.secondaryContainer : cs.tertiaryContainer;
    final iconFg = isShipment ? cs.onSecondaryContainer : cs.onTertiaryContainer;

    return Card(
      elevation: 0,
      color: cs.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: iconBg,
                  foregroundColor: iconFg,
                  child: Icon(icon, size: 18),
                ),
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.text,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.time.toString().split('.').first,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
