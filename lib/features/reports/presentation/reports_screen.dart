import 'package:agri_ledger/domain/record_status.dart';
import 'package:flutter/material.dart';

import '../../../app/app_dependencies.dart';
import '../../../services/firestore_refresh.dart';
import '../../../services/export_service.dart';
import '../../../shared/formatters/money.dart';
import '../../../shared/l10n/l10n.dart';
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

    final sF = shipments
        .where((s) => isInRange(s.date, from, to))
        .toList();
    final lF = labour
        .where((j) => isInRange(j.dateStart, from, to))
        .toList();

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
    final totalRevenue =
        sF.fold<double>(0, (a, s) => a + s.totalAmount);
    final totalReceived =
        sF.fold<double>(0, (a, s) => a + s.amountReceived);
    final pendingShipments = sF
        .where((s) => s.status == RecordStatuses.pending)
        .fold<double>(0, (a, s) => a + s.balance);
    final pendingLabour = lF
        .where((j) => j.status == RecordStatuses.pending)
        .fold<double>(0, (a, j) => a + j.remainingBalance);
    final labourCost =
        lF.fold<double>(0, (a, j) => a + j.totalCost);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.reportsTitle)),
      body: RefreshIndicator(
        onRefresh: () async {
          await _refreshUnderlyingData();
          if (_result != null && mounted) {
            await _generate();
          }
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
          Text(
            context.l10n.reportsSubtitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(context.l10n.reportsFrom),
            subtitle: Text(_from.toString().split(' ').first),
            trailing: IconButton(
              icon: const Icon(Icons.calendar_month),
              onPressed: () async {
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
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(context.l10n.reportsTo),
            subtitle: Text(_to.toString().split(' ').first),
            trailing: IconButton(
              icon: const Icon(Icons.calendar_month),
              onPressed: () async {
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
          ),
          FilledButton(
            onPressed: _busy ? null : _generate,
            child: Text(_busy ? context.l10n.commonWorking : context.l10n.reportsGenerateSummary),
          ),
          const SizedBox(height: 16),
          if (_result != null) ...[
            _line(context.l10n.reportsShipmentsInRange, '${_result!['totalShipments']}'),
            _line(context.l10n.reportsRevenueInRange, MoneyFmt.of(_result!['totalRevenue'] as double)),
            _line(context.l10n.reportsReceivedShipmentsInRange,
                MoneyFmt.of(_result!['totalReceived'] as double)),
            _line(context.l10n.reportsPendingBalanceShipmentsFiltered,
                MoneyFmt.of(_result!['pendingShipments'] as double)),
            _line(context.l10n.reportsLabourCostInRange,
                MoneyFmt.of(_result!['labourCost'] as double)),
            _line(context.l10n.reportsPendingLabourFiltered,
                MoneyFmt.of(_result!['pendingLabour'] as double)),
            _line(context.l10n.reportsCashReceivedAllMarketsInRange,
                MoneyFmt.of(_result!['cashReceivedInRange'] as double)),
            _line(context.l10n.reportsCashPaymentsAllMarketsInRange,
                MoneyFmt.of(_result!['cashPaidInRange'] as double)),
            _line(
              context.l10n.reportsTotalCashAvailableCurrentAllMarkets,
              MoneyFmt.of(_result!['totalCashAvailable'] as double),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _exportExcel,
                    icon: const Icon(Icons.table_chart_outlined),
                    label: Text(context.l10n.reportsExcel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _exportPdf,
                    icon: const Icon(Icons.picture_as_pdf_outlined),
                    label: Text(context.l10n.reportsPdf),
                  ),
                ),
              ],
            ),
          ],
        ],
        ),
      ),
    );
  }

  Widget _line(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(k)),
          Text(v, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
