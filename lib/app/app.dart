import 'package:flutter/material.dart';

import 'app_dependencies.dart';
import 'app_navigator.dart';
import 'app_router.dart';
import 'app_theme.dart';
import '../features/auth/presentation/auth_gate.dart';
import '../services/auth_service.dart';
import '../services/farmer_repository.dart';
import '../services/ledger_repository.dart';
import '../services/storage_repository.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppDependencies(
      authService: AuthService(),
      farmerRepository: FarmerRepository(),
      ledgerRepository: LedgerRepository(),
      storageRepository: StorageRepository(),
      child: MaterialApp(
        title: 'AgriLedger',
        debugShowCheckedModeBanner: false,
        navigatorKey: appNavigatorKey,
        theme: AppTheme.light(),
        onGenerateRoute: AppRouter.onGenerateRoute,
        home: const AuthGate(),
      ),
    );
  }
}
