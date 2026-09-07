import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/destination.dart';
import '../../providers/destinations_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../utils/responsive.dart';
import '../../widgets/rating_stars.dart';
import '../../widgets/section_title.dart';

/// Écran de détail. Reçoit l'identifiant de la destination en paramètre
/// de route (`/destination/:id`) et retrouve l'objet complet via le provider.
class DestinationDetailScreen extends ConsumerWidget {
  final String destinationId;

  const DestinationDetailScreen({super.key, required this.destinationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final destinationsAsync = ref.watch(destinationsProvider);

    return Scaffold(
      body: destinationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Erreur : $error')),
        data: (destinations) {
          final destination = destinations.firstWhere(
            (d) => d.id == destinationId,
            orElse: () => destinations.first,
          );
          return Responsive.isTablet(context)
              ? _TabletLayout(destination: destination)
              : _MobileLayout(destination: destination);
        },
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final Destination destination;
  const _MobileLayout({required this.destination});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _HeroAppBar(destination: destination),
        SliverToBoxAdapter(
          child: _DetailBody(destination: destination),
        ),
      ],
    );
  }
}

class _TabletLayout extends StatelessWidget {
  final Destination destination;
  const _TabletLayout({required this.destination});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Hero(
                  tag: 'destination-image-${destination.id}',
                  child: Image.network(destination.imageUrl, fit: BoxFit.cover),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: _BackButton(),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 6,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: _DetailBody(destination: destination),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroAppBar extends StatelessWidget {
  final Destination destination;
  const _HeroAppBar({required this.destination});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: 'destination-image-${destination.id}',
          child: Image.network(destination.imageUrl, fit: BoxFit.cover),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.35),
      shape: const CircleBorder(),
      child: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
        onPressed: () => context.pop(),
      ),
    );
  }
}

class _DetailBody extends ConsumerWidget {
  final Destination destination;

  const _DetailBody({required this.destination});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(favoritesProvider).contains(destination.id);
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  destination.fullLocation,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              IconButton.filledTonal(
                onPressed: () =>
                    ref.read(favoritesProvider.notifier).toggle(destination.id),
                icon: Icon(
                  isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: isFavorite ? Colors.redAccent : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              RatingStars(rating: destination.rating, size: 18),
              _InfoPill(icon: Icons.schedule_rounded, label: '${destination.durationDays} jours conseillés'),
              _InfoPill(
                icon: Icons.payments_outlined,
                label: '${destination.pricePerNight.toStringAsFixed(0)} FCFA / nuit',
              ),
            ],
          ),
          const SizedBox(height: 20),
          const SectionTitle(title: 'À propos', icon: Icons.info_outline_rounded),
          Text(
            destination.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
          const SizedBox(height: 20),
          const SectionTitle(title: 'Points forts', icon: Icons.local_offer_outlined),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: destination.tags
                .map((tag) => Chip(
                      label: Text(tag),
                      backgroundColor: scheme.secondaryContainer,
                    ))
                .toList(),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => context.push('/plan-trip?destinationId=${destination.id}'),
              icon: const Icon(Icons.airplanemode_active_rounded),
              label: const Text('Planifier ce voyage'),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: scheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13)),
      ],
    );
  }
}
