import 'package:agri_ledger/domain/record_status.dart';
import 'package:agri_ledger/shared/formatters/money.dart';
import 'package:flutter/material.dart';

import '../../../app/app_dependencies.dart';
import '../../../models/market.dart';
import '../../../models/shipment.dart';
import '../../../shared/l10n/l10n.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/firestore_error_view.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../../shared/snackbar/app_snackbar.dart';
import 'shipment_details_screen.dart';
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
  bool _deleting = false;

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
        title: Text(context.l10n.shipmentsTitle),
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
        label: Text(context.l10n.commonAdd),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              controller: _search,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: context.l10n.shipmentsSearchHint,
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
                    title: context.l10n.shipmentsUnableToLoadMarkets,
                  );
                }
                final markets = mSnap.data ?? [];
                return Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String?>(
                        // ignore: deprecated_member_use
                        value: _statusFilter,
                        decoration: InputDecoration(
                          labelText: context.l10n.commonStatus,
                          isDense: true,
                        ),
                        items: [
                          DropdownMenuItem(value: null, child: Text(context.l10n.commonAll)),
                          DropdownMenuItem(
                            value: RecordStatuses.pending,
                            child: Text(context.l10n.commonPending),
                          ),
                          DropdownMenuItem(
                            value: RecordStatuses.completed,
                            child: Text(context.l10n.commonCompleted),
                          ),
                          DropdownMenuItem(
                            value: RecordStatuses.overpaid,
                            child: Text(context.l10n.commonOverpaid),
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
                        decoration: InputDecoration(
                          labelText: context.l10n.shipmentsMarketLabel,
                          isDense: true,
                        ),
                        items: [
                          DropdownMenuItem(
                            value: null,
                            child: Text(context.l10n.shipmentsMarketFilterAll),
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
                    title: context.l10n.shipmentsUnableToLoad,
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
                  return EmptyState(
                    title: context.l10n.shipmentsNoShipmentsTitle,
                    subtitle: context.l10n.shipmentsNoShipmentsSubtitle,
                  );
                }

                return ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (context, _) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final s = list[i];
                    final locked = s.status == RecordStatuses.completed;
                    return ListTile(
                      title: Text(
                        context.l10n.shipmentsListTileTitle(s.serial, s.marketName),
                      ),
                      subtitle: Text(
                        context.l10n.shipmentsListSubtitle(
                          s.buyerName,
                          MoneyFmt.of(s.balance),
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          StatusBadge(status: s.status),
                          if (!locked)
                            PopupMenuButton<String>(
                              tooltip: context.l10n.commonActions,
                              onSelected: (v) async {
                                if (v == 'edit') {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) => ShipmentFormScreen(existing: s),
                                    ),
                                  );
                                  return;
                                }
                                if (v == 'delete') {
                                await _confirmDeleteShipment(s.id);
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(value: 'edit', child: Text(context.l10n.commonEdit)),
                                PopupMenuItem(value: 'delete', child: Text(context.l10n.commonDelete)),
                              ],
                            ),
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => locked
                                ? ShipmentDetailsScreen(shipment: s)
                                : ShipmentFormScreen(existing: s),
                          ),
                        );
                      },
                      onLongPress: locked ? null : () => _confirmDeleteShipment(s.id),
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

  Future<void> _confirmDeleteShipment(String id) async {
    if (_deleting) return;
    final repo = AppDependencies.of(context).shipmentRepository;
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(context.l10n.shipmentsDeleteConfirmTitle),
        content: Text(context.l10n.shipmentsDeleteConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: Text(context.l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(c, true),
            child: Text(context.l10n.commonDelete),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;

    setState(() => _deleting = true);
    try {
      await repo.deleteShipment(id);
      if (!mounted) return;
      AppSnackBar.show(
        context,
        message: context.l10n.shipmentsDeleted,
        type: AppSnackType.success,
      );
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.show(
        context,
        message: e is StateError ? e.message : e.toString(),
        type: AppSnackType.error,
      );
    } finally {
      if (mounted) {
        setState(() => _deleting = false);
      }
    }
  }
}
