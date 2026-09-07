import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/detail/destination_detail_screen.dart';
import '../screens/explorer/explorer_screen.dart';
import '../screens/favorites/favorites_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/shell/app_shell.dart';
import '../screens/trip/plan_trip_screen.dart';
import '../screens/trips/trips_screen.dart';

/// Noms de routes centralisés — utilisés partout via `context.goNamed` /
/// `context.pushNamed` pour éviter les chaînes codées en dur dispersées.
class AppRoutes {
  AppRoutes._();
  static const explorer = 'explorer';
  static const favorites = 'favorites';
  static const trips = 'trips';
  static const settings = 'settings';
  static const detail = 'detail';
  static const planTrip = 'planTrip';
}

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/',
            name: AppRoutes.explorer,
            builder: (context, state) => const ExplorerScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/favorites',
            name: AppRoutes.favorites,
            builder: (context, state) => const FavoritesScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/trips',
            name: AppRoutes.trips,
            builder: (context, state) => const TripsScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/settings',
            name: AppRoutes.settings,
            builder: (context, state) => const SettingsScreen(),
          ),
        ]),
      ],
    ),
    // Écran de détail : paramètre :id dans le chemin, hors de la coquille
    // de navigation pour s'afficher en plein écran (avec bouton retour).
    GoRoute(
      path: '/destination/:id',
      name: AppRoutes.detail,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => DestinationDetailScreen(
        destinationId: state.pathParameters['id']!,
      ),
    ),
    // Formulaire : destination pré-remplie optionnelle via query param.
    GoRoute(
      path: '/plan-trip',
      name: AppRoutes.planTrip,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => PlanTripScreen(
        initialDestinationId: state.uri.queryParameters['destinationId'],
      ),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Page introuvable')),
    body: Center(child: Text('Aucune route pour : ${state.uri}')),
  ),
);
