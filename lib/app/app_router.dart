import 'package:flutter/material.dart';

import '../features/auth/presentation/login_screen.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/farmers/presentation/farmer_detail_screen.dart';
import '../features/farmers/presentation/farmer_form_screen.dart';
import '../features/farmers/presentation/farmer_list_screen.dart';
import '../features/transactions/presentation/add_ledger_entry_screen.dart';

class AppRoutes {
  static const login = '/login';
  static const dashboard = '/dashboard';
  static const farmers = '/farmers';
  static const farmerNew = '/farmers/new';
  static const farmerDetail = '/farmers/detail';
  static const entryNew = '/farmers/entry/new';
}

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute<void>(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
      case AppRoutes.dashboard:
        return MaterialPageRoute<void>(
          builder: (_) => const DashboardScreen(),
          settings: settings,
        );
      case AppRoutes.farmers:
        return MaterialPageRoute<void>(
          builder: (_) => const FarmerListScreen(),
          settings: settings,
        );
      case AppRoutes.farmerNew:
        return MaterialPageRoute<void>(
          builder: (_) => const FarmerFormScreen(),
          settings: settings,
        );
      case AppRoutes.farmerDetail:
        final farmerId = settings.arguments as String?;
        if (farmerId == null || farmerId.isEmpty) {
          return _missingArgs(settings);
        }
        return MaterialPageRoute<void>(
          builder: (_) => FarmerDetailScreen(farmerId: farmerId),
          settings: settings,
        );
      case AppRoutes.entryNew:
        final args = settings.arguments as Map<String, dynamic>?;
        final farmerId = args?['farmerId'] as String?;
        if (farmerId == null || farmerId.isEmpty) {
          return _missingArgs(settings);
        }
        return MaterialPageRoute<void>(
          builder: (_) => AddLedgerEntryScreen(farmerId: farmerId),
          settings: settings,
        );
      default:
        return null;
    }
  }

  static Route<dynamic> _missingArgs(RouteSettings settings) {
    return MaterialPageRoute<void>(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Missing route arguments')),
        body: Center(
          child: Text('Invalid navigation to ${settings.name}'),
        ),
      ),
      settings: settings,
    );
  }
}
