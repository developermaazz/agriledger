import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/app_dependencies.dart';
import '../../../models/cash_entry.dart';

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
  final _recv = TextEditingController();
  final _pay = TextEditingController();
  final _remarks = TextEditingController();
  DateTime _date = DateTime.now();
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    if (e != null) {
      _recv.text = e.amountReceived.toString();
      _pay.text = e.payments.toString();
      _remarks.text = e.remarks;
      _date = e.date;
    }
  }

  @override
  void dispose() {
    _recv.dispose();
    _pay.dispose();
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
    final repo = AppDependencies.of(context).marketCashRepository;
    final messenger = ScaffoldMessenger.of(context);
    try {
      final recv = double.tryParse(_recv.text) ?? 0;
      final pay = double.tryParse(_pay.text) ?? 0;
      if (widget.existing == null) {
        await repo.createCashEntry(
          marketId: widget.marketId,
          date: _date,
          amountReceived: recv,
          payments: pay,
          remarks: _remarks.text.trim(),
        );
      } else {
        await repo.updateCashEntryRaw(
          marketId: widget.marketId,
          entryId: widget.existing!.id,
          date: _date,
          amountReceived: recv,
          payments: pay,
          remarks: _remarks.text.trim(),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.marketName),
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
                  title: const Text('Date'),
                  subtitle: Text(_date.toString().split(' ').first),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_month),
                    onPressed: _pickDate,
                  ),
                ),
                TextFormField(
                  controller: _recv,
                  decoration: const InputDecoration(
                    labelText: 'Amount received',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  validator: (v) =>
                      double.tryParse(v ?? '') == null ? 'Invalid' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _pay,
                  decoration: const InputDecoration(
                    labelText: 'Payments',
                  ),
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
          FilledButton(
            onPressed: _busy ? null : _save,
            child: Text(_busy ? 'Saving...' : 'Save'),
          ),
        ],
      ),
    );
  }
}
