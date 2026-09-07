import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/destination.dart';

/// Couche d'accès aux données : charge les destinations depuis le fichier
/// JSON embarqué dans les assets. Aucune donnée n'est jamais écrite en dur
/// dans un widget — tout transite par ce repository.
class DestinationRepository {
  static const _assetPath = 'assets/data/destinations.json';

  Future<List<Destination>> fetchDestinations() async {
    final raw = await rootBundle.loadString(_assetPath);
    final List<dynamic> decoded = json.decode(raw) as List<dynamic>;
    return decoded
        .map((item) => Destination.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
