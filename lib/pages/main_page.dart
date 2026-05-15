import 'package:am_i_cooked/config/api_config.dart';
import 'package:am_i_cooked/models/recipe_model.dart';
import 'package:am_i_cooked/providers/recipes_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../utils/nav_bar_switcher.dart';
import '../components/recipe_container.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  final Map<String, bool> _bookmarks = {};
  static const String _placeholderImageUrl =
      'https://www.apero-bordeaux.fr/wp-content/uploads/2024/02/20240216_65cfa1ce1fa54-1024x683.jpg';

  String _bookmarkKeyFor(RecipeModel recipe, String fallback) {
    return recipe.id?.toString() ?? recipe.name ?? fallback;
  }

  String _heroTagFor(String prefix, RecipeModel recipe, int index) {
    return '$prefix-${recipe.id ?? index}';
  }

  String _imagePathFor(RecipeModel recipe) {
    return recipe.idPicture != null
        ? ApiConfig.getRecipePictureUrl(recipe.idPicture!)
        : _placeholderImageUrl;
  }

  List<Widget> _buildCarouselChildren(
    String prefix,
    List<RecipeModel> recipes,
  ) {
    return recipes.asMap().entries.map((entry) {
      final index = entry.value.id;
      final recipe = entry.value;
      final heroTag = _heroTagFor(prefix, recipe, index!);
      final bookmarkKey = _bookmarkKeyFor(recipe, heroTag);
      final imagePath = _imagePathFor(recipe);

      return RecipeContainer(
        key: ValueKey(heroTag),
        path: imagePath,
        isBookmarked: _bookmarks[bookmarkKey] ?? true,
        showBookmarkIcon: true,
        recipeTitle: recipe.displayName,
        recipePageLink: '/recipe/$heroTag',
        heroTag: heroTag,
        onTap: () => context.push('/recipe/$index'),
        onBookmarkChanged: () {
          setState(() {
            _bookmarks[bookmarkKey] = !(_bookmarks[bookmarkKey] ?? true);
          });
        },
      );
    }).toList();
  }

  // TODO: implement trends carousel with real data (maybe based on number of bookmarks or notation?)
  @override
  Widget build(BuildContext context) {
    final recipesAsync = ref.watch(recipesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Am I Cooked ?",
          style: TextStyle(
            fontFamily: "bbh_sans_hegarty",
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: recipesAsync.when(
        data: (recipes) {
          final recommendedCarousel = recipes.take(5).toList();
          final trendsCarousel = recipes.take(5).toList();

          return RefreshIndicator(
            onRefresh: () => ref.refresh(recipesProvider.future),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 8.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enfin de retour 👋!',
                      style: TextStyle(
                        fontFamily: 'nunito',
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        fontSize: 36,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      'Voici quelques nouvelles recettes à tester',
                      style: TextStyle(
                        fontFamily: 'nunito',
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 15.0,
                      ),
                      child: Divider(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    Text(
                      'Recommendations : ',
                      style: TextStyle(
                        fontFamily: 'nunito',
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: 180,
                        maxWidth: MediaQuery.of(context).size.width,
                      ),
                      child: recommendedCarousel.isEmpty
                          ? Center(
                              child: Text(
                                "Aucune recette trouvée 😢",
                                style: TextStyle(
                                  fontFamily: "Nunito",
                                  fontWeight: FontWeight.w300,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 20,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                            )
                          : CarouselView(
                              enableSplash: false,
                              itemSnapping: true,
                              itemExtent: 270.0,
                              children: _buildCarouselChildren(
                                'forYou',
                                recommendedCarousel,
                              ),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 5.0,
                      ),
                      child: Divider(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    Text(
                      'Tendance : ',
                      style: TextStyle(
                        fontFamily: 'nunito',
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: 180,
                        maxWidth: MediaQuery.of(context).size.width,
                      ),
                      child: trendsCarousel.isEmpty
                          ? Center(
                              child: Text(
                                "Aucune recette trouvée 😢",
                                style: TextStyle(
                                  fontFamily: "Nunito",
                                  fontWeight: FontWeight.w300,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 20,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                            )
                          : CarouselView(
                              enableSplash: false,
                              itemSnapping: true,
                              itemExtent: 270.0,
                              children: _buildCarouselChildren(
                                'trends',
                                trendsCarousel,
                              ),
                            ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Impossible de charger les recettes : $error',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w700,
                fontSize: 50,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBarSwitcher(),
    );
  }
}
