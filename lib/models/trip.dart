/// Modèle représentant un voyage planifié par l'utilisateur via le formulaire.
class Trip {
  final String id;
  final String destinationId;
  final String destinationName;
  final String travelerName;
  final int travelerCount;
  final DateTime startDate;
  final double budget;
  final String notes;

  const Trip({
    required this.id,
    required this.destinationId,
    required this.destinationName,
    required this.travelerName,
    required this.travelerCount,
    required this.startDate,
    required this.budget,
    required this.notes,
  });
}
