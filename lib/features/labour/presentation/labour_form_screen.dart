import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/app_dependencies.dart';
import '../../../models/labour_job.dart';

class LabourFormScreen extends StatefulWidget {
  const LabourFormScreen({super.key, this.existing});

  final LabourJob? existing;

  @override
  State<LabourFormScreen> createState() => _LabourFormScreenState();
}

class _LabourFormScreenState extends State<LabourFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _total = TextEditingController();
  final _recv = TextEditingController();
  final _remarks = TextEditingController();
  DateTime _start = DateTime.now();
  DateTime _end = DateTime.now();
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    if (e != null) {
      _total.text = e.totalCost.toString();
      _recv.text = e.receivedPayment.toString();
      _remarks.text = e.remarks;
      _start = e.dateStart;
      _end = e.dateEnd;
    }
  }

  @override
  void dispose() {
    _total.dispose();
    _recv.dispose();
    _remarks.dispose();
    super.dispose();
  }

  Future<void> _pickStart() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _start,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (d != null) {
      setState(() => _start = d);
    }
  }

  Future<void> _pickEnd() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _end,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (d != null) {
      setState(() => _end = d);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _busy = true);
    final repo = AppDependencies.of(context).labourRepository;
    final messenger = ScaffoldMessenger.of(context);
    try {
      final total = double.tryParse(_total.text) ?? 0;
      final recv = double.tryParse(_recv.text) ?? 0;
      if (widget.existing == null) {
        await repo.createLabourJob(
          dateStart: _start,
          dateEnd: _end,
          totalCost: total,
          receivedPayment: recv,
          remarks: _remarks.text.trim(),
        );
      } else {
        final e = widget.existing!;
        await repo.updateLabourJob(
          LabourJob(
            id: e.id,
            serial: e.serial,
            dateStart: _start,
            dateEnd: _end,
            totalCost: total,
            receivedPayment: recv,
            remainingBalance: 0,
            status: e.status,
            remarks: _remarks.text.trim(),
            createdAt: e.createdAt,
            updatedAt: null,
          ),
        );
      }
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = double.tryParse(_total.text) ?? 0;
    final recv = double.tryParse(_recv.text) ?? 0;
    final rem = total - recv;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null ? 'New labour' : 'Edit labour'),
        actions: [
          if (widget.existing != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _busy
                  ? null
                  : () async {
                      final repo =
                          AppDependencies.of(context).labourRepository;
                      final nav = Navigator.of(context);
                      final id = widget.existing!.id;
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (c) => AlertDialog(
                          title: const Text('Delete record?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(c, false),
                              child: const Text('Cancel'),
                            ),
                            FilledButton(
                              onPressed: () => Navigator.pop(c, true),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );
                      if (ok == true && mounted) {
                        await repo.deleteLabourJob(id);
                        if (mounted) {
                          nav.pop();
                        }
                      }
                    },
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Start date'),
                  subtitle: Text(_start.toString().split(' ').first),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_month),
                    onPressed: _pickStart,
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('End date'),
                  subtitle: Text(_end.toString().split(' ').first),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_month),
                    onPressed: _pickEnd,
                  ),
                ),
                TextFormField(
                  controller: _total,
                  decoration: const InputDecoration(labelText: 'Total labour cost'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  validator: (v) =>
                      double.tryParse(v ?? '') == null ? 'Invalid' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _recv,
                  decoration: const InputDecoration(labelText: 'Received payment'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  validator: (v) =>
                      double.tryParse(v ?? '') == null ? 'Invalid' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _remarks,
                  decoration: const InputDecoration(labelText: 'Remarks'),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    'Remaining (auto)\n${rem.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _busy ? null : _save,
            child: Text(_busy ? 'Saving...' : 'Save'),
          ),
        ],
      ),
    );
  }
}
