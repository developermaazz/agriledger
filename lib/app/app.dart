import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../l10n/app_localizations.dart';

import 'app_dependencies.dart';
import 'app_navigator.dart';
import 'app_router.dart';
import 'app_theme.dart';
import '../features/auth/presentation/auth_gate.dart';
import '../services/auth_service.dart';
import '../services/labour_repository.dart';
import '../services/market_cash_repository.dart';
import '../services/market_repository.dart';
import '../services/serial_meta_repository.dart';
import '../services/settings_repository.dart';
import '../services/shipment_repository.dart';
import '../services/storage_repository.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final serialMeta = SerialMetaRepository();
    final marketRepo = MarketRepository();
    final shipmentRepo = ShipmentRepository(serialMeta: serialMeta);
    final labourRepo = LabourRepository(serialMeta: serialMeta);
    final cashRepo = MarketCashRepository(marketRepository: marketRepo);

    return AppDependencies(
      authService: AuthService(),
      settingsRepository: SettingsRepository(),
      serialMetaRepository: serialMeta,
      marketRepository: marketRepo,
      shipmentRepository: shipmentRepo,
      marketCashRepository: cashRepo,
      labourRepository: labourRepo,
      storageRepository: StorageRepository(),
      child: MaterialApp(
        title: 'Fruit Ledger',
        debugShowCheckedModeBanner: false,
        navigatorKey: appNavigatorKey,
        theme: AppTheme.light(),
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        onGenerateRoute: AppRouter.onGenerateRoute,
        home: const AuthGate(),
      ),
    );
  }
}
