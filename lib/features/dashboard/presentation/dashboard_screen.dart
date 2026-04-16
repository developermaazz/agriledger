import 'package:agri_ledger/domain/record_status.dart';
import 'package:flutter/material.dart';

import '../../../app/app_dependencies.dart';
import '../../../models/labour_job.dart';
import '../../../models/market.dart';
import '../../../models/shipment.dart';
import '../../../services/market_cash_repository.dart';
import '../../../shared/widgets/firestore_error_view.dart';
import '../../../shared/widgets/status_badge.dart';

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
        title: const Text('Dashboard'),
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
                      title: 'Unable to load dashboard data',
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
                        padding: const EdgeInsets.all(16),
                        children: [
                          Text(
                            'Overview',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 12),
                          _KpiGrid(
                            children: [
                              _KpiCard(
                                label: 'Total shipments',
                                value: '$totalShipments',
                              ),
                              _KpiCard(
                                label: 'Total revenue',
                                value: totalRevenue.toStringAsFixed(2),
                              ),
                              _KpiCard(
                                label: 'Amount received',
                                value: totalReceived.toStringAsFixed(2),
                              ),
                              _KpiCard(
                                label: 'Pending (shipments)',
                                value: pendingShipments.toStringAsFixed(2),
                              ),
                              _KpiCard(
                                label: 'Cash available',
                                value: totalCash.toStringAsFixed(2),
                              ),
                              _KpiCard(
                                label: 'Labour expenses',
                                value: labourCost.toStringAsFixed(2),
                              ),
                              _KpiCard(
                                label: 'Pending (labour)',
                                value: pendingLabour.toStringAsFixed(2),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Pending shipments',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          ..._pendingShipments(shipments),
                          const SizedBox(height: 16),
                          Text(
                            'Completed shipments',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          ..._completedShipments(shipments),
                          const SizedBox(height: 16),
                          Text(
                            'Recent activity',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          ..._recent(shipments, labour),
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

  static List<Widget> _pendingShipments(List<Shipment> all) {
    final list =
        all.where((s) => s.status == RecordStatuses.pending).take(8).toList();
    if (list.isEmpty) {
      return [const Text('None')];
    }
    return list
        .map(
          (s) => Card(
            child: ListTile(
              dense: true,
              title: Text('${s.marketName} · ${s.buyerName}'),
              subtitle: Text('Balance ${s.balance.toStringAsFixed(2)}'),
              trailing: const StatusBadge(status: RecordStatuses.pending),
            ),
          ),
        )
        .toList();
  }

  static List<Widget> _completedShipments(List<Shipment> all) {
    final list = all
        .where((s) => s.status == RecordStatuses.completed)
        .take(5)
        .toList();
    if (list.isEmpty) {
      return [const Text('None')];
    }
    return list
        .map(
          (s) => Card(
            child: ListTile(
              dense: true,
              title: Text('${s.marketName} · ${s.buyerName}'),
              subtitle: Text(s.date.toString().split(' ').first),
              trailing: const StatusBadge(status: RecordStatuses.completed),
            ),
          ),
        )
        .toList();
  }

  static List<Widget> _recent(List<Shipment> s, List<LabourJob> l) {
    final items = <_RecentItem>[];
    for (final x in s) {
      items.add(
        _RecentItem(
          time: x.updatedAt ?? x.date,
          text:
              'Shipment #${x.serial} ${x.marketName} · recv ${x.amountReceived.toStringAsFixed(2)}',
        ),
      );
    }
    for (final x in l) {
      items.add(
        _RecentItem(
          time: x.updatedAt ?? x.dateEnd,
          text:
              'Labour #${x.serial} paid ${x.receivedPayment.toStringAsFixed(2)}',
        ),
      );
    }
    items.sort((a, b) => b.time.compareTo(a.time));
    final top = items.take(10).toList();
    if (top.isEmpty) {
      return [const Text('No recent updates')];
    }
    return top
        .map(
          (e) => Card(
            child: ListTile(
              dense: true,
              title: Text(e.text),
              subtitle: Text(e.time.toString().split('.').first),
            ),
          ),
        )
        .toList();
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
        final cols = w > 600 ? 3 : 2;
        return GridView.count(
          crossAxisCount: cols,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.4,
          children: children,
        );
      },
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
