import 'package:agri_ledger/domain/record_status.dart';
import 'package:flutter/material.dart';

import '../../../app/app_dependencies.dart';
import '../../../models/labour_job.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/firestore_error_view.dart';
import '../../../shared/widgets/status_badge.dart';
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
                    return ListTile(
                      title: Text('#${j.serial} · ${j.remainingBalance.toStringAsFixed(2)} due'),
                      subtitle: Text(
                        '${j.dateStart.toString().split(' ').first} → ${j.dateEnd.toString().split(' ').first}',
                      ),
                      trailing: StatusBadge(status: j.status),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => LabourFormScreen(existing: j),
                          ),
                        );
                      },
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
}
