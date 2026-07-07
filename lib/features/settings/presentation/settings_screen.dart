import 'package:flutter/material.dart';

import '../../../app/app_dependencies.dart';
import '../../../core/backend/backend_controller.dart';
import '../../../core/backend/backend_kind.dart';
import '../../../data/migration/migration_service.dart';
import '../../../shared/l10n/l10n.dart';
import '../../../shared/responsive/breakpoints.dart';
import '../../../shared/responsive/max_width_body.dart';
import '../../../shared/snackbar/app_snackbar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool? _requireEmail;
  bool _loading = true;
  ThemeMode _themeMode = ThemeMode.system;
  String? _localeCode; // null = system

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _load();
    });
  }

  Future<void> _load() async {
    final repo = AppDependencies.of(context).settingsRepository;
    final v = await repo.requireEmailLogin;
    final tm = await repo.themeMode;
    final lc = await repo.localeCode;
    setState(() {
      _requireEmail = v;
      _themeMode = tm;
      _localeCode = lc;
      _loading = false;
    });
  }

  Future<void> _setRequire(bool v) async {
    if (!mounted) {
      return;
    }
    final deps = AppDependencies.of(context);
    final auth = deps.authService;
    final user = auth.currentUser;
    if (v && user != null && user.isAnonymous) {
      await auth.signOut();
    }
    await deps.settingsRepository.setRequireEmailLogin(v);
    if (!mounted) {
      return;
    }
    setState(() => _requireEmail = v);
  }

  Future<void> _setThemeMode(ThemeMode m) async {
    final repo = AppDependencies.of(context).settingsRepository;
    await repo.setThemeMode(m);
    if (!mounted) return;
    setState(() => _themeMode = m);
  }

  Future<void> _setLocale(String? code) async {
    final repo = AppDependencies.of(context).settingsRepository;
    await repo.setLocaleCode(code);
    if (!mounted) return;
    setState(() => _localeCode = code);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text(context.l10n.settingsTitle),
        scrolledUnderElevation: 0,
      ),
      body: MaxWidthBody(
        maxWidth: Breakpoints.contentMaxWidth,
        child: _loading || _requireEmail == null
          ? const Center(child: CircularProgressIndicator.adaptive())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
                children: [
                  Text(
                    context.l10n.settingsAppearance,
                    style: t.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Material(
                    color: cs.surfaceContainerLow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: BorderSide(
                        color: cs.outlineVariant.withValues(alpha: 0.45),
                      ),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: cs.primaryContainer.withValues(alpha: 0.65),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.color_lens_outlined,
                              color: cs.primary,
                            ),
                          ),
                          title: Text(
                            context.l10n.settingsTheme,
                            style: t.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          trailing: DropdownButtonHideUnderline(
                            child: DropdownButton<ThemeMode>(
                              value: _themeMode,
                              borderRadius: BorderRadius.circular(14),
                              items: [
                                DropdownMenuItem(
                                  value: ThemeMode.system,
                                  child: Text(context.l10n.settingsThemeSystem),
                                ),
                                DropdownMenuItem(
                                  value: ThemeMode.light,
                                  child: Text(context.l10n.settingsThemeLight),
                                ),
                                DropdownMenuItem(
                                  value: ThemeMode.dark,
                                  child: Text(context.l10n.settingsThemeDark),
                                ),
                              ],
                              onChanged: (v) {
                                if (v != null) _setThemeMode(v);
                              },
                            ),
                          ),
                        ),
                        Divider(
                          height: 1,
                          color: cs.outlineVariant.withValues(alpha: 0.35),
                        ),
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: cs.secondaryContainer.withValues(alpha: 0.65),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.translate_outlined,
                              color: cs.secondary,
                            ),
                          ),
                          title: Text(
                            context.l10n.settingsLanguage,
                            style: t.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          trailing: DropdownButtonHideUnderline(
                            child: DropdownButton<String?>(
                              value: _localeCode,
                              borderRadius: BorderRadius.circular(14),
                              items: [
                                DropdownMenuItem(
                                  value: null,
                                  child: Text(context.l10n.settingsThemeSystem),
                                ),
                                DropdownMenuItem(
                                  value: 'en',
                                  child: Text(
                                    context.l10n.settingsLanguageEnglish,
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'ur',
                                  child: Text(
                                    context.l10n.settingsLanguageUrdu,
                                  ),
                                ),
                              ],
                              onChanged: (v) => _setLocale(v),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Material(
                    color: cs.surfaceContainerLow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: BorderSide(
                        color: cs.outlineVariant.withValues(alpha: 0.45),
                      ),
                    ),
                    child: SwitchListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      secondary: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: cs.tertiaryContainer.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.mark_email_unread_outlined,
                          color: cs.tertiary,
                        ),
                      ),
                      title: Text(
                        context.l10n.settingsRequireEmailTitle,
                        style: t.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        context.l10n.settingsRequireEmailSubtitle,
                        style: t.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                          height: 1.35,
                        ),
                      ),
                      value: _requireEmail!,
                      onChanged: (v) => _setRequire(v),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Material(
                    color: cs.surfaceContainerLow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: BorderSide(
                        color: cs.outlineVariant.withValues(alpha: 0.45),
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.cloud_outlined,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                      title: Text(
                        context.l10n.settingsBackupTitle,
                        style: t.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        context.l10n.settingsBackupSubtitle,
                        style: t.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Material(
                    color: cs.surfaceContainerLow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: BorderSide(
                        color: cs.outlineVariant.withValues(alpha: 0.45),
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: cs.errorContainer.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.logout_rounded, color: cs.error),
                      ),
                      title: Text(
                        context.l10n.settingsSignOut,
                        style: t.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: cs.error,
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () async {
                        await AppDependencies.of(context).authService.signOut();
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Material(
                    color: cs.surfaceContainerLow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: BorderSide(
                        color: cs.outlineVariant.withValues(alpha: 0.45),
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: cs.primaryContainer.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.badge_outlined, color: cs.primary),
                      ),
                      title: Text(
                        context.l10n.settingsAccountType,
                        style: t.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        AppDependencies.of(context)
                                    .authService
                                    .currentUser
                                    ?.isAnonymous ==
                                true
                            ? context.l10n.settingsAccountTypeGuest
                            : context.l10n.settingsAccountTypeEmail,
                        style: t.bodyMedium?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const _DeveloperSection(),
                ],
              ),
            ),
      ),
    );
  }
}

