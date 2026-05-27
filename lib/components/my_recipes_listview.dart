import 'package:am_i_cooked/components/recipe_container.dart';
import 'package:am_i_cooked/models/recipe_model.dart';
import 'package:am_i_cooked/providers/recipes_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:typed_data';

class MyRecipesListview extends ConsumerStatefulWidget {
  final int userId;
  final bool isOthersProfile;
  final dynamic toggleMyRecipesExpanded;
  final dynamic getMyRecipesExpanded;
  final BuildContext? context;

  const MyRecipesListview({
    super.key,
    required this.toggleMyRecipesExpanded,
    required this.getMyRecipesExpanded,
    this.context,
    required this.userId,
    required this.isOthersProfile,
  });

  @override
  ConsumerState<MyRecipesListview> createState() => _MyRecipesListviewState();
}

class _MyRecipesListviewState extends ConsumerState<MyRecipesListview> {
  void _togleMyRecipesExpanded() {
    widget.toggleMyRecipesExpanded();
  }

  bool _getMyRecipesExpanded() {
    return widget.getMyRecipesExpanded();
  }

  final Map<String, bool> _bookmarks = {};
  static const String _placeholderImageUrl =
      'https://www.apero-bordeaux.fr/wp-content/uploads/2024/02/20240216_65cfa1ce1fa54-1024x683.jpg';

  String _bookmarkKeyFor(RecipeModel recipe, String fallback) {
    return recipe.id?.toString() ?? recipe.name ?? fallback;
  }

  String _heroTagFor(RecipeModel recipe, int index) {
    return 'my-recipes-${recipe.id ?? index}';
  }

  Uint8List? _imagePathFor(RecipeModel recipe) {
    return recipe.recipePicture?.imgBlob;
  }

  Widget _buildRecipeTile(RecipeModel recipe, int index) {
    final heroTag = _heroTagFor(recipe, index);
    final bookmarkKey = _bookmarkKeyFor(recipe, heroTag);

    return SizedBox(
      height: 200,
      child: RecipeContainer(
        key: ValueKey(heroTag),
        blobImage: _imagePathFor(recipe),
        isBookmarked: _bookmarks[bookmarkKey] ?? true,
        showBookmarkIcon: true,
        recipeTitle: recipe.displayName,
        recipePageLink: '/recipe/$heroTag',
        heroTag: heroTag,
        onBookmarkChanged: () {
          setState(() {
            _bookmarks[bookmarkKey] = !(_bookmarks[bookmarkKey] ?? true);
          });
        },
        onTap: () {
          context.push('/recipe/${recipe.id}');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recipesAsync = ref.watch(userRecipesProvider(widget.userId));

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
          bottom: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(100),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: _getMyRecipesExpanded()
                  ? Icon(Icons.keyboard_arrow_down, size: 35)
                  : Icon(Icons.keyboard_arrow_up, size: 35),
              style: ButtonStyle(
                padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                minimumSize: WidgetStateProperty.all<Size>(
                  Size(double.infinity, 30),
                ),
              ),
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              onPressed: () => setState(() {
                _togleMyRecipesExpanded();
              }),
            ),
            Text(
              "Mes Recettes",
              style: TextStyle(fontFamily: "bbh_sans_hegarty", fontSize: 22),
            ),
            Expanded(
              child: recipesAsync.when(
                data: (recipes) => recipes.isEmpty
                    ? widget.isOthersProfile
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Cet utilisateur n'a pas créé de recettes",
                                  style: TextStyle(
                                    fontFamily: "Nunito",
                                    fontWeight: FontWeight.w300,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 20,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 20,
                              children: [
                                Text(
                                  "Vous n'avez créé aucune recette pour le moment 😔",
                                  textAlign: TextAlign.center,
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
                                FilledButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                          Theme.of(
                                            context,
                                          ).colorScheme.primaryContainer,
                                        ),
                                    padding:
                                        WidgetStateProperty.all<EdgeInsets>(
                                          const EdgeInsets.symmetric(
                                            horizontal: 16.0,
                                            vertical: 12.0,
                                          ),
                                        ),
                                  ),
                                  onPressed: () => context.push('/new'),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(
                                        Icons.add_circle_outline,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onPrimaryContainer,
                                        size: 30,
                                      ),
                                      Text(
                                        "Créez votre première recette",
                                        style: TextStyle(
                                          fontFamily: "nunito",
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onPrimaryContainer,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                    : Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: recipes.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 20),
                          itemBuilder: (context, index) =>
                              _buildRecipeTile(recipes[index], index),
                        ),
                      ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Impossible de charger les recettes : $error'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
