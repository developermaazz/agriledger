import 'package:agri_ledger/domain/record_status.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../app/app_dependencies.dart';
import '../../../models/labour_job.dart';
import '../../../models/market.dart';
import '../../../models/shipment.dart';
import '../../../services/firestore_refresh.dart';
import '../../../services/market_cash_repository.dart';
import '../../../shared/formatters/money.dart';
import '../../../shared/l10n/l10n.dart';
import '../../../shared/widgets/firestore_error_view.dart';
import '../../../shared/widgets/pull_to_refresh.dart';

Future<void> _refreshDashboardData(BuildContext context) {
  final d = AppDependencies.of(context);
  return refreshAllUserDataFromServer(
    shipmentRepository: d.shipmentRepository,
    labourRepository: d.labourRepository,
    marketRepository: d.marketRepository,
    marketCashRepository: d.marketCashRepository,
  );
}

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
                    return RefreshIndicator(
                      onRefresh: () => _refreshDashboardData(context),
                      child: MinHeightRefreshContent(
                        child: FirestoreErrorView(
                          error: firstError,
                          title: context.l10n.dashboardUnableToLoad,
                        ),
                      ),
                    );
                  }
                  if (!shipSnap.hasData ||
                      !labourSnap.hasData ||
                      !marketSnap.hasData) {
                    return RefreshIndicator(
                      onRefresh: () => _refreshDashboardData(context),
                      child: MinHeightRefreshContent(
                        child: const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      ),
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
                        return RefreshIndicator(
                          onRefresh: () => _refreshDashboardData(context),
                          child: MinHeightRefreshContent(
                            child: FirestoreErrorView(
                              error: cashSnap.error!,
                              title: context.l10n.dashboardUnableToLoadCash,
                            ),
                          ),
                        );
                      }
                      final totalCash = cashSnap.data ?? 0;
                      return RefreshIndicator(
                        onRefresh: () => _refreshDashboardData(context),
                        child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                        children: [
                          _SectionHeader(
                            title: context.l10n.dashboardOverview,
                            subtitle: context.l10n.dashboardOverviewSubtitle,
                          ),
                          const SizedBox(height: 12),
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
                          const SizedBox(height: 28),
                          _SectionHeader(
                            title: context.l10n.dashboardPendingShipments,
                            subtitle: context.l10n.dashboardPendingShipmentsSubtitle,
                          ),
                          const SizedBox(height: 12),
                          ..._pendingShipments(context, shipments),
                          const SizedBox(height: 28),
                          _SectionHeader(
                            title: context.l10n.dashboardCompletedShipments,
                            subtitle: context.l10n.dashboardCompletedShipmentsSubtitle,
                          ),
                          const SizedBox(height: 12),
                          ..._completedShipments(context, shipments),
                          const SizedBox(height: 28),
                          _SectionHeader(
                            title: context.l10n.dashboardRecentActivity,
                            subtitle: context.l10n.dashboardRecentActivitySubtitle,
                          ),
                          const SizedBox(height: 12),
                          ..._recent(context, shipments, labour),
                        ],
                        ),
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

  static String _fmtDate(BuildContext context, DateTime d) {
    final loc = Localizations.localeOf(context).toString();
    return DateFormat.yMMMd(loc).format(d);
  }

  static String _fmtDateTime(BuildContext context, DateTime d) {
    final loc = Localizations.localeOf(context).toString();
    return DateFormat('d MMM yyyy · HH:mm', loc).format(d);
  }

  static List<Widget> _pendingShipments(BuildContext context, List<Shipment> all) {
    final list =
        all.where((s) => s.status == RecordStatuses.pending).take(8).toList();
    if (list.isEmpty) {
      return [_EmptyHint(message: context.l10n.dashboardNone)];
    }
    return list
        .map(
          (s) => _DashboardListCard(
            accentColor: Theme.of(context).colorScheme.error,
            leadingIcon: Icons.local_shipping_outlined,
            title: '${s.marketName} · ${s.buyerName}',
            subtitle: context.l10n.dashboardBalanceLabel(MoneyFmt.of(s.balance)),
            trailing: _AmountChip(
              value: MoneyFmt.of(s.balance),
              tone: _ChipTone.pending,
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
      return [_EmptyHint(message: context.l10n.dashboardNone)];
    }
    final cs = Theme.of(context).colorScheme;
    return list
        .map(
          (s) => _DashboardListCard(
            accentColor: cs.tertiary,
            leadingIcon: Icons.check_rounded,
            title: '${s.marketName} · ${s.buyerName}',
            subtitle:
                '${_fmtDate(context, s.date)} · ${context.l10n.dashboardCompletedValueLabel}',
            trailing: _AmountChip(
              value: MoneyFmt.of(s.totalAmount),
              tone: _ChipTone.success,
            ),
          ),
        )
        .toList();
  }

  static List<Widget> _recent(
    BuildContext context,
    List<Shipment> s,
    List<LabourJob> l,
  ) {
    final items = <_RecentItem>[];
    final l10n = context.l10n;
    for (final x in s) {
      items.add(
        _RecentItem(
          time: x.updatedAt ?? x.date,
          kind: _ActivityKind.shipment,
          title: l10n.dashboardActivityShipmentTitle(x.serial, x.marketName),
          subtitle: l10n.dashboardActivityPaymentReceivedCaption(
            MoneyFmt.of(x.amountReceived),
          ),
        ),
      );
    }
    for (final x in l) {
      items.add(
        _RecentItem(
          time: x.updatedAt ?? x.dateEnd,
          kind: _ActivityKind.labour,
          title: l10n.dashboardActivityLabourTitle(x.serial),
          subtitle: l10n.dashboardActivityLabourPaidCaption(
            MoneyFmt.of(x.receivedPayment),
          ),
        ),
      );
    }
    items.sort((a, b) => b.time.compareTo(a.time));
    final top = items.take(10).toList();
    if (top.isEmpty) {
      return [_EmptyHint(message: context.l10n.dashboardNoRecentUpdates)];
    }
    return top
        .map(
          (e) => _RecentActivityTile(
            item: e,
            timeLabel: _fmtDateTime(context, e.time),
          ),
        )
        .toList();
  }
}

enum _ActivityKind { shipment, labour }

class _RecentItem {
  _RecentItem({
    required this.time,
    required this.kind,
    required this.title,
    required this.subtitle,
  });

  final DateTime time;
  final _ActivityKind kind;
  final String title;
  final String subtitle;
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
        ),
      ),
    );
  }
}

