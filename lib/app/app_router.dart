import 'package:flutter/material.dart';

import '../features/auth/presentation/login_screen.dart';

class AppRoutes {
  static const login = '/login';
}

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute<void>(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
      default:
        return null;
    }
  }
}
