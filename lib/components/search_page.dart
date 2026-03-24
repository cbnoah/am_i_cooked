import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? selectedRegime;
  String? selectedAllergene;

  final List<String> regimes = [
    'Végétarien',
    'Vegan',
    'Sans gluten',
    'Keto',
    'Halal',
  ];

  final List<String> allergenes = [
    'Lactose',
    'Arachide',
    'Oeuf',
    'Fruits à coque',
    'Soja',
  ];

  final List<String> labels = [
    'Label',
    'Label',
    'Label',
    'Label',
    'Label',
    'Label',
    'Label',
  ];

  final List<_Recipe> recipes = const [
    _Recipe(
      title: 'Recette test',
      imageUrl:
      'https://images.unsplash.com/photo-1604908176997-125f25cc500f?w=1200',
    ),
    _Recipe(
      title: 'Recette test',
      imageUrl:
      'https://images.unsplash.com/photo-1604908176997-125f25cc500f?w=1200',
    ),
    _Recipe(
      title: 'Recette test',
      imageUrl:
      'https://images.unsplash.com/photo-1604908176997-125f25cc500f?w=1200',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF3F1FA);
    const pill = Color(0xFF6750A4);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Barre de recherche ---
              Row(
                children: [
                  Material(
                    color: const Color(0xFFEADEFF),
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => Navigator.maybePop(context),
                      child: const SizedBox(
                        width: 44,
                        height: 44,
                        child: Icon(Icons.arrow_back),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.55),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Hinted search text',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Icon(Icons.search),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // --- Filtres (pills) ---
              Row(
                children: [
                  Expanded(
                    child: _PillDropdown<String>(
                      hintText: 'Régimes',
                      value: selectedRegime,
                      items: regimes,
                      onSelected: (v) => setState(() => selectedRegime = v),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _PillDropdown<String>(
                      hintText: 'Allergies',
                      value: selectedAllergene,
                      items: allergenes,
                      onSelected: (v) => setState(() => selectedAllergene = v),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // --- Chips horizontales ---
              SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: labels.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, i) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.15),
                        ),
                      ),
                      child: Text(
                        labels[i],
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 14),

              // --- Résultats ---
              const Text(
                '25 Résultats',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 12),

              // --- Liste des cartes ---
              Expanded(
                child: ListView.separated(
                  itemCount: recipes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final r = recipes[index];
                    return _RecipeCard(
                      title: r.title,
                      imageUrl: r.imageUrl,
                      onBookmark: () {
                        // TODO: bookmark
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------- Widgets --------------------

class _PillDropdown<T> extends StatelessWidget {
  const _PillDropdown({
    required this.hintText,
    required this.value,
    required this.items,
    required this.onSelected,
  });

  final String hintText;
  final T? value;
  final List<T> items;
  final ValueChanged<T?> onSelected;

  @override
  Widget build(BuildContext context) {
    const pill = Color(0xFF6750A4);

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: pill,
        borderRadius: BorderRadius.circular(999),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          dropdownColor: Colors.white,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
          hint: Text(
            hintText,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
          items: items
              .map(
                (e) => DropdownMenuItem<T>(
              value: e,
              child: Text(e.toString()),
            ),
          )
              .toList(),
          onChanged: onSelected,
        ),
      ),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  const _RecipeCard({
    required this.title,
    required this.imageUrl,
    required this.onBookmark,
  });

  final String title;
  final String imageUrl;
  final VoidCallback onBookmark;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 16 / 8,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  color: Colors.black.withOpacity(0.05),
                  child: const Center(child: CircularProgressIndicator()),
                );
              },
            ),
          ),

          // Bandeau bas blanc arrondi
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Container(
              height: 54,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Material(
                    color: const Color(0xFFEADEFF),
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: onBookmark,
                      child: const SizedBox(
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.bookmark_border,
                          color: Color(0xFF6750A4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------- Models --------------------

class _Recipe {
  final String title;
  final String imageUrl;
  const _Recipe({required this.title, required this.imageUrl});
}