import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/trip.dart';

/// Liste des voyages planifiés via le formulaire "Planifier un voyage".
class TripsNotifier extends StateNotifier<List<Trip>> {
  TripsNotifier() : super(const []);

  void addTrip(Trip trip) {
    state = [...state, trip];
  }

  void removeTrip(String tripId) {
    state = state.where((t) => t.id != tripId).toList();
  }
}

final tripsProvider = StateNotifierProvider<TripsNotifier, List<Trip>>(
  (ref) => TripsNotifier(),
);
