import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/backend/backend_kind.dart';
import '../../domain/repositories/settings_store.dart';

/// `shared_preferences`-backed [SettingsStore]. Device-local (not synced) and
/// backend-independent. [requireEmailLogin] defaults to true.
class PrefsSettingsStore implements SettingsStore {
  static const _keyRequireEmailLogin = 'require_email_login';
  static const _keyThemeMode = 'theme_mode'; // system|light|dark
  static const _keyLocaleCode = 'locale_code'; // en|ur
  static const _keyBackendKind = 'backend_kind'; // local|firebase|custom

  @override
  final ValueNotifier<int> revision = ValueNotifier(0);

  @override
  Future<bool> get requireEmailLogin async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_keyRequireEmailLogin) ?? true;
  }

  @override
  Future<void> setRequireEmailLogin(bool value) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_keyRequireEmailLogin, value);
    revision.value++;
  }

  @override
  Future<ThemeMode> get themeMode async {
    final p = await SharedPreferences.getInstance();
    final v = p.getString(_keyThemeMode) ?? 'system';
    return switch (v) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  @override
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

  @override
  Future<String?> get localeCode async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_keyLocaleCode);
  }

  @override
  Future<void> setLocaleCode(String? code) async {
    final p = await SharedPreferences.getInstance();
    if (code == null || code.trim().isEmpty) {
      await p.remove(_keyLocaleCode);
    } else {
      await p.setString(_keyLocaleCode, code.trim());
    }
    revision.value++;
  }

  @override
  Future<BackendKind> get backendKind async {
    final p = await SharedPreferences.getInstance();
    return BackendKind.fromName(p.getString(_keyBackendKind));
  }

  @override
  Future<void> setBackendKind(BackendKind kind) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_keyBackendKind, kind.name);
    revision.value++;
  }
}
