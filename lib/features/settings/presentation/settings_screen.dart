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
    final v =
        await AppDependencies.of(context).settingsRepository.requireEmailLogin;
    setState(() {
      _requireEmail = v;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settingsTitle)),
      body: _loading || _requireEmail == null
          ? const Center(child: CircularProgressIndicator.adaptive())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
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
