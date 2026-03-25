import 'package:flutter/material.dart';
import 'package:am_i_cooked/components/multi_select_pill_dropdown.dart';
import 'package:am_i_cooked/components/recipe_card.dart';
import 'package:am_i_cooked/data/search_data.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> selectedRegimes = [];
  List<String> selectedAllergenes = [];

  final List<Recipe> recipes = const [
    Recipe(
      title: 'Recette test',
      imageAssets: 'assets/fonts/image/recette_test.png',
    ),
    Recipe(
      title: 'Recette test',
      imageAssets: 'assets/fonts/image/recette_test.png',
    ),
    Recipe(
      title: 'Recette test',
      imageAssets: 'assets/fonts/image/recette_test.png',
    ),
  ];

  late List<bool> bookmarked;

  @override
  void initState() {
    super.initState();
    // au début, aucune recette n'est bookmarkée
    bookmarked = List<bool>.filled(recipes.length, false);
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF3F1FA);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Hinted search text',
                                hintStyle: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black45,
                                ),
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

              Row(
                children: [
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(24),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: () {},
                        child: MultiSelectPillDropdown<String>(
                          hintText: 'Régimes',
                          hintStyle: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          values: selectedRegimes,
                          items: SearchData.regimes,
                          onSelected: (v) =>
                              setState(() => selectedRegimes = v),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(24),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: () {},
                        child: MultiSelectPillDropdown<String>(
                          hintText: 'Allergènes',
                          hintStyle: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          values: selectedAllergenes,
                          items: SearchData.allergenes,
                          onSelected: (v) =>
                              setState(() => selectedAllergenes = v),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: SearchData.labels.length,
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
                        SearchData.labels[i],
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 14),

              const Text(
                '25 Résultats',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 12),

              Expanded(
                child: ListView.separated(
                  itemCount: recipes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final r = recipes[index];
                    return RecipeCard(
                      title: r.title,
                      imageAssets: r.imageAssets,
                      isBookmarked: bookmarked[index],
                      onBookmark: () {
                        setState(() {
                          bookmarked[index] = !bookmarked[index];
                        });
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
