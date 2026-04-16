import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/farmer_repository.dart';
import '../services/ledger_repository.dart';
import '../services/storage_repository.dart';

class AppDependencies extends InheritedWidget {
  const AppDependencies({
    super.key,
    required this.authService,
    required this.farmerRepository,
    required this.ledgerRepository,
    required this.storageRepository,
    required super.child,
  });

  final AuthService authService;
  final FarmerRepository farmerRepository;
  final LedgerRepository ledgerRepository;
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
        farmerRepository != oldWidget.farmerRepository ||
        ledgerRepository != oldWidget.ledgerRepository ||
        storageRepository != oldWidget.storageRepository;
  }
}