class _DashboardListCard extends StatelessWidget {
  const _DashboardListCard({
    required this.accentColor,
    required this.leadingIcon,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  final Color accentColor;
  final IconData leadingIcon;
  final String title;
  final String subtitle;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final iconBg = accentColor.withValues(alpha: 0.14);
    final iconFg = accentColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: cs.surfaceContainerLow,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: cs.outlineVariant.withValues(alpha: 0.45),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 10, 12, 10),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 48,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(leadingIcon, size: 22, color: iconFg),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: t.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
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
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.72,
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
    return Material(
      color: bg,
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: cs.outlineVariant.withValues(alpha: tone == _KpiTone.neutral ? 0.4 : 0.25),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: fg.withValues(alpha: 0.88),
                      height: 1.15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
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
  const _SectionHeader({
    required this.title,
    this.subtitle,
  });

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final cs = t.colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 3,
          height: 24,
          margin: const EdgeInsets.only(top: 2),
          decoration: BoxDecoration(
            color: cs.primary,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: t.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: t.textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                    height: 1.2,
                  ),
                ),
              ],
            ],
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: fg.withValues(alpha: 0.12),
        ),
      ),
      child: Text(
        value,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: fg,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
      ),
    );
  }
}

class _RecentActivityTile extends StatelessWidget {
  const _RecentActivityTile({
    required this.item,
    required this.timeLabel,
  });

  final _RecentItem item;
  final String timeLabel;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final isShipment = item.kind == _ActivityKind.shipment;
    final icon = isShipment ? Icons.local_shipping_outlined : Icons.engineering_outlined;
    final iconBg = isShipment ? cs.secondaryContainer : cs.tertiaryContainer;
    final iconFg = isShipment ? cs.onSecondaryContainer : cs.onTertiaryContainer;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: cs.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: cs.outlineVariant.withValues(alpha: 0.45),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 22, color: iconFg),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: t.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.subtitle,
                      style: t.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_outlined,
                          size: 14,
                          color: cs.onSurfaceVariant.withValues(alpha: 0.85),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            timeLabel,
                            style: t.labelSmall?.copyWith(
                              color: cs.onSurfaceVariant,
                              letterSpacing: 0.1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
