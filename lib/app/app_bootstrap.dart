import 'package:flutter/material.dart';

import '../core/backend/backend.dart';
import '../core/backend/backend_controller.dart';
import '../core/backend/backend_kind.dart';
import '../core/backend/backend_registry.dart';
import '../domain/repositories/settings_store.dart';
import 'app.dart';
import 'app_dependencies.dart';

/// Owns the active [Backend] and the device-local [SettingsStore], exposes them
/// via [AppDependencies], and performs clean runtime backend switching.
class AppBootstrap extends StatefulWidget {
  const AppBootstrap({
    super.key,
    required this.settings,
    required this.initialBackend,
    required this.ensureBackendReady,
  });

  final SettingsStore settings;
  final Backend initialBackend;

  /// Performs any one-time setup a backend needs before it can be built
  /// (e.g. `Firebase.initializeApp` for the Firebase backend). Supplied by
  /// `main` so this widget stays free of Firebase specifics.
  final Future<void> Function(BackendKind kind) ensureBackendReady;

  @override
  State<AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends State<AppBootstrap> {
  late Backend _backend = widget.initialBackend;
  late final BackendController _controller = BackendController(
    current: _backend.kind,
    available: BackendRegistry.available.toList(),
    onSwitch: _performSwitch,
  );

  Future<void> _performSwitch(BackendKind kind) async {
    await widget.ensureBackendReady(kind);
    final next = await BackendRegistry.create(kind);
    await widget.settings.setBackendKind(kind);
    final old = _backend;
    if (mounted) {
      setState(() => _backend = next);
    }
    await old.dispose();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final b = _backend;
    return AppDependencies(
      authService: b.auth,
      settingsRepository: widget.settings,
      serialMetaRepository: b.serialMeta,
      marketRepository: b.markets,
      shipmentRepository: b.shipments,
      marketCashRepository: b.marketCash,
      labourRepository: b.labour,
      storageRepository: b.storage,
      backendController: _controller,
      child: const AppView(),
    );
  }
}
