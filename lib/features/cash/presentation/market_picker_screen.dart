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
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text(context.l10n.marketCashTitle),
        scrolledUnderElevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        elevation: 2,
        onPressed: () => _addMarket(context),
        icon: const Icon(Icons.add_rounded),
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
                    icon: const Icon(Icons.add_rounded),
                    label: Text(context.l10n.commonAdd),
                  ),
                ),
              );
            }
            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              itemCount: markets.length,
              itemBuilder: (context, i) {
                final m = markets[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _MarketCard(
                    market: m,
                    onOpen: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => MarketCashLedgerScreen(
                            marketId: m.id,
                            marketName: m.name,
                          ),
                        ),
                      );
                    },
                    onDelete: () =>
                        _confirmDeleteMarket(context, m.id, m.name),
                  ),
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
          autofocus: true,
          decoration: InputDecoration(labelText: context.l10n.marketNewHint),
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: Text(context.l10n.commonCancel),
          ),
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

class _MarketCard extends StatelessWidget {
  const _MarketCard({
    required this.market,
    required this.onOpen,
    required this.onDelete,
  });

  final Market market;
  final VoidCallback onOpen;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final m = market;

    return Material(
      color: cs.surfaceContainerLow,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: cs.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpen,
        onLongPress: onDelete,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 12, 8, 12),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 52,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: cs.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: cs.primaryContainer.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.storefront_rounded,
                  color: cs.primary,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      m.name,
                      style: t.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.l10n.marketsTapToOpenCashLedger,
                      style: t.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: cs.onSurfaceVariant,
              ),
              PopupMenuButton<String>(
                tooltip: context.l10n.commonActions,
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: cs.onSurfaceVariant,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                onSelected: (v) {
                  if (v == 'open') {
                    onOpen();
                  } else if (v == 'delete') {
                    onDelete();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'open',
                    child: Row(
                      children: [
                        Icon(Icons.open_in_new_rounded, size: 20, color: cs.primary),
                        const SizedBox(width: 10),
                        Text(context.l10n.commonOpen),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline_rounded, size: 20, color: cs.error),
                        const SizedBox(width: 10),
                        Text(context.l10n.commonDelete),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
