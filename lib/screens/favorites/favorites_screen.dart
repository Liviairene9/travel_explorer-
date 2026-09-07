import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/destinations_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../utils/responsive.dart';
import '../../widgets/destination_card.dart';

/// Écran Favoris : destinations que l'utilisateur a marquées d'un cœur.
class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIds = ref.watch(favoritesProvider);
    final destinationsAsync = ref.watch(destinationsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mes favoris')),
      body: destinationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Erreur : $error')),
        data: (destinations) {
          final favorites =
              destinations.where((d) => favoriteIds.contains(d.id)).toList();

          if (favorites.isEmpty) {
            return const _EmptyState();
          }

          final columns = Responsive.gridColumns(context);
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: Responsive.isTablet(context) ? 0.78 : 0.68,
            ),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final destination = favorites[index];
              return DestinationCard(
                destination: destination,
                onTap: () => context.push('/destination/${destination.id}'),
              );
            },
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_border_rounded, size: 56, color: scheme.outline),
            const SizedBox(height: 16),
            Text(
              'Aucun favori pour l\'instant',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Touchez le cœur sur une destination pour la retrouver ici.',
              textAlign: TextAlign.center,
              style: TextStyle(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
