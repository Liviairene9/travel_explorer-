import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Ensemble des identifiants de destinations mises en favori.
class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super(<String>{});

  void toggle(String destinationId) {
    final updated = {...state};
    if (updated.contains(destinationId)) {
      updated.remove(destinationId);
    } else {
      updated.add(destinationId);
    }
    state = updated;
  }

  bool isFavorite(String destinationId) => state.contains(destinationId);
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, Set<String>>(
  (ref) => FavoritesNotifier(),
);
