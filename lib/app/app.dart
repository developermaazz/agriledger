import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../features/auth/presentation/auth_gate.dart';
import '../l10n/app_localizations.dart';
import 'app_dependencies.dart';
import 'app_navigator.dart';
import 'app_router.dart';
import 'app_theme.dart';

/// The root [MaterialApp]. Reads theme/locale from the device-local settings
/// store provided by [AppDependencies]; the data backend is provided above it
/// by `AppBootstrap`.
class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = AppDependencies.of(context).settingsRepository;

    return ValueListenableBuilder<int>(
      valueListenable: settings.revision,
      builder: (context, _, child) {
        return FutureBuilder<({ThemeMode mode, Locale? locale})>(
          future: () async {
            final mode = await settings.themeMode;
            final code = await settings.localeCode;
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
              localizationsDelegates: const [
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
    );
  }
}
