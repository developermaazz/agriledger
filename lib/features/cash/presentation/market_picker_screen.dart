import 'package:flutter/material.dart';

import '../../../app/app_dependencies.dart';
import '../../../models/market.dart';
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
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => MarketCashLedgerScreen(marketId: m.id, marketName: m.name),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
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
    final messenger = ScaffoldMessenger.of(context);
    try {
      await AppDependencies.of(context).marketRepository.createMarket(name);
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.toString())));
      return;
    }
    if (context.mounted) {
      messenger.showSnackBar(
        SnackBar(content: Text('Market "$name" added')),
      );
    }
  }
}
