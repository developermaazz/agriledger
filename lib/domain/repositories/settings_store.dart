import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/material.dart' show ThemeMode;

import '../../core/backend/backend_kind.dart';

/// Device-local app preferences (theme, locale, login policy, active backend).
///
/// This is device configuration — NOT user data — so the same implementation
/// is used regardless of the active data backend. [revision] bumps on every
/// write so listeners (e.g. the auth gate) can re-read.
abstract interface class SettingsStore {
  ValueListenable<int> get revision;

  Future<bool> get requireEmailLogin;
  Future<void> setRequireEmailLogin(bool value);

  Future<ThemeMode> get themeMode;
  Future<void> setThemeMode(ThemeMode mode);

  Future<String?> get localeCode;
  Future<void> setLocaleCode(String? code);

  /// The persisted active data backend (defaults to [defaultBackendKind]).
  Future<BackendKind> get backendKind;
  Future<void> setBackendKind(BackendKind kind);
}