/// Developer / admin section: shows and switches the active data backend and
/// exposes JSON export/import migration.
class _DeveloperSection extends StatelessWidget {
  const _DeveloperSection();

  String _label(BuildContext context, BackendKind kind) {
    final l10n = context.l10n;
    return switch (kind) {
      BackendKind.local => l10n.backendLocalLabel,
      BackendKind.firebase => l10n.backendFirebaseLabel,
      BackendKind.custom => l10n.backendCustomLabel,
    };
  }

  MigrationService _migration(BuildContext context) {
    final deps = AppDependencies.of(context);
    return MigrationService(
      markets: deps.marketRepository,
      shipments: deps.shipmentRepository,
      labour: deps.labourRepository,
      marketCash: deps.marketCashRepository,
    );
  }

  Future<void> _switch(
    BuildContext context,
    BackendController controller,
    BackendKind kind,
  ) async {
    final l10n = context.l10n;
    try {
      await controller.switchTo(kind);
    } catch (_) {
      if (!context.mounted) return;
      AppSnackBar.show(
        context,
        message: l10n.settingsBackendSwitchFailed,
        type: AppSnackType.error,
      );
    }
  }

  Future<void> _export(BuildContext context) async {
    final l10n = context.l10n;
    final migration = _migration(context);
    try {
      await migration.exportAndShare();
    } catch (_) {
      if (!context.mounted) return;
      AppSnackBar.show(
        context,
        message: l10n.settingsExportFailed,
        type: AppSnackType.error,
      );
    }
  }

  Future<void> _import(BuildContext context) async {
    final l10n = context.l10n;
    final controller = TextEditingController();
    final jsonStr = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l10n.settingsImportDialogTitle),
        content: TextField(
          controller: controller,
          maxLines: 6,
          minLines: 3,
          decoration: InputDecoration(hintText: l10n.settingsImportDialogHint),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(c, controller.text),
            child: Text(l10n.settingsImportLabel),
          ),
        ],
      ),
    );
    if (jsonStr == null || jsonStr.trim().isEmpty || !context.mounted) {
      return;
    }
    final migration = _migration(context);
    try {
      final summary = await migration.importFromJson(jsonStr);
      if (!context.mounted) return;
      AppSnackBar.show(
        context,
        message: l10n.settingsImportDone(
          summary.markets,
          summary.shipments,
          summary.labour,
          summary.cash,
        ),
        type: AppSnackType.success,
      );
    } catch (_) {
      if (!context.mounted) return;
      AppSnackBar.show(
        context,
        message: l10n.settingsImportFailed,
        type: AppSnackType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final controller = AppDependencies.of(context).backendController;

    BoxDecoration cardShape() => BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.45)),
        );

    Widget badge(IconData icon, Color tint) => Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: tint.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: cs.onSurfaceVariant),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.l10n.settingsBackendSection,
          style: t.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 10),
        ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            return DecoratedBox(
              decoration: cardShape(),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: badge(Icons.dns_outlined, cs.primaryContainer),
                title: Text(
                  context.l10n.settingsBackendTitle,
                  style: t.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  context.l10n.settingsBackendSubtitle,
                  style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
                trailing: controller.switching
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator.adaptive(strokeWidth: 2.4),
                      )
                    : DropdownButtonHideUnderline(
                        child: DropdownButton<BackendKind>(
                          value: controller.current,
                          borderRadius: BorderRadius.circular(14),
                          items: [
                            for (final k in controller.available)
                              DropdownMenuItem(
                                value: k,
                                child: Text(_label(context, k)),
                              ),
                          ],
                          onChanged: (k) {
                            if (k != null) _switch(context, controller, k);
                          },
                        ),
                      ),
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        DecoratedBox(
          decoration: cardShape(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    badge(Icons.swap_horiz_rounded, cs.secondaryContainer),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.settingsMigrateTitle,
                            style: t.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            context.l10n.settingsMigrateSubtitle,
                            style: t.bodySmall
                                ?.copyWith(color: cs.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _export(context),
                        icon: const Icon(Icons.ios_share_rounded, size: 18),
                        label: Text(context.l10n.settingsExportLabel),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => _import(context),
                        icon: const Icon(Icons.download_rounded, size: 18),
                        label: Text(context.l10n.settingsImportLabel),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
