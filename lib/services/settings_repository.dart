import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local preferences (not synced). [requireEmailLogin] default true.
class SettingsRepository {
  static const _keyRequireEmailLogin = 'require_email_login';

  /// Bumped whenever a setting changes so [AuthGate] can re-read prefs.
  final ValueNotifier<int> revision = ValueNotifier(0);

  Future<bool> get requireEmailLogin async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_keyRequireEmailLogin) ?? true;
  }

  Future<void> setRequireEmailLogin(bool value) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_keyRequireEmailLogin, value);
    revision.value++;
  }
}
