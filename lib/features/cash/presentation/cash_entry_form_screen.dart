import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../app/app_dependencies.dart';
import '../../../core/error/app_error_l10n.dart';
import '../../../domain/entities/cash_entry.dart';
import '../../../shared/l10n/l10n.dart';
import '../../../shared/responsive/breakpoints.dart';
import '../../../shared/responsive/max_width_body.dart';
import '../../../shared/snackbar/app_snackbar.dart';
import '../../../shared/widgets/section_card.dart';

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
        message: appErrorMessage(context, e),
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
    final cs = Theme.of(context).colorScheme;
    final loc = Localizations.localeOf(context).toString();
    final dateLabel = DateFormat.yMMMMd(loc).format(_date);

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          widget.existing != null
              ? context.l10n.cashEntryDetailsAppBarTitle(
                  widget.marketName,
                  widget.existing!.serial,
                )
              : widget.marketName,
        ),
      ),
      body: MaxWidthBody(
        maxWidth: Breakpoints.formMaxWidth,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          children: [
          if (widget.existing == null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Icon(Icons.storefront_rounded, color: cs.primary, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.marketName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SectionCard(
                  title: context.l10n.cashDateLabel,
                  icon: Icons.event_outlined,
                  child: Material(
                    color: cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      onTap: _pickDate,
                      borderRadius: BorderRadius.circular(14),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_month_rounded, color: cs.primary),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.l10n.cashDateLabel,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(color: cs.onSurfaceVariant),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    dateLabel,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
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
                SectionCard(
                  title: context.l10n.cashAmountReceivedLabel,
                  icon: Icons.south_west_rounded,
                  child: TextFormField(
                    controller: _amountReceived,
                    decoration: InputDecoration(
                      labelText: context.l10n.cashAmountReceivedLabel,
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    validator: (v) => double.tryParse(v ?? '') == null
                        ? context.l10n.commonInvalid
                        : null,
                  ),
                ),
                const SizedBox(height: 12),
                SectionCard(
                  title: context.l10n.cashPaymentsLabel,
                  icon: Icons.north_east_rounded,
                  child: TextFormField(
                    controller: _payments,
                    decoration: InputDecoration(
                      labelText: context.l10n.cashPaymentsLabel,
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    validator: (v) => double.tryParse(v ?? '') == null
                        ? context.l10n.commonInvalid
                        : null,
                  ),
                ),
                const SizedBox(height: 12),
                SectionCard(
                  title: context.l10n.cashRemarksLabel,
                  icon: Icons.notes_rounded,
                  child: TextFormField(
                    controller: _remarks,
                    decoration: InputDecoration(
                      labelText: context.l10n.cashRemarksLabel,
                      alignLabelWithHint: true,
                    ),
                    maxLines: 4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _busy ? null : _save,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              _busy ? context.l10n.commonSaving : context.l10n.commonSave,
            ),
          ),
        ],
        ),
      ),
    );
  }
}
