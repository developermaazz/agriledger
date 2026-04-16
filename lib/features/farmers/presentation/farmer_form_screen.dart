import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/app_dependencies.dart';
import '../../../models/farmer.dart';

class FarmerFormScreen extends StatefulWidget {
  const FarmerFormScreen({super.key, this.farmerId});

  final String? farmerId;

  @override
  State<FarmerFormScreen> createState() => _FarmerFormScreenState();
}

class _FarmerFormScreenState extends State<FarmerFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _notesController;
  late final TextEditingController _openingBalanceController;

  bool _isSaving = false;
  bool _seededFromFarmer = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _notesController = TextEditingController();
    _openingBalanceController = TextEditingController(text: '0');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    _openingBalanceController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final messenger = ScaffoldMessenger.of(context);
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    setState(() => _isSaving = true);
    final repo = AppDependencies.of(context).farmerRepository;

    try {
      final opening = double.tryParse(_openingBalanceController.text) ?? 0;

      if (widget.farmerId == null) {
        final farmer = Farmer(
          id: '',
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          address: _addressController.text.trim(),
          notes: _notesController.text.trim(),
          openingBalance: opening,
          currentBalance: opening,
          createdAt: null,
          updatedAt: null,
        );
        await repo.createFarmer(farmer);
      } else {
        final existing = await repo.watchFarmer(widget.farmerId!).first;
        final deltaOpening = opening - existing.openingBalance;
        final updated = Farmer(
          id: existing.id,
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          address: _addressController.text.trim(),
          notes: _notesController.text.trim(),
          openingBalance: opening,
          currentBalance: existing.currentBalance + deltaOpening,
          createdAt: existing.createdAt,
          updatedAt: null,
        );
        await repo.updateFarmer(updated);
      }

      if (!mounted) {
        return;
      }
      messenger.showSnackBar(const SnackBar(content: Text('Saved')));
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
    final isEdit = widget.farmerId != null;
    final farmersRepo = AppDependencies.of(context).farmerRepository;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit farmer' : 'New farmer'),
      ),
      body: isEdit
          ? StreamBuilder<Farmer>(
              stream: farmersRepo.watchFarmer(widget.farmerId!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }
                final farmer = snapshot.data;
                if (farmer == null) {
                  return const Center(child: Text('Farmer not found'));
                }

                if (!_seededFromFarmer) {
                  _nameController.text = farmer.name;
                  _phoneController.text = farmer.phone;
                  _addressController.text = farmer.address;
                  _notesController.text = farmer.notes;
                  _openingBalanceController.text =
                      farmer.openingBalance.toStringAsFixed(2);
                  _seededFromFarmer = true;
                }

                return _buildForm(context);
              },
            )
          : _buildForm(context),
    );
  }

  Widget _buildForm(BuildContext context) {
    final isEdit = widget.farmerId != null;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if ((value ?? '').trim().isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
                textCapitalization: TextCapitalization.sentences,
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _openingBalanceController,
                decoration: InputDecoration(
                  labelText: 'Opening balance',
                  helperText: isEdit
                      ? 'Adjusting opening balance shifts the current balance by the same delta.'
                      : 'Starting balance before ledger entries.',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[-0-9.]')),
                ],
                validator: (value) {
                  if (double.tryParse(value ?? '') == null) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _isSaving ? null : _save,
          child: Text(_isSaving ? 'Saving...' : 'Save'),
        ),
      ],
    );
  }
}
