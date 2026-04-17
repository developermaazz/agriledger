import 'package:flutter/material.dart';

import '../cash/presentation/market_picker_screen.dart';
import '../dashboard/presentation/dashboard_screen.dart';
import '../labour/presentation/labour_list_screen.dart';
import '../more/presentation/more_screen.dart';
import '../shipments/presentation/shipment_list_screen.dart';
import '../../shared/l10n/l10n.dart';

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
    if (v == null) {
      return;
    }
    if (v.abs() < _swipeVelocityThreshold) {
      return;
    }
    final rtl = Directionality.of(context) == TextDirection.rtl;
    // LTR: swipe left (negative v) → next tab. RTL: mirror to match reading direction.
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
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: GestureDetector(
        // Allow horizontal swipe over vertical lists; threshold avoids accidents.
        behavior: HitTestBehavior.translucent,
        onHorizontalDragEnd: _onHorizontalSwipeEnd,
        child: IndexedStack(
          index: _index,
          children: const [
            DashboardScreen(),
            ShipmentListScreen(),
            MarketPickerScreen(),
            LabourListScreen(),
            MoreScreen(),
          ],
        ),
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 18,
              offset: const Offset(0, -6),
            ),
          ],
          border: Border(
            top: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.55)),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.dashboard_outlined),
              selectedIcon: const Icon(Icons.dashboard),
              label: context.l10n.navHome,
            ),
            NavigationDestination(
              icon: const Icon(Icons.local_shipping_outlined),
              selectedIcon: const Icon(Icons.local_shipping),
              label: context.l10n.navShipments,
            ),
            NavigationDestination(
              icon: const Icon(Icons.storefront_outlined),
              selectedIcon: const Icon(Icons.storefront),
              label: context.l10n.navCash,
            ),
            NavigationDestination(
              icon: const Icon(Icons.engineering_outlined),
              selectedIcon: const Icon(Icons.engineering),
              label: context.l10n.navLabour,
            ),
            NavigationDestination(
              icon: const Icon(Icons.menu),
              selectedIcon: const Icon(Icons.menu_open),
              label: context.l10n.navMore,
            ),
          ],
        ),
      ),
    );
  }
}
