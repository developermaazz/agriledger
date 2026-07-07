import 'package:agri_ledger/shared/formatters/money.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../app/app_dependencies.dart';
import '../../../core/error/app_error_l10n.dart';
import '../../../domain/entities/cash_entry.dart';
import '../../../data/export/export_service.dart';
import '../../../shared/l10n/l10n.dart';
import '../../../shared/responsive/breakpoints.dart';
import '../../../shared/responsive/max_width_body.dart';
import '../../../shared/snackbar/app_snackbar.dart';
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
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(marketName),
        actions: [
          IconButton(
            tooltip: context.l10n.cashExportExcel,
            onPressed: () async {
              final list = await cashRepo.watchCashEntries(marketId).first;
              final file = await ExportService.exportCashExcel(marketName, list);
              await ExportService.shareFile(file);
            },
            icon: const Icon(Icons.ios_share_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        elevation: 2,
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
        icon: const Icon(Icons.add_rounded),
        label: Text(context.l10n.cashEntryButton),
      ),
      body: MaxWidthBody(
        maxWidth: Breakpoints.contentMaxWidth,
        child: RefreshIndicator(
        onRefresh: () => cashRepo.refreshCashEntriesFromServer(marketId),
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
            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              itemCount: rows.length,
              itemBuilder: (context, i) {
                final e = rows[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _CashEntryCard(
                    entry: e,
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
                    onEdit: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => CashEntryFormScreen(
                            marketId: marketId,
                            marketName: marketName,
                            existing: e,
                          ),
                        ),
                      );
                    },
                    onDelete: () => _confirmDelete(context, e),
                  ),
                );
              },
            );
          },
        ),
        ),
      ),
    );
  }

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
    try {
      await repo.deleteCashEntry(marketId, e.id);
      if (!context.mounted) return;
      AppSnackBar.show(
        context,
        message: context.l10n.cashEntryDeletedSnack,
        type: AppSnackType.success,
      );
    } catch (err) {
      if (!context.mounted) return;
      AppSnackBar.show(
        context,
        message: appErrorMessage(context, err),
        type: AppSnackType.error,
      );
    }
  }
}

class _CashEntryCard extends StatelessWidget {
  const _CashEntryCard({
    required this.entry,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final CashEntry entry;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final e = entry;
    final loc = Localizations.localeOf(context).toString();
    final dateStr = DateFormat.yMMMd(loc).format(e.date);

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
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 5,
                decoration: BoxDecoration(
                  color: cs.secondary,
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(17),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: cs.secondaryContainer.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.account_balance_wallet_rounded,
                          size: 22,
                          color: cs.secondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.l10n.cashLedgerListTitle(e.serial, dateStr),
                              style: t.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.2,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              context.l10n.cashLedgerRowSummary(
                                MoneyFmt.of(e.cashAvailable),
                                MoneyFmt.of(e.payments),
                                MoneyFmt.of(e.balance),
                              ),
                              style: t.bodySmall?.copyWith(
                                color: cs.onSurfaceVariant,
                                height: 1.35,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: cs.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: cs.outlineVariant.withValues(alpha: 0.5),
                              ),
                            ),
                            child: Text(
                              MoneyFmt.of(e.cashAvailable),
                              style: t.labelLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: PopupMenuButton<String>(
                  tooltip: context.l10n.commonActions,
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: cs.onSurfaceVariant,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  onSelected: (v) {
                    if (v == 'edit') {
                      onEdit();
                    } else if (v == 'delete') {
                      onDelete();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 20, color: cs.primary),
                          const SizedBox(width: 10),
                          Text(context.l10n.commonEdit),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, size: 20, color: cs.error),
                          const SizedBox(width: 10),
                          Text(context.l10n.commonDelete),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
