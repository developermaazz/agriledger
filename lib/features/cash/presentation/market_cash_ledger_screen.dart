import 'package:agri_ledger/shared/formatters/money.dart';
import 'package:flutter/material.dart';
import '../../../app/app_dependencies.dart';
import '../../../models/cash_entry.dart';
import '../../../services/export_service.dart';
import '../../../shared/l10n/l10n.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/pull_to_refresh.dart';
import 'cash_entry_details_screen.dart';
import 'cash_entry_form_screen.dart';

class MarketCashLedgerScreen extends StatelessWidget {
  const MarketCashLedgerScreen({
    super.key,
    required this.marketId,
    required this.marketName,
  });

  final String marketId;
  final String marketName;

  @override
  Widget build(BuildContext context) {
    final cashRepo = AppDependencies.of(context).marketCashRepository;

    return Scaffold(
      appBar: AppBar(
        title: Text(marketName),
        actions: [
          IconButton(
            tooltip: context.l10n.cashExportExcel,
            onPressed: () async {
              final list = await cashRepo.watchCashEntries(marketId).first;
              final file = await ExportService.exportCashExcel(marketName, list);
              await ExportService.shareFile(file);
            },
            icon: const Icon(Icons.ios_share),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => CashEntryFormScreen(
                marketId: marketId,
                marketName: marketName,
              ),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: Text(context.l10n.cashEntryButton),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            cashRepo.refreshCashEntriesFromServer(marketId),
        child: StreamBuilder<List<CashEntry>>(
          stream: cashRepo.watchCashEntries(marketId),
          builder: (context, snap) {
            if (!snap.hasData) {
              return MinHeightRefreshContent(
                child: const Center(child: CircularProgressIndicator.adaptive()),
              );
            }
            final rows = snap.data!;
            if (rows.isEmpty) {
              return MinHeightRefreshContent(
                child: EmptyState(
                  title: context.l10n.cashNoEntriesTitle,
                  subtitle: context.l10n.cashNoEntriesSubtitle,
                ),
              );
            }
            return ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: rows.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final e = rows[i];
              return ListTile(
                title: Text(
                  context.l10n.cashLedgerListTitle(e.serial, _d(e.date)),
                ),
                subtitle: Text(
                  context.l10n.cashLedgerRowSummary(
                    MoneyFmt.of(e.cashAvailable),
                    MoneyFmt.of(e.payments),
                    MoneyFmt.of(e.balance),
                  ),
                ),
                trailing: PopupMenuButton<String>(
                  tooltip: context.l10n.commonActions,
                  onSelected: (v) async {
                    if (v == 'edit') {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => CashEntryFormScreen(
                            marketId: marketId,
                            marketName: marketName,
                            existing: e,
                          ),
                        ),
                      );
                      return;
                    }
                    if (v == 'delete') {
                      await _confirmDelete(context, e);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 'edit', child: Text(context.l10n.commonEdit)),
                    PopupMenuItem(value: 'delete', child: Text(context.l10n.commonDelete)),
                  ],
                  child: const Icon(Icons.more_vert),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => CashEntryDetailsScreen(
                        marketId: marketId,
                        marketName: marketName,
                        entry: e,
                      ),
                    ),
                  );
                },
              );
            },
          );
          },
        ),
      ),
    );
  }

  String _d(DateTime d) => d.toString().split(' ').first;

  Future<void> _confirmDelete(
    BuildContext context,
    CashEntry e,
  ) async {
    final repo = AppDependencies.of(context).marketCashRepository;
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(context.l10n.cashDeleteEntryTitle),
        content: Text(context.l10n.cashDeleteEntryBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: Text(context.l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(context.l10n.commonDelete)),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      await repo.deleteCashEntry(marketId, e.id);
    }
  }
}
