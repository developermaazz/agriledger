import 'package:agri_ledger/domain/record_status.dart';
import 'package:agri_ledger/shared/formatters/money.dart';
import 'package:flutter/material.dart';

import '../../../app/app_dependencies.dart';
import '../../../models/labour_job.dart';
import '../../../shared/l10n/l10n.dart';
import '../../../shared/widgets/empty_state.dart';
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
    _search.addListener(() => setState(() => _q = _search.text.trim().toLowerCase()));
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = AppDependencies.of(context).labourRepository;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.labourTitle)),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const LabourFormScreen()),
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
                hintText: context.l10n.labourSearchHint,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: DropdownButtonFormField<String?>(
              // ignore: deprecated_member_use
              value: _status,
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
              onChanged: (v) => setState(() => _status = v),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<LabourJob>>(
              stream: repo.watchLabourJobs(),
              builder: (context, snap) {
                if (snap.hasError) {
                  return FirestoreErrorView(
                    error: snap.error!,
                    title: context.l10n.labourUnableToLoad,
                  );
                }
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator.adaptive());
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
                  return EmptyState(
                    title: context.l10n.labourNoRecordsTitle,
                    subtitle: context.l10n.labourNoRecordsSubtitle,
                  );
                }

                return ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (context, _) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final j = list[i];
                    final locked = j.status == RecordStatuses.completed;
                    return ListTile(
                      title: Text(
                        context.l10n.labourListTitle(
                          '${j.serial}',
                          MoneyFmt.of(j.remainingBalance),
                        ),
                      ),
                      subtitle: Text(
                        context.l10n.labourListDateRange(
                          j.dateStart.toString().split(' ').first,
                          j.dateEnd.toString().split(' ').first,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          StatusBadge(status: j.status),
                          if (!locked)
                            PopupMenuButton<String>(
                              tooltip: context.l10n.commonActions,
                              onSelected: (v) async {
                                if (v == 'edit') {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) => LabourFormScreen(existing: j),
                                    ),
                                  );
                                  return;
                                }
                                if (v == 'delete') {
                                await _confirmDelete(j.id);
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
                                ? LabourDetailsScreen(job: j)
                                : LabourFormScreen(existing: j),
                          ),
                        );
                      },
                      onLongPress: locked ? null : () => _confirmDelete(j.id),
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

  Future<void> _confirmDelete(String id) async {
    if (_deleting) return;
    final repo = AppDependencies.of(context).labourRepository;
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(context.l10n.labourDeleteConfirmTitle),
        content: Text(context.l10n.labourDeleteConfirmBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: Text(context.l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(context.l10n.commonDelete)),
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
