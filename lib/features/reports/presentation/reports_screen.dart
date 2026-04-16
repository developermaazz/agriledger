import 'package:agri_ledger/domain/record_status.dart';
import 'package:flutter/material.dart';

import '../../../app/app_dependencies.dart';
import '../../../services/export_service.dart';
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
      appBar: AppBar(title: const Text('Reports')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Daily / monthly summaries',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('From'),
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
            title: const Text('To'),
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
            child: Text(_busy ? 'Working...' : 'Generate summary'),
          ),
          const SizedBox(height: 16),
          if (_result != null) ...[
            _line('Shipments in range', '${_result!['totalShipments']}'),
            _line('Revenue in range', (_result!['totalRevenue'] as double).toStringAsFixed(2)),
            _line('Received (shipments) in range',
                (_result!['totalReceived'] as double).toStringAsFixed(2)),
            _line('Pending balance (shipments, filtered)',
                (_result!['pendingShipments'] as double).toStringAsFixed(2)),
            _line('Labour cost in range',
                (_result!['labourCost'] as double).toStringAsFixed(2)),
            _line('Pending labour (filtered)',
                (_result!['pendingLabour'] as double).toStringAsFixed(2)),
            _line('Cash received (all markets, in range)',
                (_result!['cashReceivedInRange'] as double).toStringAsFixed(2)),
            _line('Cash payments (all markets, in range)',
                (_result!['cashPaidInRange'] as double).toStringAsFixed(2)),
            _line(
              'Total cash available (current, all markets)',
              (_result!['totalCashAvailable'] as double).toStringAsFixed(2),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _exportExcel,
                    icon: const Icon(Icons.table_chart_outlined),
                    label: const Text('Excel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _exportPdf,
                    icon: const Icon(Icons.picture_as_pdf_outlined),
                    label: const Text('PDF'),
                  ),
                ),
              ],
            ),
          ],
        ],
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
