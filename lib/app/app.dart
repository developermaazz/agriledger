import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../l10n/app_localizations.dart';

import 'app_dependencies.dart';
import 'app_navigator.dart';
import 'app_router.dart';
import 'app_theme.dart';
import '../features/auth/presentation/auth_gate.dart';
import '../services/account_deletion_service.dart';
import '../services/auth_deep_link_handler.dart';
import '../services/auth_service.dart';
import '../services/user_profile_repository.dart';
import '../services/labour_repository.dart';
import '../services/market_cash_repository.dart';
import '../services/market_repository.dart';
import '../services/serial_meta_repository.dart';
import '../services/settings_repository.dart';
import '../services/shipment_repository.dart';
import '../services/storage_repository.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.authDeepLinkHandler});

  final AuthDeepLinkHandler authDeepLinkHandler;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final SettingsRepository _settingsRepository = SettingsRepository();
  late final AuthService _authService = AuthService();
  late final UserProfileRepository _userProfileRepository = UserProfileRepository();
  late final SerialMetaRepository _serialMeta = SerialMetaRepository();
  late final MarketRepository _marketRepo = MarketRepository();
  late final ShipmentRepository _shipmentRepo =
      ShipmentRepository(serialMeta: _serialMeta);
  late final LabourRepository _labourRepo =
      LabourRepository(serialMeta: _serialMeta);
  late final MarketCashRepository _cashRepo =
      MarketCashRepository(marketRepository: _marketRepo);
  late final StorageRepository _storageRepository = StorageRepository();
  late final AccountDeletionService _accountDeletionService =
      AccountDeletionService();

  @override
  Widget build(BuildContext context) {
    return AppDependencies(
      authService: _authService,
      userProfileRepository: _userProfileRepository,
      authDeepLinkHandler: widget.authDeepLinkHandler,
      settingsRepository: _settingsRepository,
      serialMetaRepository: _serialMeta,
      marketRepository: _marketRepo,
      shipmentRepository: _shipmentRepo,
      marketCashRepository: _cashRepo,
      labourRepository: _labourRepo,
      storageRepository: _storageRepository,
      accountDeletionService: _accountDeletionService,
      child: ValueListenableBuilder<int>(
        valueListenable: _settingsRepository.revision,
        builder: (context, _, child) {
          return FutureBuilder<({ThemeMode mode, Locale? locale})>(
            future: () async {
              final mode = await _settingsRepository.themeMode;
              final code = await _settingsRepository.localeCode;
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
