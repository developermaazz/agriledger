import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/app_dependencies.dart';
import '../../../domain/record_status.dart';
import '../../../models/market.dart';
import '../../../models/shipment.dart';

class ShipmentFormScreen extends StatefulWidget {
  const ShipmentFormScreen({super.key, this.existing});

  final Shipment? existing;

  @override
  State<ShipmentFormScreen> createState() => _ShipmentFormScreenState();
}

class _ShipmentFormScreenState extends State<ShipmentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _buyer = TextEditingController();
  final _qty = TextEditingController();
  final _total = TextEditingController();
  final _received = TextEditingController();
  final _remarks = TextEditingController();

  DateTime _date = DateTime.now();
  String? _marketId;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    if (e != null) {
      _buyer.text = e.buyerName;
      _qty.text = e.quantity.toString();
      _total.text = e.totalAmount.toString();
      _received.text = e.amountReceived.toString();
      _remarks.text = e.remarks;
      _date = e.date;
      _marketId = e.marketId;
    }
  }

  @override
  void dispose() {
    _buyer.dispose();
    _qty.dispose();
    _total.dispose();
    _received.dispose();
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

  Future<void> _save(List<Market> markets, String marketId) async {
    final messenger = ScaffoldMessenger.of(context);
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final market = markets.firstWhere((m) => m.id == marketId);
    setState(() => _busy = true);
    final repo = AppDependencies.of(context).shipmentRepository;
    try {
      final qty = double.tryParse(_qty.text) ?? 0;
      final total = double.tryParse(_total.text) ?? 0;
      final recv = double.tryParse(_received.text) ?? 0;

      if (widget.existing == null) {
        await repo.createShipment(
          date: _date,
          marketId: market.id,
          marketName: market.name,
          buyerName: _buyer.text.trim(),
          quantity: qty,
          totalAmount: total,
          amountReceived: recv,
          remarks: _remarks.text.trim(),
        );
      } else {
        final e = widget.existing!;
        await repo.updateShipment(
          Shipment(
            id: e.id,
            serial: e.serial,
            date: _date,
            marketId: market.id,
            marketName: market.name,
            buyerName: _buyer.text.trim(),
            quantity: qty,
            totalAmount: total,
            amountReceived: recv,
            balance: 0,
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
    final marketRepo = AppDependencies.of(context).marketRepository;
    final locked = widget.existing?.status == RecordStatuses.completed;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existing == null
              ? 'New shipment'
              : (locked ? 'Shipment details' : 'Edit shipment'),
        ),
        actions: [
          if (widget.existing != null && !locked)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _busy
                  ? null
                  : () async {
                      final repo =
                          AppDependencies.of(context).shipmentRepository;
                      final nav = Navigator.of(context);
                      final id = widget.existing!.id;
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (c) => AlertDialog(
                          title: const Text('Delete shipment?'),
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
                        await repo.deleteShipment(id);
                        if (mounted) {
                          nav.pop();
                        }
                      }
                    },
            ),
        ],
      ),
      body: StreamBuilder<List<Market>>(
        stream: marketRepo.watchMarkets(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          final markets = snap.data!;
          if (markets.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Add a market first (Cash tab → add market).',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          final effectiveMarketId = _marketId ?? markets.first.id;

          final total = double.tryParse(_total.text) ?? 0;
          final recv = double.tryParse(_received.text) ?? 0;
          final bal = total - recv;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      // ignore: deprecated_member_use
                      value: effectiveMarketId,
                      decoration: const InputDecoration(labelText: 'Market'),
                      items: markets
                          .map(
                            (m) => DropdownMenuItem(
                              value: m.id,
                              child: Text(m.name),
                            ),
                          )
                          .toList(),
                      onChanged: locked ? null : (v) => setState(() => _marketId = v),
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Date'),
                      subtitle: Text(_date.toString().split(' ').first),
                      trailing: IconButton(
                        icon: const Icon(Icons.calendar_month),
                        onPressed: locked ? null : _pickDate,
                      ),
                    ),
                    TextFormField(
                      controller: _buyer,
                      decoration: const InputDecoration(labelText: 'Buyer'),
                      textCapitalization: TextCapitalization.words,
                      readOnly: locked,
                      validator: (v) =>
                          (v ?? '').trim().isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _qty,
                      decoration: const InputDecoration(
                        labelText: 'Quantity (boxes/cartons)',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                      readOnly: locked,
                      validator: (v) =>
                          double.tryParse(v ?? '') == null ? 'Invalid' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _total,
                      decoration: const InputDecoration(
                        labelText: 'Total amount',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                      readOnly: locked,
                      validator: (v) =>
                          double.tryParse(v ?? '') == null ? 'Invalid' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _received,
                      decoration: const InputDecoration(
                        labelText: 'Amount received',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                      readOnly: locked,
                      validator: (v) =>
                          double.tryParse(v ?? '') == null ? 'Invalid' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _remarks,
                      decoration: const InputDecoration(labelText: 'Remarks'),
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Balance (auto)',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            Text(
                              bal.toStringAsFixed(2),
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: (locked || _busy)
                    ? null
                    : () => _save(
                          markets,
                          effectiveMarketId,
                        ),
                child: Text(
                  locked ? 'Completed (read-only)' : (_busy ? 'Saving...' : 'Save'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
