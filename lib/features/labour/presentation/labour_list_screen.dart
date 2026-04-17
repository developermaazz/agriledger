import 'package:agri_ledger/domain/record_status.dart';
import 'package:agri_ledger/shared/formatters/money.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../app/app_dependencies.dart';
import '../../../models/labour_job.dart';
import '../../../shared/l10n/l10n.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/pull_to_refresh.dart';
import '../../../shared/widgets/firestore_error_view.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../../shared/snackbar/app_snackbar.dart';
import 'labour_details_screen.dart';
import 'labour_form_screen.dart';

class LabourListScreen extends StatefulWidget {
  const LabourListScreen({super.key});

  @override
  State<LabourListScreen> createState() => _LabourListScreenState();
}

class _LabourListScreenState extends State<LabourListScreen> {
  final _search = TextEditingController();
  String _q = '';
  String? _status;
  bool _deleting = false;

  @override
  void initState() {
    super.initState();
    _search.addListener(() {
      setState(() => _q = _search.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _refreshLabourList() async {
    await AppDependencies.of(context).labourRepository.refreshFromServer();
  }

  @override
  Widget build(BuildContext context) {
    final repo = AppDependencies.of(context).labourRepository;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text(context.l10n.labourTitle),
        scrolledUnderElevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        elevation: 2,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const LabourFormScreen()),
          );
        },
        icon: const Icon(Icons.add_rounded),
        label: Text(context.l10n.commonAdd),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow,
              border: Border(
                bottom: BorderSide(
                  color: cs.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _search,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: context.l10n.labourSearchHint,
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: cs.onSurfaceVariant,
                      ),
                      suffixIcon: _search.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                _search.clear();
                                setState(() {});
                              },
                              icon: Icon(
                                Icons.close_rounded,
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                      filled: true,
                      fillColor: cs.surface,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    context.l10n.commonStatus,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: cs.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _LabourStatusChip(
                          label: context.l10n.commonAll,
                          selected: _status == null,
                          onTap: () => setState(() => _status = null),
                        ),
                        _LabourStatusChip(
                          label: context.l10n.commonPending,
                          selected: _status == RecordStatuses.pending,
                          onTap: () => setState(
                            () => _status = RecordStatuses.pending,
                          ),
                        ),
                        _LabourStatusChip(
                          label: context.l10n.commonCompleted,
                          selected: _status == RecordStatuses.completed,
                          onTap: () => setState(
                            () => _status = RecordStatuses.completed,
                          ),
                        ),
                        _LabourStatusChip(
                          label: context.l10n.commonOverpaid,
                          selected: _status == RecordStatuses.overpaid,
                          onTap: () => setState(
                            () => _status = RecordStatuses.overpaid,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshLabourList,
              child: StreamBuilder<List<LabourJob>>(
                stream: repo.watchLabourJobs(),
                builder: (context, snap) {
                  if (snap.hasError) {
                    return MinHeightRefreshContent(
                      child: FirestoreErrorView(
                        error: snap.error!,
                        title: context.l10n.labourUnableToLoad,
                      ),
                    );
                  }
                  if (!snap.hasData) {
                    return MinHeightRefreshContent(
                      child: const Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    );
                  }
                  var list = snap.data!;
                  list = list.where((j) {
                    if (_status != null && j.status != _status) {
                      return false;
                    }
                    if (_q.isEmpty) {
                      return true;
                    }
                    return j.remarks.toLowerCase().contains(_q);
                  }).toList();

                  if (list.isEmpty) {
                    return MinHeightRefreshContent(
                      child: EmptyState(
                        title: context.l10n.labourNoRecordsTitle,
                        subtitle: context.l10n.labourNoRecordsSubtitle,
                      ),
                    );
                  }

                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                    itemCount: list.length,
                    itemBuilder: (context, i) {
                      final j = list[i];
                      final locked = j.status == RecordStatuses.completed;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _LabourJobCard(
                          job: j,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => locked
                                    ? LabourDetailsScreen(job: j)
                                    : LabourFormScreen(existing: j),
                              ),
                            );
                          },
                          onLongPress:
                              locked ? null : () => _confirmDelete(j.id),
                          onEdit: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => LabourFormScreen(existing: j),
                              ),
                            );
                          },
                          onDelete: () => _confirmDelete(j.id),
                          showMenu: !locked,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(String id) async {
    if (_deleting) return;
    final repo = AppDependencies.of(context).labourRepository;
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(context.l10n.labourDeleteConfirmTitle),
        content: Text(context.l10n.labourDeleteConfirmBody),
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
      await repo.deleteLabourJob(id);
      if (!mounted) return;
      AppSnackBar.show(
        context,
        message: context.l10n.labourDeleted,
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

class _LabourStatusChip extends StatelessWidget {
  const _LabourStatusChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        selectedColor: cs.primaryContainer,
        labelStyle: TextStyle(
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          color: selected ? cs.onPrimaryContainer : cs.onSurfaceVariant,
        ),
        side: BorderSide(
          color: selected
              ? cs.primary.withValues(alpha: 0.35)
              : cs.outlineVariant.withValues(alpha: 0.9),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class _LabourJobCard extends StatelessWidget {
  const _LabourJobCard({
    required this.job,
    required this.onTap,
    required this.onLongPress,
    required this.onEdit,
    required this.onDelete,
    required this.showMenu,
  });

  final LabourJob job;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool showMenu;

  Color _accent(ColorScheme cs) {
    switch (job.status) {
      case RecordStatuses.completed:
        return cs.tertiary;
      case RecordStatuses.overpaid:
        return cs.secondary;
      default:
        return cs.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final j = job;
    final accent = _accent(cs);
    final loc = Localizations.localeOf(context).toString();
    final start = DateFormat.MMMd(loc).format(j.dateStart);
    final end = DateFormat.MMMd(loc).format(j.dateEnd);

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
        onLongPress: onLongPress,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 5,
                decoration: BoxDecoration(
                  color: accent,
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
                          color: accent.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.engineering_rounded,
                          size: 22,
                          color: accent,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.l10n.labourListTitle(
                                '${j.serial}',
                                MoneyFmt.of(j.remainingBalance),
                              ),
                              style: t.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.2,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(
                                  Icons.date_range_rounded,
                                  size: 14,
                                  color: cs.onSurfaceVariant
                                      .withValues(alpha: 0.85),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    context.l10n.labourListDateRange(
                                      start,
                                      end,
                                    ),
                                    style: t.bodySmall?.copyWith(
                                      color: cs.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          StatusBadge(status: j.status),
                          const SizedBox(height: 8),
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
                              MoneyFmt.of(j.remainingBalance),
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
              if (showMenu)
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
