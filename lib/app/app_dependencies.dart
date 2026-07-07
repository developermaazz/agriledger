import 'package:flutter/material.dart';

import '../core/backend/backend_controller.dart';
import '../domain/repositories/auth_provider.dart';
import '../domain/repositories/labour_store.dart';
import '../domain/repositories/market_cash_store.dart';
import '../domain/repositories/market_store.dart';
import '../domain/repositories/serial_meta_store.dart';
import '../domain/repositories/settings_store.dart';
import '../domain/repositories/shipment_store.dart';
import '../domain/repositories/storage_provider.dart';

/// Injects the active backend's data/auth/storage implementations (behind their
/// backend-agnostic interfaces) plus the device-local settings store into the
/// widget tree. Screens read these via [AppDependencies.of] and never depend on
/// a concrete backend.
class AppDependencies extends InheritedWidget {
  const AppDependencies({
    super.key,
    required this.authService,
    required this.settingsRepository,
    required this.serialMetaRepository,
    required this.marketRepository,
    required this.shipmentRepository,
    required this.marketCashRepository,
    required this.labourRepository,
    required this.storageRepository,
    required this.backendController,
    required super.child,
  });

  final AuthProvider authService;
  final SettingsStore settingsRepository;
  final SerialMetaStore serialMetaRepository;
  final MarketStore marketRepository;
  final ShipmentStore shipmentRepository;
  final MarketCashStore marketCashRepository;
  final LabourStore labourRepository;
  final StorageProvider storageRepository;

  /// Controls runtime switching of the active data backend.
  final BackendController backendController;

  static AppDependencies of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppDependencies>();
    if (scope == null) {
      throw StateError('AppDependencies not found in widget tree');
    }
    return scope;
  }

  @override
  bool updateShouldNotify(covariant AppDependencies oldWidget) {
    return authService != oldWidget.authService ||
        settingsRepository != oldWidget.settingsRepository ||
        serialMetaRepository != oldWidget.serialMetaRepository ||
        marketRepository != oldWidget.marketRepository ||
        shipmentRepository != oldWidget.shipmentRepository ||
        marketCashRepository != oldWidget.marketCashRepository ||
        labourRepository != oldWidget.labourRepository ||
        storageRepository != oldWidget.storageRepository ||
        backendController != oldWidget.backendController;
  }
}
