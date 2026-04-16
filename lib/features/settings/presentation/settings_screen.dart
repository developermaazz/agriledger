import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../app/app_dependencies.dart';

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
      appBar: AppBar(title: const Text('Settings')),
      body: _loading || _requireEmail == null
          ? const Center(child: CircularProgressIndicator.adaptive())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SwitchListTile(
                  title: const Text('Require email sign-in'),
                  subtitle: const Text(
                    'When off, the app signs you in as a guest (Firebase anonymous) so data still backs up to the cloud.',
                  ),
                  value: _requireEmail!,
                  onChanged: (v) => _setRequire(v),
                ),
                const Divider(),
                const ListTile(
                  title: Text('Backup'),
                  subtitle: Text(
                    'Your records are stored in Cloud Firestore under your account. '
                    'Use Reports → Excel/PDF to keep file copies on your device.',
                  ),
                ),
                ListTile(
                  title: const Text('Sign out'),
                  trailing: const Icon(Icons.logout),
                  onTap: () async {
                    await AppDependencies.of(context).authService.signOut();
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
                ListTile(
                  title: const Text('Account type'),
                  subtitle: Text(
                    FirebaseAuth.instance.currentUser?.isAnonymous == true
                        ? 'Guest (anonymous)'
                        : 'Email user',
                  ),
                ),
              ],
            ),
    );
  }
}
