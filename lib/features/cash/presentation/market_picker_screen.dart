import 'package:flutter/material.dart';

import '../../../app/app_dependencies.dart';
import '../../../models/market.dart';
import '../../../shared/snackbar/app_snackbar.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/firestore_error_view.dart';
import 'market_cash_ledger_screen.dart';

class MarketPickerScreen extends StatelessWidget {
  const MarketPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = AppDependencies.of(context).marketRepository;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Market cash'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () => _addMarket(context),
        icon: const Icon(Icons.add),
        label: const Text('Market'),
      ),
      body: StreamBuilder<List<Market>>(
        stream: repo.watchMarkets(),
        builder: (context, snap) {
          if (snap.hasError) {
            return FirestoreErrorView(
              error: snap.error!,
              title: 'Unable to load markets',
            );
          }
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          final markets = snap.data!;
          if (markets.isEmpty) {
            return EmptyState(
              title: 'No markets yet',
              subtitle: 'Add Lahore or other markets to track cash.',
              action: FilledButton.icon(
                onPressed: () => _addMarket(context),
                icon: const Icon(Icons.add),
                label: const Text('Add market'),
              ),
            );
          }
          return ListView.separated(
            itemCount: markets.length,
            separatorBuilder: (context, _) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final m = markets[i];
              return ListTile(
                title: Text(m.name),
                subtitle: const Text('Tap to open cash ledger'),
                trailing: PopupMenuButton<String>(
                  tooltip: 'Actions',
                  onSelected: (v) async {
                    if (v == 'open') {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => MarketCashLedgerScreen(
                            marketId: m.id,
                            marketName: m.name,
                          ),
                        ),
                      );
                      return;
                    }
                    if (v == 'delete') {
                      await _confirmDeleteMarket(context, m.id, m.name);
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'open', child: Text('Open')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                  child: const Icon(Icons.more_vert),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => MarketCashLedgerScreen(marketId: m.id, marketName: m.name),
                    ),
                  );
                },
                onLongPress: () => _confirmDeleteMarket(context, m.id, m.name),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _confirmDeleteMarket(
    BuildContext context,
    String marketId,
    String marketName,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Delete market?'),
        content: Text(
          'If this market is used in any shipment, it cannot be deleted.\n\n"$marketName" and its cash entries will be deleted.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;

    final deps = AppDependencies.of(context);
    try {
      await deps.marketRepository.deleteMarket(marketId);
      if (!context.mounted) return;
      AppSnackBar.show(
        context,
          message: 'Market "$marketName" deleted',
          type: AppSnackType.success,
      );
    } catch (e) {
      final msg = e is StateError ? e.message : e.toString();
      if (!context.mounted) return;
      AppSnackBar.show(
        context,
        message: msg,
        type: AppSnackType.error,
      );
    }
  }

  Future<void> _addMarket(BuildContext context) async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('New market'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Name (e.g. Lahore)'),
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(c, controller.text.trim()),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (name == null || name.isEmpty) {
      return;
    }
    if (!context.mounted) {
      return;
    }
    final deps = AppDependencies.of(context);
    try {
      await deps.marketRepository.createMarket(name);
    } catch (e) {
      if (!context.mounted) return;
      AppSnackBar.show(
        context,
        message: e.toString(),
        type: AppSnackType.error,
      );
      return;
    }
    if (!context.mounted) return;
    AppSnackBar.show(
      context,
      message: 'Market "$name" added',
      type: AppSnackType.success,
    );
  }
}
