import 'package:flutter/material.dart';

/// Widget réutilisable : barre de recherche + chips de filtrage par catégorie.
/// Utilisé par l'écran Explorer ; entièrement piloté par callbacks, sans
/// aucune donnée codée en dur.
class CategoryFilterBar extends StatefulWidget {
  final String query;
  final ValueChanged<String> onQueryChanged;
  final List<String> categories;
  final String? selectedCategory;
  final ValueChanged<String?> onCategorySelected;

  const CategoryFilterBar({
    super.key,
    required this.query,
    required this.onQueryChanged,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  State<CategoryFilterBar> createState() => _CategoryFilterBarState();
}

class _CategoryFilterBarState extends State<CategoryFilterBar> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.query);

  @override
  void didUpdateWidget(covariant CategoryFilterBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Ne resynchronise que si la valeur a changé depuis l'extérieur
    // (ex: bouton "effacer"), pour ne pas casser la position du curseur.
    if (widget.query != _controller.text) {
      _controller.value = _controller.value.copyWith(
        text: widget.query,
        selection: TextSelection.collapsed(offset: widget.query.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          onChanged: widget.onQueryChanged,
          decoration: InputDecoration(
            hintText: 'Rechercher une destination ou un pays…',
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: widget.query.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded),
                    onPressed: () => widget.onQueryChanged(''),
                  )
                : null,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: widget.categories.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              if (index == 0) {
                return ChoiceChip(
                  label: const Text('Toutes'),
                  selected: widget.selectedCategory == null,
                  onSelected: (_) => widget.onCategorySelected(null),
                );
              }
              final category = widget.categories[index - 1];
              return ChoiceChip(
                label: Text(category),
                selected: widget.selectedCategory == category,
                onSelected: (_) => widget.onCategorySelected(category),
              );
            },
          ),
        ),
      ],
    );
  }
}
