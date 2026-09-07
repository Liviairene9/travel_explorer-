/// Modèle représentant une destination de voyage.
///
/// Aucune donnée n'est codée en dur ici : les instances sont construites
/// à partir du JSON chargé par [DestinationRepository].
class Destination {
  final String id;
  final String name;
  final String country;
  final String category;
  final String imageUrl;
  final String description;
  final double rating;
  final double pricePerNight;
  final int durationDays;
  final List<String> tags;

  const Destination({
    required this.id,
    required this.name,
    required this.country,
    required this.category,
    required this.imageUrl,
    required this.description,
    required this.rating,
    required this.pricePerNight,
    required this.durationDays,
    required this.tags,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      id: json['id'] as String,
      name: json['name'] as String,
      country: json['country'] as String,
      category: json['category'] as String,
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String,
      rating: (json['rating'] as num).toDouble(),
      pricePerNight: (json['pricePerNight'] as num).toDouble(),
      durationDays: json['durationDays'] as int,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
    );
  }

  String get fullLocation => '$name, $country';
}
