import 'package:am_i_cooked/pages/recipes_page.dart';
import 'package:flutter/material.dart';
import 'package:am_i_cooked/components/multi_select_pill_dropdown.dart';
import 'package:am_i_cooked/data/search_data.dart';

import '../components/recipe_container.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> _filterSelectedLabels = [];
  final Map<String, bool> _bookmarks = {};
  List<String> selectedRegimes = [];
  List<String> selectedAllergenes = [];

  late final List<RecipeContainer> recipes = List.generate(5, (index) {
    final key = 'search-$index';
    return RecipeContainer(
      key: ValueKey(key),
      path:
          "https://www.apero-bordeaux.fr/wp-content/uploads/2024/02/20240216_65cfa1ce1fa54-1024x683.jpg",
      isBookmarked: _bookmarks[key] ?? true,
      showBookmarkIcon: true,
      recipeTitle: 'Poulet Roti',
      recipePageLink: '/recipe/$key',
      heroTag: key,
      onBookmarkChanged: () {
        setState(() {
          _bookmarks[key] = !(_bookmarks[key] ?? true);
        });
      },
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => RecipesPage(
              recipeTitle: "Poulet Roti",
              imagePath:
                  "https://www.apero-bordeaux.fr/wp-content/uploads/2024/02/20240216_65cfa1ce1fa54-1024x683.jpg",
              criteria: ['Végétarien', 'Rapide', '< 30 min'],
              author: 'Chef Jean',
              prepTime: 15,
              cookTime: 45,
              servings: 4,
              difficulty: 'Facile',
              heroTag: key,
            ),
          ),
        );
      },
    );
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
                        color: Colors.white.withAlpha(140),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.black45.withAlpha(100),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              textAlign: TextAlign.left,
                              textAlignVertical: TextAlignVertical.center,
                              style: const TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                height: 1.0,
                              ),
                              decoration: InputDecoration(
                                isCollapsed: true,
                                contentPadding: EdgeInsets.zero,
                                hintText: 'Hinted search text',
                                hintStyle: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 16,
                                  // même taille que style
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black.withAlpha(200),
                                  height: 1.0,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const Icon(Icons.search),
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

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Divider(
                  height: 32,
                  thickness: 1.5,
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                ),
              ),

              SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: SearchData.labels.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (context, i) {
                    final String filter = SearchData.labels[i];
                    final bool isSelected = _filterSelectedLabels.contains(
                      filter,
                    );
                    return ChoiceChip(
                      label: Text(SearchData.labels[i]),
                      selected: isSelected,
                      selectedColor: Theme.of(
                        context,
                      ).colorScheme.primaryContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: isSelected
                              ? Colors.transparent
                              : Theme.of(context).colorScheme.tertiaryContainer,
                          width: 1.5,
                        ),
                      ),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            _filterSelectedLabels.add(filter);
                          } else {
                            _filterSelectedLabels.remove(filter);
                          }
                        });
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 14),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${recipes.length} résultats',
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Expanded(
                child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  itemCount: 5,
                  separatorBuilder: (context, index) => SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    final key = 'profile-recipe-$index';
                    return SizedBox(
                      height: 200,
                      child: RecipeContainer(
                        key: ValueKey(key),
                        path:
                            "https://www.apero-bordeaux.fr/wp-content/uploads/2024/02/20240216_65cfa1ce1fa54-1024x683.jpg",
                        isBookmarked: _bookmarks[key] ?? true,
                        showBookmarkIcon: true,
                        recipeTitle: 'Poulet Roti',
                        recipePageLink: '/recipe/$key',
                        heroTag: key,
                        onBookmarkChanged: () {
                          setState(() {
                            _bookmarks[key] = !(_bookmarks[key] ?? true);
                          });
                        },
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => RecipesPage(
                                recipeTitle: "Poulet Roti",
                                imagePath:
                                    "https://www.apero-bordeaux.fr/wp-content/uploads/2024/02/20240216_65cfa1ce1fa54-1024x683.jpg",
                                criteria: ['Végétarien', 'Rapide', '< 30 min'],
                                author: 'Chef Jean',
                                prepTime: 15,
                                cookTime: 45,
                                servings: 4,
                                difficulty: 'Facile',
                                heroTag: key,
                              ),
                            ),
                          );
                        },
                      ),
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
