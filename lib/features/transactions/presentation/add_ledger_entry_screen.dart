import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/app_dependencies.dart';
import '../../../models/ledger_entry.dart';

class AddLedgerEntryScreen extends StatefulWidget {
  const AddLedgerEntryScreen({super.key, required this.farmerId});

  final String farmerId;

  @override
  State<AddLedgerEntryScreen> createState() => _AddLedgerEntryScreenState();
}

class _AddLedgerEntryScreenState extends State<AddLedgerEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  LedgerEntryType _type = LedgerEntryType.credit;
  DateTime _entryDate = DateTime.now();
  bool _isSaving = false;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _entryDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _entryDate = picked);
    }
  }

  Future<void> _save() async {
    final messenger = ScaffoldMessenger.of(context);
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Enter a positive amount')),
      );
      return;
    }

    setState(() => _isSaving = true);
    final farmersRepo = AppDependencies.of(context).farmerRepository;
    final ledgerRepo = AppDependencies.of(context).ledgerRepository;

    try {
      final farmer = await farmersRepo.watchFarmer(widget.farmerId).first;
      final delta = _type == LedgerEntryType.credit ? amount : -amount;
      final newBalance = farmer.currentBalance + delta;

      final entry = LedgerEntry(
        id: '',
        type: _type,
        amount: amount,
        description: _descriptionController.text.trim(),
        entryDate: _entryDate,
        createdAt: null,
      );

      await ledgerRepo.addEntryAndUpdateBalance(
        farmerId: widget.farmerId,
        entry: entry,
        newFarmerBalance: newBalance,
      );

      if (!mounted) {
        return;
      }
      messenger.showSnackBar(const SnackBar(content: Text('Entry saved')));
      Navigator.of(context).pop();
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add ledger entry'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Credits increase the farmer balance. Debits decrease it.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Form(
            key: _formKey,
            child: Column(
              children: [
                SegmentedButton<LedgerEntryType>(
                  segments: const [
                    ButtonSegment(
                      value: LedgerEntryType.credit,
                      label: Text('Credit'),
                      icon: Icon(Icons.trending_up),
                    ),
                    ButtonSegment(
                      value: LedgerEntryType.debit,
                      label: Text('Debit'),
                      icon: Icon(Icons.trending_down),
                    ),
                  ],
                  selected: {_type},
                  onSelectionChanged: (selection) {
                    setState(() => _type = selection.first);
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  validator: (value) {
                    final v = double.tryParse(value ?? '');
                    if (v == null || v <= 0) {
                      return 'Enter a valid positive amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Entry date'),
                  subtitle: Text(_entryDate.toString().split(' ').first),
                  trailing: IconButton(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.calendar_month_outlined),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isSaving ? null : _save,
            child: Text(_isSaving ? 'Saving...' : 'Save entry'),
          ),
        ],
      ),
    );
  }
}
