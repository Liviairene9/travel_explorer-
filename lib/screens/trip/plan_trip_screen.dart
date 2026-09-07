import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/trip.dart';
import '../../providers/destinations_provider.dart';
import '../../providers/trips_provider.dart';

/// Formulaire de planification de voyage, avec validation sur plusieurs
/// champs : voyageur (texte), nombre de voyageurs (numérique borné),
/// date de départ (obligatoire, future), budget (numérique positif),
/// destination (sélection obligatoire), notes (facultatif).
class PlanTripScreen extends ConsumerStatefulWidget {
  final String? initialDestinationId;

  const PlanTripScreen({super.key, this.initialDestinationId});

  @override
  ConsumerState<PlanTripScreen> createState() => _PlanTripScreenState();
}

class _PlanTripScreenState extends ConsumerState<PlanTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _travelerCountController = TextEditingController(text: '1');
  final _budgetController = TextEditingController();
  final _notesController = TextEditingController();

  String? _destinationId;
  DateTime? _startDate;

  @override
  void initState() {
    super.initState();
    _destinationId = widget.initialDestinationId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _travelerCountController.dispose();
    _budgetController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 7)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 730)),
    );
    if (picked != null) {
      setState(() => _startDate = picked);
    }
  }

  void _submit(String destinationName) {
    final isFormValid = _formKey.currentState?.validate() ?? false;
    if (!isFormValid) return;

    if (_destinationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez choisir une destination.')),
      );
      return;
    }
    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez choisir une date de départ.')),
      );
      return;
    }

    final trip = Trip(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      destinationId: _destinationId!,
      destinationName: destinationName,
      travelerName: _nameController.text.trim(),
      travelerCount: int.parse(_travelerCountController.text),
      startDate: _startDate!,
      budget: double.parse(_budgetController.text),
      notes: _notesController.text.trim(),
    );

    ref.read(tripsProvider.notifier).addTrip(trip);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Voyage à $destinationName planifié avec succès !')),
    );
    context.go('/trips');
  }

  @override
  Widget build(BuildContext context) {
    final destinationsAsync = ref.watch(destinationsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Planifier un voyage')),
      body: destinationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Erreur : $error')),
        data: (destinations) {
          final selected = destinations.where((d) => d.id == _destinationId);
          final destinationName = selected.isNotEmpty ? selected.first.name : '';

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                DropdownButtonFormField<String>(
                  value: _destinationId,
                  decoration: const InputDecoration(
                    labelText: 'Destination',
                    prefixIcon: Icon(Icons.place_outlined),
                  ),
                  items: destinations
                      .map((d) => DropdownMenuItem(
                            value: d.id,
                            child: Text('${d.name}, ${d.country}'),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => _destinationId = value),
                  validator: (value) =>
                      value == null ? 'Choisissez une destination' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nom du voyageur',
                    prefixIcon: Icon(Icons.person_outline_rounded),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    final trimmed = value?.trim() ?? '';
                    if (trimmed.isEmpty) return 'Le nom est requis';
                    if (trimmed.length < 2) return 'Nom trop court (min. 2 caractères)';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _travelerCountController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre de voyageurs',
                    prefixIcon: Icon(Icons.groups_outlined),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final n = int.tryParse(value ?? '');
                    if (n == null) return 'Entrez un nombre valide';
                    if (n < 1 || n > 20) return 'Entre 1 et 20 voyageurs';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(14),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date de départ',
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                    ),
                    child: Text(
                      _startDate == null
                          ? 'Sélectionner une date'
                          : '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _budgetController,
                  decoration: const InputDecoration(
                    labelText: 'Budget prévisionnel (FCFA)',
                    prefixIcon: Icon(Icons.payments_outlined),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final n = double.tryParse(value ?? '');
                    if (n == null) return 'Entrez un montant valide';
                    if (n <= 0) return 'Le budget doit être positif';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes (facultatif)',
                    prefixIcon: Icon(Icons.notes_rounded),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 28),
                ElevatedButton.icon(
                  onPressed: () => _submit(destinationName),
                  icon: const Icon(Icons.check_circle_outline_rounded),
                  label: const Text('Confirmer le voyage'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
