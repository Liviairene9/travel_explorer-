import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/destination.dart';
import '../services/destination_repository.dart';

final destinationRepositoryProvider = Provider<DestinationRepository>(
  (ref) => DestinationRepository(),
);

/// Charge la liste complète des destinations depuis le repository.
final destinationsProvider = FutureProvider<List<Destination>>((ref) async {
  final repository = ref.watch(destinationRepositoryProvider);
  return repository.fetchDestinations();
});

/// Texte de recherche courant (écran Explorer).
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Catégorie sélectionnée pour le filtrage (null = toutes).
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

/// Liste dérivée : destinations filtrées par recherche + catégorie.
final filteredDestinationsProvider = Provider<AsyncValue<List<Destination>>>(
  (ref) {
    final destinationsAsync = ref.watch(destinationsProvider);
    final query = ref.watch(searchQueryProvider).trim().toLowerCase();
    final category = ref.watch(selectedCategoryProvider);

    return destinationsAsync.whenData((destinations) {
      return destinations.where((d) {
        final matchesQuery = query.isEmpty ||
            d.name.toLowerCase().contains(query) ||
            d.country.toLowerCase().contains(query);
        final matchesCategory = category == null || d.category == category;
        return matchesQuery && matchesCategory;
      }).toList();
    });
  },
);

/// Liste des catégories disponibles, dérivée des données (pas codée en dur).
final categoriesProvider = Provider<AsyncValue<List<String>>>((ref) {
  final destinationsAsync = ref.watch(destinationsProvider);
  return destinationsAsync.whenData(
    (destinations) => destinations.map((d) => d.category).toSet().toList()..sort(),
  );
});
