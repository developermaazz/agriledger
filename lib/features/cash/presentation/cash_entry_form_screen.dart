import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/app_dependencies.dart';
import '../../../models/cash_entry.dart';
import '../../../shared/l10n/l10n.dart';
import '../../../shared/snackbar/app_snackbar.dart';

class CashEntryFormScreen extends StatefulWidget {
  const CashEntryFormScreen({
    super.key,
    required this.marketId,
    required this.marketName,
    this.existing,
  });

  final String marketId;
  final String marketName;
  final CashEntry? existing;

  @override
  State<CashEntryFormScreen> createState() => _CashEntryFormScreenState();
}

class _CashEntryFormScreenState extends State<CashEntryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountReceived = TextEditingController();
  final _payments = TextEditingController();
  final _remarks = TextEditingController();
  DateTime _date = DateTime.now();
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    if (e != null) {
      _amountReceived.text = e.amountReceived.toString();
      _payments.text = e.payments.toString();
      _remarks.text = e.remarks;
      _date = e.date;
    }
  }

  @override
  void dispose() {
    _amountReceived.dispose();
    _payments.dispose();
    _remarks.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (d != null) {
      setState(() => _date = d);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _busy = true);
    final l10n = context.l10n;
    final repo = AppDependencies.of(context).marketCashRepository;
    try {
      final amountReceived = double.tryParse(_amountReceived.text) ?? 0;
      final payments = double.tryParse(_payments.text) ?? 0;
      if (widget.existing == null) {
        await repo.createCashEntry(
          marketId: widget.marketId,
          date: _date,
          amountReceived: amountReceived,
          payments: payments,
          remarks: _remarks.text.trim(),
        );
      } else {
        await repo.updateCashEntryRaw(
          marketId: widget.marketId,
          entryId: widget.existing!.id,
          date: _date,
          amountReceived: amountReceived,
          payments: payments,
          remarks: _remarks.text.trim(),
        );
      }
      if (mounted) {
        final msg = widget.existing == null
            ? l10n.feedbackCashEntryAdded
            : l10n.feedbackCashEntryUpdated;
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existing != null
              ? context.l10n.cashEntryDetailsAppBarTitle(
                  widget.marketName,
                  widget.existing!.serial,
                )
              : widget.marketName,
        ),
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
                  title: Text(context.l10n.cashDateLabel),
                  subtitle: Text(_date.toString().split(' ').first),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_month),
                    onPressed: _pickDate,
                  ),
                ),
                TextFormField(
                  controller: _amountReceived,
                  decoration: InputDecoration(labelText: context.l10n.cashAmountReceivedLabel),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  validator: (v) =>
                      double.tryParse(v ?? '') == null ? context.l10n.commonInvalid : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _payments,
                  decoration: InputDecoration(labelText: context.l10n.cashPaymentsLabel),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  validator: (v) =>
                      double.tryParse(v ?? '') == null ? context.l10n.commonInvalid : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _remarks,
                  decoration: InputDecoration(labelText: context.l10n.cashRemarksLabel),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _busy ? null : _save,
            child: Text(_busy ? context.l10n.commonSaving : context.l10n.commonSave),
          ),
        ],
      ),
    );
  }
}
