import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:agri_ledger/shared/formatters/money.dart';
import 'package:intl/intl.dart';

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
    final l10n = context.l10n;
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
        final msg = widget.existing == null
            ? l10n.feedbackShipmentAdded
            : l10n.feedbackShipmentUpdated;
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
    final marketRepo = AppDependencies.of(context).marketRepository;
    final locked = widget.existing?.status == RecordStatuses.completed;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          widget.existing == null
              ? context.l10n.shipmentsNewTitle
              : (locked
                  ? context.l10n.shipmentsDetailsTitle
                  : context.l10n.shipmentsEditTitle),
        ),
        actions: [
          if (widget.existing != null && !locked)
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded),
              onPressed: _busy
                  ? null
                  : () async {
                      final l10n = context.l10n;
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
                        try {
                          await repo.deleteShipment(id);
                          if (mounted) {
                            nav.pop();
                            AppSnackBar.showAfterRoutePopped(
                              message: l10n.shipmentsDeleted,
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
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: cs.primaryContainer.withValues(alpha: 0.45),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.storefront_outlined,
                        size: 48,
                        color: cs.primary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      context.l10n.shipmentsAddMarketFirst,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            height: 1.35,
                            color: cs.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            );
          }
          final effectiveMarketId = _marketId ?? markets.first.id;

          final total = double.tryParse(_total.text) ?? 0;
          final amountReceived = double.tryParse(_received.text) ?? 0;
          final outstandingBalance = total - amountReceived;
          final loc = Localizations.localeOf(context).toString();
          final dateLabel = DateFormat.yMMMMd(loc).format(_date);

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            children: [
              if (widget.existing != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Text(
                    context.l10n
                        .shipmentDetailAppBarTitle(widget.existing!.serial),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: cs.onSurfaceVariant,
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _FormSectionCard(
                      title: context.l10n.shipmentsMarketLabel,
                      icon: Icons.place_outlined,
                      child: DropdownButtonFormField<String>(
                        // ignore: deprecated_member_use
                        value: effectiveMarketId,
                        decoration: InputDecoration(
                          labelText: context.l10n.shipmentsMarketLabel,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        items: markets
                            .map(
                              (m) => DropdownMenuItem(
                                value: m.id,
                                child: Text(m.name),
                              ),
                            )
                            .toList(),
                        onChanged:
                            locked ? null : (v) => setState(() => _marketId = v),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _FormSectionCard(
                      title: context.l10n.shipmentsDateLabel,
                      icon: Icons.event_outlined,
                      child: Material(
                        color: cs.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(14),
                        child: InkWell(
                          onTap: locked ? null : _pickDate,
                          borderRadius: BorderRadius.circular(14),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_month_rounded,
                                  color: cs.primary,
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        context.l10n.shipmentsDateLabel,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium
                                            ?.copyWith(
                                              color: cs.onSurfaceVariant,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        dateLabel,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: cs.onSurfaceVariant,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _FormSectionCard(
                      title: context.l10n.shipmentsBuyerLabel,
                      icon: Icons.person_outline_rounded,
                      child: TextFormField(
                        controller: _buyer,
                        decoration: InputDecoration(
                          labelText: context.l10n.shipmentsBuyerLabel,
                        ),
                        textCapitalization: TextCapitalization.words,
                        readOnly: locked,
                        validator: (v) => (v ?? '').trim().isEmpty
                            ? context.l10n.commonRequired
                            : null,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _FormSectionCard(
                      title: context.l10n.shipmentsQuantityLabel,
                      icon: Icons.scale_outlined,
                      child: TextFormField(
                        controller: _qty,
                        decoration: InputDecoration(
                          labelText: context.l10n.shipmentsQuantityLabel,
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
                        readOnly: locked,
                        validator: (v) => double.tryParse(v ?? '') == null
                            ? context.l10n.commonInvalid
                            : null,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _FormSectionCard(
                      title: context.l10n.shipmentsTotalAmountLabel,
                      icon: Icons.payments_outlined,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _total,
                            decoration: InputDecoration(
                              labelText: context.l10n.shipmentsTotalAmountLabel,
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9.]'),
                              ),
                            ],
                            readOnly: locked,
                            onChanged: (_) => setState(() {}),
                            validator: (v) => double.tryParse(v ?? '') == null
                                ? context.l10n.commonInvalid
                                : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _received,
                            decoration: InputDecoration(
                              labelText:
                                  context.l10n.shipmentsAmountReceivedLabel,
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9.]'),
                              ),
                            ],
                            readOnly: locked,
                            onChanged: (_) => setState(() {}),
                            validator: (v) => double.tryParse(v ?? '') == null
                                ? context.l10n.commonInvalid
                                : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _FormSectionCard(
                      title: context.l10n.shipmentsRemarksLabel,
                      icon: Icons.notes_rounded,
                      child: TextFormField(
                        controller: _remarks,
                        decoration: InputDecoration(
                          labelText: context.l10n.shipmentsRemarksLabel,
                          alignLabelWithHint: true,
                        ),
                        maxLines: 4,
                        readOnly: locked,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              _BalanceHighlightCard(
                label: context.l10n.shipmentsBalanceAuto,
                amount: MoneyFmt.of(outstandingBalance),
                emphasize: outstandingBalance > 0,
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: (locked || _busy)
                    ? null
                    : () => _save(
                          markets,
                          effectiveMarketId,
                        ),
                icon: locked
                    ? const Icon(Icons.lock_outline_rounded, size: 20)
                    : const Icon(Icons.check_rounded, size: 22),
                label: Text(
                  locked
                      ? context.l10n.shipmentsCompletedReadOnly
                      : (_busy
                          ? context.l10n.commonSaving
                          : context.l10n.commonSave),
                ),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FormSectionCard extends StatelessWidget {
  const _FormSectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return Material(
      color: cs.surfaceContainerLow,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: cs.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: cs.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: t.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _BalanceHighlightCard extends StatelessWidget {
  const _BalanceHighlightCard({
    required this.label,
    required this.amount,
    required this.emphasize,
  });

  final String label;
  final String amount;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final bg = emphasize
        ? cs.errorContainer.withValues(alpha: 0.65)
        : cs.primaryContainer.withValues(alpha: 0.55);
    final fg = emphasize ? cs.onErrorContainer : cs.onPrimaryContainer;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            bg,
            cs.surfaceContainerLow,
          ],
        ),
        border: Border.all(
          color: cs.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cs.surface.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              emphasize
                  ? Icons.pending_actions_rounded
                  : Icons.account_balance_wallet_rounded,
              color: fg,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: t.labelLarge?.copyWith(
                    color: fg.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  amount,
                  style: t.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: fg,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
