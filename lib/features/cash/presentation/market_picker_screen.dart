import 'package:flutter/material.dart';

import '../../../app/app_dependencies.dart';
import '../../../models/market.dart';
import '../../../shared/l10n/l10n.dart';
import '../../../shared/snackbar/app_snackbar.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/pull_to_refresh.dart';
import '../../../shared/widgets/firestore_error_view.dart';
import 'market_cash_ledger_screen.dart';

class MarketPickerScreen extends StatelessWidget {
  const MarketPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = AppDependencies.of(context).marketRepository;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.marketCashTitle),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () => _addMarket(context),
        icon: const Icon(Icons.add),
        label: Text(context.l10n.commonAdd),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            AppDependencies.of(context).marketRepository.refreshFromServer(),
        child: StreamBuilder<List<Market>>(
          stream: repo.watchMarkets(),
          builder: (context, snap) {
            if (snap.hasError) {
              return MinHeightRefreshContent(
                child: FirestoreErrorView(
                  error: snap.error!,
                  title: context.l10n.shipmentsUnableToLoadMarkets,
                ),
              );
            }
            if (!snap.hasData) {
              return MinHeightRefreshContent(
                child: const Center(child: CircularProgressIndicator.adaptive()),
              );
            }
            final markets = snap.data!;
            if (markets.isEmpty) {
              return MinHeightRefreshContent(
                child: EmptyState(
                  title: context.l10n.marketsEmptyTitle,
                  subtitle: context.l10n.marketsEmptySubtitle,
                  action: FilledButton.icon(
                    onPressed: () => _addMarket(context),
                    icon: const Icon(Icons.add),
                    label: Text(context.l10n.commonAdd),
                  ),
                ),
              );
            }
            return ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: markets.length,
            separatorBuilder: (context, _) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final m = markets[i];
              return ListTile(
                title: Text(m.name),
                subtitle: Text(context.l10n.marketsTapToOpenCashLedger),
                trailing: PopupMenuButton<String>(
                  tooltip: context.l10n.commonActions,
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
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 'open', child: Text(context.l10n.commonOpen)),
                    PopupMenuItem(value: 'delete', child: Text(context.l10n.commonDelete)),
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
        title: Text(context.l10n.marketsDeleteConfirmTitle),
        content: Text(
          context.l10n.marketsDeleteConfirmBody(marketName),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: Text(context.l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(context.l10n.commonDelete)),
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
      message: context.l10n.marketDeleted(marketName),
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
        title: Text(context.l10n.marketNewTitle),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: context.l10n.marketNewHint),
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: Text(context.l10n.commonCancel)),
          FilledButton(
            onPressed: () => Navigator.pop(c, controller.text.trim()),
            child: Text(context.l10n.commonAdd),
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
      message: context.l10n.marketAdded(name),
      type: AppSnackType.success,
    );
  }
}
