import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/destinations_provider.dart';
import '../../utils/responsive.dart';
import '../../widgets/category_filter_bar.dart';
import '../../widgets/destination_card.dart';

/// Écran liste : recherche + filtrage par catégorie, grille responsive.
class ExplorerScreen extends ConsumerWidget {
  const ExplorerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredAsync = ref.watch(filteredDestinationsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final query = ref.watch(searchQueryProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explorer'),
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(destinationsProvider),
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              sliver: SliverToBoxAdapter(
                child: CategoryFilterBar(
                  query: query,
                  onQueryChanged: (value) =>
                      ref.read(searchQueryProvider.notifier).state = value,
                  categories: categoriesAsync.valueOrNull ?? const [],
                  selectedCategory: selectedCategory,
                  onCategorySelected: (value) =>
                      ref.read(selectedCategoryProvider.notifier).state = value,
                ),
              ),
            ),
            filteredAsync.when(
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, stackTrace) => SliverFillRemaining(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text('Erreur de chargement des destinations : $error'),
                  ),
                ),
              ),
              data: (destinations) {
                if (destinations.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: Text('Aucune destination ne correspond à votre recherche.'),
                    ),
                  );
                }
                final columns = Responsive.gridColumns(context);
                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: Responsive.isTablet(context) ? 0.78 : 0.68,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final destination = destinations[index];
                        return DestinationCard(
                          destination: destination,
                          onTap: () => context.push('/destination/${destination.id}'),
                        );
                      },
                      childCount: destinations.length,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/plan-trip'),
        icon: const Icon(Icons.airplanemode_active_rounded),
        label: const Text('Planifier'),
      ),
    );
  }
}
