import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../app/app_dependencies.dart';
import '../../../shared/l10n/l10n.dart';

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
      body: _loading || _requireEmail == null
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
                        FirebaseAuth.instance.currentUser?.isAnonymous == true
                            ? context.l10n.settingsAccountTypeGuest
                            : context.l10n.settingsAccountTypeEmail,
                        style: t.bodyMedium?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
