import 'package:flutter/material.dart';
import '../../../app/app_dependencies.dart';
import '../../../models/cash_entry.dart';
import '../../../services/export_service.dart';
import '../../../shared/widgets/empty_state.dart';
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
            tooltip: 'Export Excel',
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
        label: const Text('Entry'),
      ),
      body: StreamBuilder<List<CashEntry>>(
        stream: cashRepo.watchCashEntries(marketId),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          final rows = snap.data!;
          if (rows.isEmpty) {
            return const EmptyState(
              title: 'No cash entries',
              subtitle: 'Add amount received and payments for this market.',
            );
          }
          return ListView.separated(
            itemCount: rows.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final e = rows[i];
              return ListTile(
                title: Text('#${e.serial} · ${_d(e.date)}'),
                subtitle: Text(
                  'Cash ${e.cashAvailable.toStringAsFixed(2)} · Pay ${e.payments.toStringAsFixed(2)} · Bal ${e.balance.toStringAsFixed(2)}',
                ),
                trailing: PopupMenuButton<String>(
                  tooltip: 'Actions',
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
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                  child: const Icon(Icons.more_vert),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => CashEntryDetailsScreen(
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
        title: const Text('Delete entry?'),
        content: const Text('Running totals will be recalculated.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      await repo.deleteCashEntry(marketId, e.id);
    }
  }
}
