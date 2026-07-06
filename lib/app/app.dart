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
    final settingsRepository = SettingsRepository();

    return AppDependencies(
      authService: AuthService(),
      settingsRepository: settingsRepository,
      serialMetaRepository: serialMeta,
      marketRepository: marketRepo,
      shipmentRepository: shipmentRepo,
      marketCashRepository: cashRepo,
      labourRepository: labourRepo,
      storageRepository: StorageRepository(),
      child: ValueListenableBuilder<int>(
        valueListenable: settingsRepository.revision,
        builder: (context, _, child) {
          return FutureBuilder<({ThemeMode mode, Locale? locale})>(
            future: () async {
              final mode = await settingsRepository.themeMode;
              final code = await settingsRepository.localeCode;
              final locale = (code == null || code.isEmpty) ? null : Locale(code);
              return (mode: mode, locale: locale);
            }(),
            builder: (context, snap) {
              final mode = snap.data?.mode ?? ThemeMode.system;
              final locale = snap.data?.locale;
              return MaterialApp(
                title: 'Agri Ledger',
                debugShowCheckedModeBanner: false,
                navigatorKey: appNavigatorKey,
                theme: AppTheme.light(),
                darkTheme: AppTheme.dark(),
                themeMode: mode,
                locale: locale,
                localizationsDelegates: [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                supportedLocales: AppLocalizations.supportedLocales,
                onGenerateRoute: AppRouter.onGenerateRoute,
                home: const AuthGate(),
              );
            },
          );
        },
      ),
    );
  }
}
