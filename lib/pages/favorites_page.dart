import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../components/recipe_container.dart';
import '../config/api_config.dart';
import '../models/recipe_model.dart';
import '../providers/favorites_provider.dart';
import '../providers/recipes_provider.dart';

class FavoritesPage extends ConsumerStatefulWidget {
  const FavoritesPage({super.key});

  @override
  ConsumerState<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends ConsumerState<FavoritesPage> {
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

  List<SizedBox?> _buildCarouselChildren(
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

      if (!bookmarks.contains(recipe.id)) {
        return null;
      } else {
        return SizedBox(
          height: 200,
          child: RecipeContainer(
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
              try {
                await bookmarkActions.toggleBookmark(recipe.id!);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Favori retiré'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              } catch (e) {
                print('Error toggling bookmark: $e');
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'Erreur lors de la suppression du favori',
                      ),
                      duration: const Duration(seconds: 3),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  );
                }
              }
            },
          ),
        );
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final recipesAsync = ref.watch(recipesProvider);
    final userIdAsync = ref.watch(userIdProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorites',
          style: TextStyle(
            fontFamily: "bbh_sans_hegarty",
            color: Theme.of(context).colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
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
              print(recipes);
              return bookmarksAsync.when(
                data: (bookmarks) {
                  print('Bookmarks count: ${bookmarks.length}');
                  print('Bookmarks IDs: $bookmarks');
                  return RefreshIndicator(
                    onRefresh: () async {
                      print('Refreshing bookmarks...');
                      try {
                        ref.invalidate(bookmarksProvider(userId));

                        ref.read(bookmarksProvider(userId));

                        await Future.delayed(const Duration(milliseconds: 100));

                        print('Bookmarks refresh completed');
                      } catch (e) {
                        print('Error refreshing bookmarks: $e');
                      }
                    },
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Builder(
                                builder: (context) {
                                  final favoriteItems = _buildCarouselChildren(
                                    'favorites',
                                    recipes,
                                    bookmarks,
                                    userId,
                                  );
                                  print("Favorite items: $favoriteItems");
                                  if (favoriteItems.isEmpty) {
                                    return SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                          0.6,
                                      child: Center(
                                        child: Text(
                                          'Aucun favori pour le moment',
                                          style: TextStyle(
                                            fontFamily: "Nunito",
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurface,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  }
                                  favoriteItems.removeWhere(
                                    (element) => element == null,
                                  );
                                  return ListView.separated(
                                    scrollDirection: Axis.vertical,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: 16),
                                    itemBuilder: (context, index) =>
                                        favoriteItems[index],
                                    itemCount: favoriteItems.length,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                error: (error, stackTrace) {
                  print('Bookmarks error: $error');
                  print('Bookmarks stack trace: $stackTrace');
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Erreur lors du chargement des favoris",
                          style: TextStyle(
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          error.toString(),
                          style: TextStyle(
                            fontFamily: "Nunito",
                            fontSize: 14,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
                loading: () {
                  return const Center(child: CircularProgressIndicator());
                },
              );
            },
            error: (error, stackTrace) {
              return Center(
                child: Text(
                  "Erreur lors du chargement de votre profil",
                  style: TextStyle(
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
          );
        },
        error: (Object error, StackTrace stackTrace) {
          return Center(
            child: Text(
              "Erreur lors du chargement de votre profil",
              style: TextStyle(
                fontFamily: "Nunito",
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
