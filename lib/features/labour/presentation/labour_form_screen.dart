import 'package:agri_ledger/shared/formatters/money.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../app/app_dependencies.dart';
import '../../../domain/record_status.dart';
import '../../../models/labour_job.dart';
import '../../../shared/l10n/l10n.dart';
import '../../../shared/snackbar/app_snackbar.dart';
import '../../../shared/widgets/section_card.dart';

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

  Widget _dateTile({
    required String title,
    required DateTime date,
    required VoidCallback? onTap,
    required ColorScheme cs,
  }) {
    final loc = Localizations.localeOf(context).toString();
    final label = DateFormat.yMMMMd(loc).format(date);
    return Material(
      color: cs.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Icon(Icons.calendar_month_rounded, color: cs.primary),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      label,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = double.tryParse(_total.text) ?? 0;
    final receivedPayment = double.tryParse(_paymentReceived.text) ?? 0;
    final remainingBalance = total - receivedPayment;
    final locked = widget.existing?.status == RecordStatuses.completed;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          widget.existing == null
              ? context.l10n.labourNewTitle
              : (locked
                  ? context.l10n.labourDetailsTitle
                  : context.l10n.labourEditTitle),
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
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        children: [
          if (widget.existing != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                context.l10n.labourDetailAppBarTitle(widget.existing!.serial),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SectionCard(
                  title: context.l10n.labourStartDateLabel,
                  icon: Icons.event_outlined,
                  child: _dateTile(
                    title: context.l10n.labourStartDateLabel,
                    date: _start,
                    onTap: locked ? null : _pickStart,
                    cs: cs,
                  ),
                ),
                const SizedBox(height: 12),
                SectionCard(
                  title: context.l10n.labourEndDateLabel,
                  icon: Icons.event_available_outlined,
                  child: _dateTile(
                    title: context.l10n.labourEndDateLabel,
                    date: _end,
                    onTap: locked ? null : _pickEnd,
                    cs: cs,
                  ),
                ),
                const SizedBox(height: 12),
                SectionCard(
                  title: context.l10n.labourTotalCostLabel,
                  icon: Icons.payments_outlined,
                  child: TextFormField(
                    controller: _total,
                    decoration: InputDecoration(
                      labelText: context.l10n.labourTotalCostLabel,
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    readOnly: locked,
                    onChanged: (_) => setState(() {}),
                    validator: (v) => double.tryParse(v ?? '') == null
                        ? context.l10n.commonInvalid
                        : null,
                  ),
                ),
                const SizedBox(height: 12),
                SectionCard(
                  title: context.l10n.labourReceivedPaymentLabel,
                  icon: Icons.account_balance_wallet_outlined,
                  child: TextFormField(
                    controller: _paymentReceived,
                    decoration: InputDecoration(
                      labelText: context.l10n.labourReceivedPaymentLabel,
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    readOnly: locked,
                    onChanged: (_) => setState(() {}),
                    validator: (v) => double.tryParse(v ?? '') == null
                        ? context.l10n.commonInvalid
                        : null,
                  ),
                ),
                const SizedBox(height: 12),
                SectionCard(
                  title: context.l10n.labourRemarksLabel,
                  icon: Icons.notes_rounded,
                  child: TextFormField(
                    controller: _remarks,
                    decoration: InputDecoration(
                      labelText: context.l10n.labourRemarksLabel,
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
          _LabourBalanceHighlight(
            label: context.l10n.labourRemainingAuto,
            amount: MoneyFmt.of(remainingBalance),
            emphasize: remainingBalance > 0,
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: (locked || _busy) ? null : _save,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              locked
                  ? context.l10n.labourCompletedReadOnly
                  : (_busy
                      ? context.l10n.commonSaving
                      : context.l10n.commonSave),
            ),
          ),
        ],
      ),
    );
  }
}

class _LabourBalanceHighlight extends StatelessWidget {
  const _LabourBalanceHighlight({
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
                  : Icons.check_circle_outline_rounded,
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
