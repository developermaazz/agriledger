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
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settingsTitle)),
      body: _loading || _requireEmail == null
          ? const Center(child: CircularProgressIndicator.adaptive())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  context.l10n.settingsAppearance,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 10),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.color_lens_outlined),
                        title: Text(context.l10n.settingsTheme),
                        trailing: DropdownButtonHideUnderline(
                          child: DropdownButton<ThemeMode>(
                            value: _themeMode,
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
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.translate_outlined),
                        title: Text(context.l10n.settingsLanguage),
                        trailing: DropdownButtonHideUnderline(
                          child: DropdownButton<String?>(
                            value: _localeCode,
                            items: [
                              DropdownMenuItem(
                                value: null,
                                child: Text(context.l10n.settingsThemeSystem),
                              ),
                              DropdownMenuItem(
                                value: 'en',
                                child: Text(context.l10n.settingsLanguageEnglish),
                              ),
                              DropdownMenuItem(
                                value: 'ur',
                                child: Text(context.l10n.settingsLanguageUrdu),
                              ),
                            ],
                            onChanged: (v) => _setLocale(v),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                SwitchListTile(
                  title: Text(context.l10n.settingsRequireEmailTitle),
                  subtitle: Text(context.l10n.settingsRequireEmailSubtitle),
                  value: _requireEmail!,
                  onChanged: (v) => _setRequire(v),
                ),
                const Divider(),
                ListTile(
                  title: Text(context.l10n.settingsBackupTitle),
                  subtitle: Text(context.l10n.settingsBackupSubtitle),
                ),
                ListTile(
                  title: Text(context.l10n.settingsSignOut),
                  trailing: const Icon(Icons.logout),
                  onTap: () async {
                    await AppDependencies.of(context).authService.signOut();
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
                ListTile(
                  title: Text(context.l10n.settingsAccountType),
                  subtitle: Text(
                    FirebaseAuth.instance.currentUser?.isAnonymous == true
                        ? context.l10n.settingsAccountTypeGuest
                        : context.l10n.settingsAccountTypeEmail,
                  ),
                ),
              ],
            ),
    );
  }
}
