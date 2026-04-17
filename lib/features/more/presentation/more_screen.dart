import 'package:flutter/material.dart';

import '../../../app/app_dependencies.dart';
import '../../../services/export_service.dart';
import '../../../shared/l10n/l10n.dart';
import '../../reports/presentation/reports_screen.dart';
import '../../settings/presentation/settings_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.moreTitle)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.assessment_outlined),
            title: Text(context.l10n.moreReportsTitle),
            subtitle: Text(context.l10n.moreReportsSubtitle),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const ReportsScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: Text(context.l10n.moreSettingsTitle),
            subtitle: Text(context.l10n.moreSettingsSubtitle),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.table_chart_outlined),
            title: Text(context.l10n.moreExportShipmentsExcel),
            onTap: () async {
              final list =
                  await AppDependencies.of(context).shipmentRepository.watchShipments().first;
              final file = await ExportService.exportShipmentsExcel(list);
              await ExportService.shareFile(file);
            },
          ),
          ListTile(
            leading: const Icon(Icons.table_chart_outlined),
            title: Text(context.l10n.moreExportLabourExcel),
            onTap: () async {
              final list =
                  await AppDependencies.of(context).labourRepository.watchLabourJobs().first;
              final file = await ExportService.exportLabourExcel(list);
              await ExportService.shareFile(file);
            },
          ),
        ],
      ),
    );
  }
}
