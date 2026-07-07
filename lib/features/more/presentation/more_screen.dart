import 'package:flutter/material.dart';

import '../../../app/app_dependencies.dart';
import '../../../data/refresh/refresh_all.dart';
import '../../../data/export/export_service.dart';
import '../../../shared/l10n/l10n.dart';
import '../../../shared/responsive/breakpoints.dart';
import '../../../shared/responsive/max_width_body.dart';
import '../../reports/presentation/reports_screen.dart';
import '../../settings/presentation/settings_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text(context.l10n.moreTitle),
        scrolledUnderElevation: 0,
      ),
      body: MaxWidthBody(
        maxWidth: Breakpoints.contentMaxWidth,
        child: RefreshIndicator(
          onRefresh: () async {
          final d = AppDependencies.of(context);
          await refreshAllUserDataFromServer(
            shipmentRepository: d.shipmentRepository,
            labourRepository: d.labourRepository,
            marketRepository: d.marketRepository,
            marketCashRepository: d.marketCashRepository,
          );
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          children: [
            _MoreCard(
              icon: Icons.insights_rounded,
              iconBg: cs.primaryContainer,
              iconFg: cs.onPrimaryContainer,
              title: context.l10n.moreReportsTitle,
              subtitle: context.l10n.moreReportsSubtitle,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const ReportsScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _MoreCard(
              icon: Icons.settings_outlined,
              iconBg: cs.secondaryContainer,
              iconFg: cs.onSecondaryContainer,
              title: context.l10n.moreSettingsTitle,
              subtitle: context.l10n.moreSettingsSubtitle,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const SettingsScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            _MoreCard(
              icon: Icons.table_chart_outlined,
              iconBg: cs.tertiaryContainer,
              iconFg: cs.onTertiaryContainer,
              title: context.l10n.moreExportShipmentsExcel,
              subtitle: null,
              onTap: () async {
                final list = await AppDependencies.of(context)
                    .shipmentRepository
                    .watchShipments()
                    .first;
                final file = await ExportService.exportShipmentsExcel(list);
                await ExportService.shareFile(file);
              },
            ),
            const SizedBox(height: 10),
            _MoreCard(
              icon: Icons.grid_on_outlined,
              iconBg: cs.surfaceContainerHighest,
              iconFg: cs.onSurface,
              title: context.l10n.moreExportLabourExcel,
              subtitle: null,
              onTap: () async {
                final list = await AppDependencies.of(context)
                    .labourRepository
                    .watchLabourJobs()
                    .first;
                final file = await ExportService.exportLabourExcel(list);
                await ExportService.shareFile(file);
              },
            ),
          ],
        ),
        ),
      ),
    );
  }
}

class _MoreCard extends StatelessWidget {
  const _MoreCard({
    required this.icon,
    required this.iconBg,
    required this.iconFg,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconFg;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

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
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconFg, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: t.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: t.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                          height: 1.25,
                        ),
                      ),
                    ],
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
    );
  }
}
