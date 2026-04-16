import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/labour_repository.dart';
import '../services/market_cash_repository.dart';
import '../services/market_repository.dart';
import '../services/serial_meta_repository.dart';
import '../services/settings_repository.dart';
import '../services/shipment_repository.dart';
import '../services/storage_repository.dart';

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
    required super.child,
  });

  final AuthService authService;
  final SettingsRepository settingsRepository;
  final SerialMetaRepository serialMetaRepository;
  final MarketRepository marketRepository;
  final ShipmentRepository shipmentRepository;
  final MarketCashRepository marketCashRepository;
  final LabourRepository labourRepository;
  final StorageRepository storageRepository;

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
        storageRepository != oldWidget.storageRepository;
  }
}
