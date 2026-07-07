import 'package:agri_ledger/shared/formatters/money.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../app/app_dependencies.dart';
import '../../../domain/record_status.dart';
import '../../../domain/entities/labour_job.dart';
import '../../../shared/l10n/l10n.dart';
import '../../../shared/responsive/breakpoints.dart';
import '../../../shared/responsive/max_width_body.dart';
import '../../../shared/widgets/detail_metric_tile.dart';
import '../../../shared/widgets/status_badge.dart';

class LabourDetailsScreen extends StatelessWidget {
  const LabourDetailsScreen({
    super.key,
    required this.job,
  });

  final LabourJob job;

  @override
  Widget build(BuildContext context) {
    final j = job;
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final loc = Localizations.localeOf(context).toString();
    final start = DateFormat.yMMMMd(loc).format(j.dateStart);
    final end = DateFormat.yMMMMd(loc).format(j.dateEnd);

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(context.l10n.labourDetailAppBarTitle(j.serial)),
      ),
      body: MaxWidthBody(
        maxWidth: Breakpoints.formMaxWidth,
        child: RefreshIndicator(
        onRefresh: () =>
            AppDependencies.of(context).labourRepository.refreshFromServer(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    cs.tertiaryContainer.withValues(alpha: 0.85),
                    cs.surfaceContainerLow,
                  ],
                ),
                border: Border.all(
                  color: cs.outlineVariant.withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cs.surface.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.engineering_rounded,
                      size: 28,
                      color: cs.tertiary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$start → $end',
                          style: t.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: StatusBadge(status: j.status),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            DetailMetricTile(
              icon: Icons.receipt_long_outlined,
              label: context.l10n.labourTotalCostLabel,
              value: MoneyFmt.of(j.totalCost),
              accent: cs.primary,
            ),
            DetailMetricTile(
              icon: Icons.payments_outlined,
              label: context.l10n.labourReceivedPaymentLabel,
              value: MoneyFmt.of(j.receivedPayment),
              accent: cs.secondary,
            ),
            DetailMetricTile(
              icon: Icons.pending_actions_outlined,
              label: context.l10n.labourRemainingAuto,
              value: MoneyFmt.of(j.remainingBalance),
              accent: j.remainingBalance > 0 ? cs.error : cs.tertiary,
            ),
            DetailMetricTile(
              icon: Icons.flag_outlined,
              label: context.l10n.commonStatus,
              value: _labelStatus(context, j.status),
            ),
            const SizedBox(height: 8),
            Material(
              color: cs.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: cs.outlineVariant.withValues(alpha: 0.45),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.notes_rounded, size: 20, color: cs.primary),
                        const SizedBox(width: 8),
                        Text(
                          context.l10n.labourRemarksLabel,
                          style: t.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      j.remarks.isEmpty ? '—' : j.remarks,
                      style: t.bodyMedium?.copyWith(
                        height: 1.45,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  String _labelStatus(BuildContext context, String s) {
    if (s == RecordStatuses.pending) return context.l10n.commonPending;
    if (s == RecordStatuses.completed) return context.l10n.commonCompleted;
    if (s == RecordStatuses.overpaid) return context.l10n.commonOverpaid;
    return s;
  }
}
