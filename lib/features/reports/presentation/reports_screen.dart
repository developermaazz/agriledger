import 'package:agri_ledger/domain/record_status.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../app/app_dependencies.dart';
import '../../../data/refresh/refresh_all.dart';
import '../../../data/export/export_service.dart';
import '../../../shared/formatters/money.dart';
import '../../../shared/l10n/l10n.dart';
import '../../../shared/responsive/breakpoints.dart';
import '../../../shared/responsive/max_width_body.dart';
import '../date_range_utils.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  DateTime _from = startOfDay(DateTime.now()).subtract(const Duration(days: 30));
  DateTime _to = endOfDay(DateTime.now());
  Map<String, dynamic>? _result;
  bool _busy = false;

  Future<void> _refreshUnderlyingData() async {
    final deps = AppDependencies.of(context);
    await refreshAllUserDataFromServer(
      shipmentRepository: deps.shipmentRepository,
      labourRepository: deps.labourRepository,
      marketRepository: deps.marketRepository,
      marketCashRepository: deps.marketCashRepository,
    );
  }

  Future<void> _generate() async {
    setState(() {
      _busy = true;
      _result = null;
    });
    final from = startOfDay(_from);
    final to = endOfDay(_to);

    final deps = AppDependencies.of(context);
    final shipments = await deps.shipmentRepository.watchShipments().first;
    final labour = await deps.labourRepository.watchLabourJobs().first;
    final markets = await deps.marketRepository.watchMarkets().first;

    final sF = shipments.where((s) => isInRange(s.date, from, to)).toList();
    final lF = labour.where((j) => isInRange(j.dateStart, from, to)).toList();

    var cashReceived = 0.0;
    var cashPaid = 0.0;
    for (final m in markets) {
      final entries = await deps.marketCashRepository.fetchCashEntriesOnce(m.id);
      for (final e in entries) {
        if (isInRange(e.date, from, to)) {
          cashReceived += e.amountReceived;
          cashPaid += e.payments;
        }
      }
    }

    final totalShipments = sF.length;
    final totalRevenue = sF.fold<double>(0, (a, s) => a + s.totalAmount);
    final totalReceived = sF.fold<double>(0, (a, s) => a + s.amountReceived);
    final pendingShipments = sF
        .where((s) => s.status == RecordStatuses.pending)
        .fold<double>(0, (a, s) => a + s.balance);
    final pendingLabour = lF
        .where((j) => j.status == RecordStatuses.pending)
        .fold<double>(0, (a, j) => a + j.remainingBalance);
    final labourCost = lF.fold<double>(0, (a, j) => a + j.totalCost);

    double totalCashAvailable = 0;
    for (final m in markets) {
      totalCashAvailable +=
          await deps.marketCashRepository.latestBalanceForMarket(m.id);
    }

    setState(() {
      _busy = false;
      _result = {
        'totalShipments': totalShipments,
        'totalRevenue': totalRevenue,
        'totalReceived': totalReceived,
        'pendingShipments': pendingShipments,
        'pendingLabour': pendingLabour,
        'totalCashAvailable': totalCashAvailable,
        'labourCost': labourCost,
        'cashReceivedInRange': cashReceived,
        'cashPaidInRange': cashPaid,
      };
    });
  }

  Future<void> _exportPdf() async {
    final r = _result;
    if (r == null) {
      return;
    }
    final file = await ExportService.exportSummaryPdf(
      from: startOfDay(_from),
      to: endOfDay(_to),
      totalShipments: r['totalShipments'] as int,
      totalRevenue: r['totalRevenue'] as double,
      totalReceived: r['totalReceived'] as double,
      totalPendingShipments: r['pendingShipments'] as double,
      totalPendingLabour: r['pendingLabour'] as double,
      totalCashAvailable: r['totalCashAvailable'] as double,
      totalLabourCost: r['labourCost'] as double,
    );
    await ExportService.shareFile(file);
  }

  Future<void> _exportExcel() async {
    final r = _result;
    if (r == null) {
      return;
    }
    final file = await ExportService.exportSummaryExcel(
      from: startOfDay(_from),
      to: endOfDay(_to),
      totalShipments: r['totalShipments'] as int,
      totalRevenue: r['totalRevenue'] as double,
      totalReceived: r['totalReceived'] as double,
      totalPendingShipments: r['pendingShipments'] as double,
      totalPendingLabour: r['pendingLabour'] as double,
      totalCashAvailable: r['totalCashAvailable'] as double,
      totalLabourCost: r['labourCost'] as double,
    );
    await ExportService.shareFile(file);
  }

  Widget _dateCard({
    required BuildContext context,
    required String label,
    required DateTime date,
    required VoidCallback onPick,
  }) {
    final cs = Theme.of(context).colorScheme;
    final loc = Localizations.localeOf(context).toString();
    final formatted = DateFormat.yMMMMd(loc).format(date);

    return Material(
      color: cs.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onPick,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(Icons.calendar_month_rounded, color: cs.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: cs.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatted,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.edit_calendar_outlined, color: cs.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text(context.l10n.reportsTitle),
        scrolledUnderElevation: 0,
      ),
      body: MaxWidthBody(
        maxWidth: Breakpoints.contentMaxWidth,
        child: RefreshIndicator(
          onRefresh: () async {
            await _refreshUnderlyingData();
            if (_result != null && mounted) {
              await _generate();
            }
          },
          child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          children: [
            Text(
              context.l10n.reportsSubtitle,
              style: t.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 16),
            Material(
              color: cs.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: cs.outlineVariant.withValues(alpha: 0.45),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.date_range_rounded, color: cs.primary),
                        const SizedBox(width: 8),
                        Text(
                          context.l10n.reportsTitle,
                          style: t.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _dateCard(
                      context: context,
                      label: context.l10n.reportsFrom,
                      date: _from,
                      onPick: () async {
                        final d = await showDatePicker(
                          context: context,
                          initialDate: _from,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (d != null) {
                          setState(() => _from = d);
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    _dateCard(
                      context: context,
                      label: context.l10n.reportsTo,
                      date: _to,
                      onPick: () async {
                        final d = await showDatePicker(
                          context: context,
                          initialDate: _to,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (d != null) {
                          setState(() => _to = d);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _busy ? null : _generate,
              icon: const Icon(Icons.insights_rounded),
              label: Text(
                _busy
                    ? context.l10n.commonWorking
                    : context.l10n.reportsGenerateSummary,
              ),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            if (_result != null) ...[
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, c) {
                  final w = c.maxWidth;
                  final cols = w > 520 ? 2 : 1;
                  final r = _result!;
                  final tiles = <Widget>[
                    _ReportMetric(
                      icon: Icons.local_shipping_outlined,
                      label: context.l10n.reportsShipmentsInRange,
                      value: '${r['totalShipments']}',
                      tone: cs.primary,
                    ),
                    _ReportMetric(
                      icon: Icons.payments_outlined,
                      label: context.l10n.reportsRevenueInRange,
                      value: MoneyFmt.of(r['totalRevenue'] as double),
                      tone: cs.secondary,
                    ),
                    _ReportMetric(
                      icon: Icons.savings_outlined,
                      label: context.l10n.reportsReceivedShipmentsInRange,
                      value: MoneyFmt.of(r['totalReceived'] as double),
                      tone: cs.tertiary,
                    ),
                    _ReportMetric(
                      icon: Icons.pending_actions_outlined,
                      label: context.l10n.reportsPendingBalanceShipmentsFiltered,
                      value: MoneyFmt.of(r['pendingShipments'] as double),
                      tone: cs.error,
                    ),
                    _ReportMetric(
                      icon: Icons.engineering_outlined,
                      label: context.l10n.reportsLabourCostInRange,
                      value: MoneyFmt.of(r['labourCost'] as double),
                      tone: cs.primary,
                    ),
                    _ReportMetric(
                      icon: Icons.timelapse_outlined,
                      label: context.l10n.reportsPendingLabourFiltered,
                      value: MoneyFmt.of(r['pendingLabour'] as double),
                      tone: cs.error,
                    ),
                    _ReportMetric(
                      icon: Icons.south_west_rounded,
                      label: context.l10n.reportsCashReceivedAllMarketsInRange,
                      value: MoneyFmt.of(r['cashReceivedInRange'] as double),
                      tone: cs.secondary,
                    ),
                    _ReportMetric(
                      icon: Icons.north_east_rounded,
                      label: context.l10n.reportsCashPaymentsAllMarketsInRange,
                      value: MoneyFmt.of(r['cashPaidInRange'] as double),
                      tone: cs.tertiary,
                    ),
                    _ReportMetric(
                      icon: Icons.account_balance_wallet_outlined,
                      label: context
                          .l10n.reportsTotalCashAvailableCurrentAllMarkets,
                      value: MoneyFmt.of(r['totalCashAvailable'] as double),
                      tone: cs.primary,
                    ),
                  ];
                  return GridView.count(
                    crossAxisCount: cols,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: cols == 2 ? 1.45 : 2.2,
                    children: tiles,
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _exportExcel,
                      icon: const Icon(Icons.table_chart_outlined),
                      label: Text(context.l10n.reportsExcel),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _exportPdf,
                      icon: const Icon(Icons.picture_as_pdf_outlined),
                      label: Text(context.l10n.reportsPdf),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
          ),
        ),
      ),
    );
  }
}

class _ReportMetric extends StatelessWidget {
  const _ReportMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.tone,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: cs.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: tone.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: tone),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: t.labelSmall?.copyWith(
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: t.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.35,
            ),
          ),
        ],
      ),
    );
  }
}
