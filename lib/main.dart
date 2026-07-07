import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/app_bootstrap.dart';
import 'app/backend_registrations.dart';
import 'core/backend/backend_kind.dart';
import 'core/backend/backend_registry.dart';
import 'data/settings/prefs_settings_store.dart';
import 'firebase_options.dart';

/// One-time setup a backend needs before it can be built. Firebase is only
/// initialized when actually selected, so the local default runs with zero
/// Firebase configuration. Idempotent — safe to call again on a runtime switch.
Future<void> ensureBackendReady(BackendKind kind) async {
  if (kind == BackendKind.firebase && Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  registerBackends();

  final settings = PrefsSettingsStore();

  // Backend selection: a `--dart-define=BACKEND=...` wins, else the persisted
  // setting, else the compile-time [defaultBackendKind].
  const define = String.fromEnvironment('BACKEND');
  final kind = define.isNotEmpty
      ? BackendKind.fromName(define)
      : await settings.backendKind;

  await ensureBackendReady(kind);
  final backend = await BackendRegistry.create(kind);

  runApp(
    AppBootstrap(
      settings: settings,
      initialBackend: backend,
      ensureBackendReady: ensureBackendReady,
    ),
  );
}
