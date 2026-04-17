import 'package:agri_ledger/shared/formatters/money.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/app_dependencies.dart';
import '../../../domain/record_status.dart';
import '../../../models/labour_job.dart';
import '../../../shared/l10n/l10n.dart';
import '../../../shared/snackbar/app_snackbar.dart';

class LabourFormScreen extends StatefulWidget {
  const LabourFormScreen({super.key, this.existing});

  final LabourJob? existing;

  @override
  State<LabourFormScreen> createState() => _LabourFormScreenState();
}

class _LabourFormScreenState extends State<LabourFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _total = TextEditingController();
  final _paymentReceived = TextEditingController();
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
      _paymentReceived.text = e.receivedPayment.toString();
      _remarks.text = e.remarks;
      _start = e.dateStart;
      _end = e.dateEnd;
    }
  }

  @override
  void dispose() {
    _total.dispose();
    _paymentReceived.dispose();
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
    final l10n = context.l10n;
    final repo = AppDependencies.of(context).labourRepository;
    try {
      final total = double.tryParse(_total.text) ?? 0;
      final receivedPayment = double.tryParse(_paymentReceived.text) ?? 0;
      if (widget.existing == null) {
        await repo.createLabourJob(
          dateStart: _start,
          dateEnd: _end,
          totalCost: total,
          receivedPayment: receivedPayment,
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
            receivedPayment: receivedPayment,
            remainingBalance: 0,
            status: e.status,
            remarks: _remarks.text.trim(),
            createdAt: e.createdAt,
            updatedAt: null,
          ),
        );
      }
      if (mounted) {
        final msg = widget.existing == null
            ? l10n.feedbackLabourAdded
            : l10n.feedbackLabourUpdated;
        Navigator.pop(context);
        AppSnackBar.showAfterRoutePopped(message: msg);
      }
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.show(
        context,
        message: e.toString(),
        type: AppSnackType.error,
      );
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = double.tryParse(_total.text) ?? 0;
    final receivedPayment = double.tryParse(_paymentReceived.text) ?? 0;
    final remainingBalance = total - receivedPayment;
    final locked = widget.existing?.status == RecordStatuses.completed;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existing == null
              ? context.l10n.labourNewTitle
              : (locked ? context.l10n.labourDetailsTitle : context.l10n.labourEditTitle),
        ),
        actions: [
          if (widget.existing != null && !locked)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _busy
                  ? null
                  : () async {
                      final l10n = context.l10n;
                      final repo =
                          AppDependencies.of(context).labourRepository;
                      final nav = Navigator.of(context);
                      final id = widget.existing!.id;
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (c) => AlertDialog(
                          title: Text(context.l10n.labourDeleteConfirmTitle),
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
                      if (ok == true && mounted) {
                        try {
                          await repo.deleteLabourJob(id);
                          if (mounted) {
                            nav.pop();
                            AppSnackBar.showAfterRoutePopped(
                              message: l10n.labourDeleted,
                            );
                          }
                        } catch (e) {
                          if (!context.mounted) return;
                          AppSnackBar.show(
                            context,
                            message:
                                e is StateError ? e.message : e.toString(),
                            type: AppSnackType.error,
                          );
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
                  title: Text(context.l10n.labourStartDateLabel),
                  subtitle: Text(_start.toString().split(' ').first),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_month),
                    onPressed: locked ? null : _pickStart,
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(context.l10n.labourEndDateLabel),
                  subtitle: Text(_end.toString().split(' ').first),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_month),
                    onPressed: locked ? null : _pickEnd,
                  ),
                ),
                TextFormField(
                  controller: _total,
                  decoration: InputDecoration(labelText: context.l10n.labourTotalCostLabel),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  readOnly: locked,
                  validator: (v) =>
                      double.tryParse(v ?? '') == null ? context.l10n.commonInvalid : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _paymentReceived,
                  decoration: InputDecoration(labelText: context.l10n.labourReceivedPaymentLabel),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  readOnly: locked,
                  validator: (v) =>
                      double.tryParse(v ?? '') == null ? context.l10n.commonInvalid : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _remarks,
                  decoration: InputDecoration(labelText: context.l10n.labourRemarksLabel),
                  maxLines: 3,
                  readOnly: locked,
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
                    '${context.l10n.labourRemainingAuto}\n${MoneyFmt.of(remainingBalance)}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: (locked || _busy) ? null : _save,
            child: Text(
              locked
                  ? context.l10n.labourCompletedReadOnly
                  : (_busy ? context.l10n.commonSaving : context.l10n.commonSave),
            ),
          ),
        ],
      ),
    );
  }
}
