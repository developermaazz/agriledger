import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:agri_ledger/shared/formatters/money.dart';

import '../../../app/app_dependencies.dart';
import '../../../domain/record_status.dart';
import '../../../models/market.dart';
import '../../../models/shipment.dart';
import '../../../shared/l10n/l10n.dart';
import '../../../shared/snackbar/app_snackbar.dart';

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
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final market = markets.firstWhere((m) => m.id == marketId);
    setState(() => _busy = true);
    final repo = AppDependencies.of(context).shipmentRepository;
    try {
      final qty = double.tryParse(_qty.text) ?? 0;
      final total = double.tryParse(_total.text) ?? 0;
      final amountReceived = double.tryParse(_received.text) ?? 0;

      if (widget.existing == null) {
        await repo.createShipment(
          date: _date,
          marketId: market.id,
          marketName: market.name,
          buyerName: _buyer.text.trim(),
          quantity: qty,
          totalAmount: total,
          amountReceived: amountReceived,
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
            amountReceived: amountReceived,
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
    final marketRepo = AppDependencies.of(context).marketRepository;
    final locked = widget.existing?.status == RecordStatuses.completed;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existing == null
              ? context.l10n.shipmentsNewTitle
              : (locked ? context.l10n.shipmentsDetailsTitle : context.l10n.shipmentsEditTitle),
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
                          title: Text(context.l10n.shipmentsDeleteConfirmTitle),
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
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  context.l10n.shipmentsAddMarketFirst,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          final effectiveMarketId = _marketId ?? markets.first.id;

          final total = double.tryParse(_total.text) ?? 0;
          final amountReceived = double.tryParse(_received.text) ?? 0;
          final outstandingBalance = total - amountReceived;

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
                      decoration: InputDecoration(labelText: context.l10n.shipmentsMarketLabel),
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
                      title: Text(context.l10n.shipmentsDateLabel),
                      subtitle: Text(_date.toString().split(' ').first),
                      trailing: IconButton(
                        icon: const Icon(Icons.calendar_month),
                        onPressed: locked ? null : _pickDate,
                      ),
                    ),
                    TextFormField(
                      controller: _buyer,
                      decoration: InputDecoration(labelText: context.l10n.shipmentsBuyerLabel),
                      textCapitalization: TextCapitalization.words,
                      readOnly: locked,
                      validator: (v) =>
                          (v ?? '').trim().isEmpty ? context.l10n.commonRequired : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _qty,
                      decoration: InputDecoration(labelText: context.l10n.shipmentsQuantityLabel),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                      readOnly: locked,
                      validator: (v) =>
                          double.tryParse(v ?? '') == null ? context.l10n.commonInvalid : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _total,
                      decoration: InputDecoration(labelText: context.l10n.shipmentsTotalAmountLabel),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                      readOnly: locked,
                      validator: (v) =>
                          double.tryParse(v ?? '') == null ? context.l10n.commonInvalid : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _received,
                      decoration: InputDecoration(labelText: context.l10n.shipmentsAmountReceivedLabel),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
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
                      decoration: InputDecoration(labelText: context.l10n.shipmentsRemarksLabel),
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
                              context.l10n.shipmentsBalanceAuto,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            Text(
                              MoneyFmt.of(outstandingBalance),
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
                  locked
                      ? context.l10n.shipmentsCompletedReadOnly
                      : (_busy ? context.l10n.commonSaving : context.l10n.commonSave),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
