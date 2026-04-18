import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local preferences (not synced). [requireEmailLogin] default true.
class SettingsRepository {
  static const _keyRequireEmailLogin = 'require_email_login';
  static const _keyThemeMode = 'theme_mode'; // system|light|dark
  static const _keyLocaleCode = 'locale_code'; // en|ur
  static const _keyAuthRememberMe = 'auth_remember_me';

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

  Future<ThemeMode> get themeMode async {
    final p = await SharedPreferences.getInstance();
    final v = p.getString(_keyThemeMode) ?? 'system';
    return switch (v) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final p = await SharedPreferences.getInstance();
    final v = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await p.setString(_keyThemeMode, v);
    revision.value++;
  }

  Future<String?> get localeCode async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_keyLocaleCode);
  }

  /// Web: persist login across browser restarts. Ignored on mobile (defaults true).
  Future<bool> get authRememberMe async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_keyAuthRememberMe) ?? true;
  }

  Future<void> setAuthRememberMe(bool value) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_keyAuthRememberMe, value);
    revision.value++;
  }

  Future<void> setLocaleCode(String? code) async {
    final p = await SharedPreferences.getInstance();
    if (code == null || code.trim().isEmpty) {
      await p.remove(_keyLocaleCode);
    } else {
      await p.setString(_keyLocaleCode, code.trim());
    }
    revision.value++;
  }
}
