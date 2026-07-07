import 'package:flutter/material.dart';

import '../widgets/app_brand.dart';
import 'breakpoints.dart';

/// A single primary navigation target.
class AdaptiveDestination {
  const AdaptiveDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final Widget icon;
  final Widget selectedIcon;
  final String label;
}

/// Adaptive navigation shell: a bottom [NavigationBar] on compact widths, and a
/// [NavigationRail] (extended on desktop) on medium/expanded widths. [body] is
/// shown in the content region; each screen keeps its own AppBar/FAB.
class AdaptiveNavScaffold extends StatelessWidget {
  const AdaptiveNavScaffold({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.body,
    this.onBodyHorizontalDragEnd,
  });

  final List<AdaptiveDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget body;

  /// Optional swipe-to-switch handler, applied only on compact layouts.
  final GestureDragEndCallback? onBodyHorizontalDragEnd;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (context.isCompact) {
      final content = onBodyHorizontalDragEnd == null
          ? body
          : GestureDetector(
              behavior: HitTestBehavior.translucent,
              onHorizontalDragEnd: onBodyHorizontalDragEnd,
              child: body,
            );
      return Scaffold(
        body: content,
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
              top: BorderSide(
                color: cs.outlineVariant.withValues(alpha: 0.55),
              ),
            ),
          ),
          child: NavigationBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            destinations: [
              for (final d in destinations)
                NavigationDestination(
                  icon: d.icon,
                  selectedIcon: d.selectedIcon,
                  label: d.label,
                ),
            ],
          ),
        ),
      );
    }

    final extended = context.isExpanded;
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            NavigationRail(
              extended: extended,
              minExtendedWidth: 208,
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              labelType: extended
                  ? NavigationRailLabelType.none
                  : NavigationRailLabelType.all,
              leading: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: extended ? 4 : 0,
                ),
                child: const AppLogoMark(size: 36),
              ),
              destinations: [
                for (final d in destinations)
                  NavigationRailDestination(
                    icon: d.icon,
                    selectedIcon: d.selectedIcon,
                    label: Text(d.label),
                  ),
              ],
            ),
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: cs.outlineVariant.withValues(alpha: 0.5),
            ),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}
