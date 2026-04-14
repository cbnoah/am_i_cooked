import 'package:am_i_cooked/config/api_config.dart';
import 'package:am_i_cooked/components/recipe_container.dart';
import 'package:am_i_cooked/models/recipe_model.dart';
import 'package:am_i_cooked/pages/recipes_page.dart';
import 'package:am_i_cooked/providers/recipes_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyRecipesListview extends ConsumerStatefulWidget {
  final dynamic toggleMyRecipesExpanded;
  final dynamic getMyRecipesExpanded;

  const MyRecipesListview({
    super.key,
    required this.toggleMyRecipesExpanded,
    required this.getMyRecipesExpanded,
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

  String _imagePathFor(RecipeModel recipe) {
    return recipe.idPicture != null
        ? ApiConfig.getPictureUrl(recipe.idPicture!)
        : _placeholderImageUrl;
  }

  Widget _buildRecipeTile(RecipeModel recipe, int index) {
    final heroTag = _heroTagFor(recipe, index);
    final bookmarkKey = _bookmarkKeyFor(recipe, heroTag);

    return SizedBox(
      height: 200,
      child: RecipeContainer(
        key: ValueKey(heroTag),
        path: _imagePathFor(recipe),
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
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => RecipesPage(recipe: recipe, heroTag: heroTag, id: 0,),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recipesAsync = ref.watch(recipesProvider);

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
                data: (recipes) => Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ListView.separated(
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
