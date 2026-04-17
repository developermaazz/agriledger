import 'package:agri_ledger/domain/record_status.dart';
import 'package:flutter/material.dart';

import '../../../app/app_dependencies.dart';
import '../../../models/labour_job.dart';
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
      appBar: AppBar(title: const Text('Labour')),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const LabourFormScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              controller: _search,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search remarks',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: DropdownButtonFormField<String?>(
              // ignore: deprecated_member_use
              value: _status,
              decoration: const InputDecoration(
                labelText: 'Status',
                isDense: true,
              ),
              items: const [
                DropdownMenuItem(value: null, child: Text('All')),
                DropdownMenuItem(value: RecordStatuses.pending, child: Text('Pending')),
                DropdownMenuItem(value: RecordStatuses.completed, child: Text('Completed')),
                DropdownMenuItem(value: RecordStatuses.overpaid, child: Text('Overpaid')),
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
                    title: 'Unable to load labour records',
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
                  return const EmptyState(
                    title: 'No labour records',
                    subtitle: 'Track labour cost and payments.',
                  );
                }

                return ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (context, _) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final j = list[i];
                    final locked = j.status == RecordStatuses.completed;
                    return ListTile(
                      title: Text('#${j.serial} · ${j.remainingBalance.toStringAsFixed(2)} due'),
                      subtitle: Text(
                        '${j.dateStart.toString().split(' ').first} → ${j.dateEnd.toString().split(' ').first}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          StatusBadge(status: j.status),
                          if (!locked)
                            PopupMenuButton<String>(
                              tooltip: 'Actions',
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
                              itemBuilder: (context) => const [
                                PopupMenuItem(value: 'edit', child: Text('Edit')),
                                PopupMenuItem(value: 'delete', child: Text('Delete')),
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
        title: const Text('Delete labour record?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Delete')),
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
        message: 'Labour record deleted',
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
