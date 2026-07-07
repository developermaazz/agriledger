import 'package:flutter/material.dart';

import '../../shared/l10n/l10n.dart';
import '../../shared/responsive/adaptive_nav_scaffold.dart';
import '../cash/presentation/market_picker_screen.dart';
import '../dashboard/presentation/dashboard_screen.dart';
import '../labour/presentation/labour_list_screen.dart';
import '../more/presentation/more_screen.dart';
import '../shipments/presentation/shipment_list_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  static const int _tabCount = 5;

  /// Pixels/sec; avoids accidental tab changes while scrolling lists vertically.
  static const double _swipeVelocityThreshold = 380;

  int _index = 0;

  void _onHorizontalSwipeEnd(DragEndDetails details) {
    final v = details.primaryVelocity;
    if (v == null || v.abs() < _swipeVelocityThreshold) {
      return;
    }
    final rtl = Directionality.of(context) == TextDirection.rtl;
    // LTR: swipe left (negative v) → next tab. RTL mirrors reading direction.
    final goNext = rtl ? v > 0 : v < 0;
    final goPrev = rtl ? v < 0 : v > 0;
    if (goNext && _index < _tabCount - 1) {
      setState(() => _index++);
    } else if (goPrev && _index > 0) {
      setState(() => _index--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AdaptiveNavScaffold(
      selectedIndex: _index,
      onDestinationSelected: (i) => setState(() => _index = i),
      onBodyHorizontalDragEnd: _onHorizontalSwipeEnd,
      destinations: [
        AdaptiveDestination(
          icon: const Icon(Icons.dashboard_outlined),
          selectedIcon: const Icon(Icons.dashboard),
          label: l10n.navHome,
        ),
        AdaptiveDestination(
          icon: const Icon(Icons.local_shipping_outlined),
          selectedIcon: const Icon(Icons.local_shipping),
          label: l10n.navShipments,
        ),
        AdaptiveDestination(
          icon: const Icon(Icons.storefront_outlined),
          selectedIcon: const Icon(Icons.storefront),
          label: l10n.navCash,
        ),
        AdaptiveDestination(
          icon: const Icon(Icons.engineering_outlined),
          selectedIcon: const Icon(Icons.engineering),
          label: l10n.navLabour,
        ),
        AdaptiveDestination(
          icon: const Icon(Icons.menu),
          selectedIcon: const Icon(Icons.menu_open),
          label: l10n.navMore,
        ),
      ],
      body: IndexedStack(
        index: _index,
        children: const [
          DashboardScreen(),
          ShipmentListScreen(),
          MarketPickerScreen(),
          LabourListScreen(),
          MoreScreen(),
        ],
      ),
    );
  }
}
