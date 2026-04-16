import 'package:agri_ledger/domain/record_status.dart';
import 'package:flutter/material.dart';

import '../../../app/app_dependencies.dart';
import '../../../models/market.dart';
import '../../../models/shipment.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/firestore_error_view.dart';
import '../../../shared/widgets/status_badge.dart';
import 'shipment_form_screen.dart';

class ShipmentListScreen extends StatefulWidget {
  const ShipmentListScreen({super.key});

  @override
  State<ShipmentListScreen> createState() => _ShipmentListScreenState();
}

class _ShipmentListScreenState extends State<ShipmentListScreen> {
  final _search = TextEditingController();
  String _query = '';
  String? _statusFilter; // null = all
  String? _marketIdFilter;

  @override
  void initState() {
    super.initState();
    _search.addListener(() {
      setState(() => _query = _search.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shipRepo = AppDependencies.of(context).shipmentRepository;
    final marketRepo = AppDependencies.of(context).marketRepository;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shipments'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const ShipmentFormScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              controller: _search,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Buyer, market, remarks',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: StreamBuilder<List<Market>>(
              stream: marketRepo.watchMarkets(),
              builder: (context, mSnap) {
                if (mSnap.hasError) {
                  return FirestoreErrorView(
                    error: mSnap.error!,
                    title: 'Unable to load markets',
                  );
                }
                final markets = mSnap.data ?? [];
                return Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String?>(
                        // ignore: deprecated_member_use
                        value: _statusFilter,
                        decoration: const InputDecoration(
                          labelText: 'Status',
                          isDense: true,
                        ),
                        items: const [
                          DropdownMenuItem(value: null, child: Text('All')),
                          DropdownMenuItem(
                            value: RecordStatuses.pending,
                            child: Text('Pending'),
                          ),
                          DropdownMenuItem(
                            value: RecordStatuses.completed,
                            child: Text('Completed'),
                          ),
                          DropdownMenuItem(
                            value: RecordStatuses.overpaid,
                            child: Text('Overpaid'),
                          ),
                        ],
                        onChanged: (v) => setState(() => _statusFilter = v),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String?>(
                        // ignore: deprecated_member_use
                        value: _marketIdFilter,
                        decoration: const InputDecoration(
                          labelText: 'Market',
                          isDense: true,
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('All markets'),
                          ),
                          ...markets.map(
                            (m) => DropdownMenuItem(
                              value: m.id,
                              child: Text(m.name),
                            ),
                          ),
                        ],
                        onChanged: (v) => setState(() => _marketIdFilter = v),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Shipment>>(
              stream: shipRepo.watchShipments(),
              builder: (context, snap) {
                if (snap.hasError) {
                  return FirestoreErrorView(
                    error: snap.error!,
                    title: 'Unable to load shipments',
                  );
                }
                if (!snap.hasData) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                var list = snap.data!;
                list = list.where((s) {
                  if (_statusFilter != null && s.status != _statusFilter) {
                    return false;
                  }
                  if (_marketIdFilter != null && s.marketId != _marketIdFilter) {
                    return false;
                  }
                  if (_query.isEmpty) {
                    return true;
                  }
                  final hay = '${s.buyerName} ${s.marketName} ${s.remarks}'
                      .toLowerCase();
                  return hay.contains(_query);
                }).toList();

                if (list.isEmpty) {
                  return const EmptyState(
                    title: 'No shipments',
                    subtitle: 'Add a shipment to get started.',
                  );
                }

                return ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (context, _) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final s = list[i];
                    return ListTile(
                      title: Text('#${s.serial} ${s.marketName}'),
                      subtitle: Text(
                        '${s.buyerName} · Bal ${s.balance.toStringAsFixed(2)}',
                      ),
                      trailing: StatusBadge(status: s.status),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => ShipmentFormScreen(existing: s),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
