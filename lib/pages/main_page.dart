import 'package:am_i_cooked/config/api_config.dart';
import 'package:am_i_cooked/models/recipe_model.dart';
import 'package:am_i_cooked/providers/recipes_provider.dart';
import 'package:am_i_cooked/providers/bookmarks_provider.dart';
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
  static const String _placeholderImageUrl =
      'https://www.apero-bordeaux.fr/wp-content/uploads/2024/02/20240216_65cfa1ce1fa54-1024x683.jpg';

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
    List<int> bookmarks,
    int userId,
  ) {
    return recipes.asMap().entries.map((entry) {
      final index = entry.value.id;
      final recipe = entry.value;
      final heroTag = _heroTagFor(prefix, recipe, index!);
      final imagePath = _imagePathFor(recipe);

      return RecipeContainer(
        key: ValueKey(heroTag),
        path: imagePath,
        isBookmarked: bookmarks.contains(recipe.id),
        showBookmarkIcon: true,
        recipeTitle: recipe.displayName,
        recipePageLink: '/recipe/$heroTag',
        heroTag: heroTag,
        onTap: () => context.push('/recipe/$index'),
        onBookmarkChanged: () async {
          final bookmarkActions = ref.read(bookmarkActionsProvider(userId));
          await bookmarkActions.toggleBookmark(recipe.id!);
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final recipesAsync = ref.watch(recipesProvider);
    final userIdAsync = ref.watch(userIdProvider);

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
      body: userIdAsync.when(
        data: (userId) {
          if (userId == null) {
            return Center(
              child: Text(
                "Impossible de charger votre profil",
                style: TextStyle(
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            );
          }

          final bookmarksAsync = ref.watch(bookmarksProvider(userId));

          return recipesAsync.when(
            data: (recipes) {
              print('MainPage: Recipes loaded, count=${recipes.length}');
              final recommendedCarousel = recipes.take(5).toList();
              final trendsCarousel = recipes.take(5).toList();

              return bookmarksAsync.when(
                data: (bookmarks) {
                  print(
                    'MainPage: Bookmarks loaded, count=${bookmarks.length}, ids=$bookmarks',
                  );
                  return RefreshIndicator(
                    onRefresh: () async {
                      print('Refreshing recipes and bookmarks...');
                      try {
                        ref.invalidate(recipesProvider);
                        ref.invalidate(bookmarksProvider(userId));

                        ref.read(recipesProvider);
                        ref.read(bookmarksProvider(userId));
                        await Future.delayed(const Duration(milliseconds: 100));

                        print('Refresh completed successfully');
                      } catch (e) {
                        print('Error during refresh: $e');
                      }
                    },
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
                                        bookmarks,
                                        userId,
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
                                        bookmarks,
                                        userId,
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
                  child: Text(
                    'Erreur lors du chargement des bookmarks',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(
              child: Text(
                'Impossible de charger les recettes : $error',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text(
            'Erreur lors du chargement du profil',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBarSwitcher(),
    );
  }
}
