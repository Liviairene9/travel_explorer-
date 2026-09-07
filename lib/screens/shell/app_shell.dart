import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/responsive.dart';

/// Coquille de navigation avec 4 onglets. Sur mobile, une [NavigationBar]
/// en bas ; sur tablette/desktop, un [NavigationRail] sur le côté —
/// c'est ici que l'adaptation mobile/tablette de la navigation se joue.
class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  static const _destinations = [
    (icon: Icons.explore_outlined, selectedIcon: Icons.explore_rounded, label: 'Explorer'),
    (icon: Icons.favorite_border_rounded, selectedIcon: Icons.favorite_rounded, label: 'Favoris'),
    (icon: Icons.card_travel_outlined, selectedIcon: Icons.card_travel_rounded, label: 'Voyages'),
    (icon: Icons.settings_outlined, selectedIcon: Icons.settings_rounded, label: 'Réglages'),
  ];

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Responsive.isTablet(context)) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: _onTap,
              labelType: NavigationRailLabelType.all,
              destinations: _destinations
                  .map((d) => NavigationRailDestination(
                        icon: Icon(d.icon),
                        selectedIcon: Icon(d.selectedIcon),
                        label: Text(d.label),
                      ))
                  .toList(),
            ),
            const VerticalDivider(width: 1),
            Expanded(child: navigationShell),
          ],
        ),
      );
    }

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onTap,
        destinations: _destinations
            .map((d) => NavigationDestination(
                  icon: Icon(d.icon),
                  selectedIcon: Icon(d.selectedIcon),
                  label: d.label,
                ))
            .toList(),
      ),
    );
  }
}
