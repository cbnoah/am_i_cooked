import 'package:am_i_cooked/models/recipe_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../components/criteria_bar.dart';
import '../components/recipe_details.dart';

class RecipesPage extends StatelessWidget {
  final RecipeModel? recipe;
  final String heroTag;
  final int id;
  final String recipeTitle;
  final String imagePath;
  final List<String> criteria;
  final String author;
  final int prepTime;
  final int cookTime;
  final int servings;
  final String difficulty;
  final List<String> ingredient;
  final List<String> comment;
  final List<String> userNameComment;

  const RecipesPage({
    super.key,
    this.recipe,
    this.recipeTitle = 'Poulet Roti',
    this.imagePath =
        "https://www.apero-bordeaux.fr/wp-content/uploads/2024/02/20240216_65cfa1ce1fa54-1024x683.jpg",
    this.criteria = const ['Poulet', 'Rapide', '< 30 min'],
    this.author = 'Chef Jean',
    this.prepTime = 15,
    this.cookTime = 45,
    this.servings = 4,
    this.difficulty = 'Facile',
    this.ingredient = const ['Poulet', 'Oignon', 'Sel', 'Poivre'],
    required this.heroTag,
    this.comment = const [
      'Très bon poulet',
      'Mashallah',
      'aze',
      'flop plus ratio',
    ],
    this.userNameComment = const ['Julie', 'Paul', 'JCVD', 'SCH'],
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final String resolvedTitle = recipe?.displayName ?? "Nom Indisponible";
    final int? resolvedImageId = recipe?.idPicture;
    final List<String> resolvedCriteria = <String>[
      recipe?.difficulty ?? "Difficulté inconnue",
      '${recipe?.preparationTime ?? "??"} min',
      '${recipe?.cookingTime ?? "??"} min',
    ];
    final String resolvedDifficulty =
        recipe?.difficulty ?? "Difficulté inconnue";
    final int resolvedPrepTime = recipe?.preparationTime ?? 0;
    final int resolvedCookTime = recipe?.cookingTime ?? 0;
    final int? resolvedIdAuthor = recipe != null ? recipe?.idUser : 0;
    final List<String> resolvedIngredients = recipe == null
        ? ingredient
        : (recipe?.description == null || recipe!.description!.trim().isEmpty)
        ? const ['Aucun ingrédient fourni']
        : recipe!.description!
              .split(',')
              .map((part) => part.trim())
              .where((part) => part.isNotEmpty)
              .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(resolvedTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [IconButton(onPressed: () => context.push('/recipe/$id/edit'), icon: Icon(Icons.edit))],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: heroTag,
              child: Image.network(
                "https://www.apero-bordeaux.fr/wp-content/uploads/2024/02/20240216_65cfa1ce1fa54-1024x683.jpg",
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            RecipeCriteriaBar(criteria: resolvedCriteria),
            const SizedBox(height: 8),
            RecipeDetails(
              recipeName: recipeTitle,
              author: author,
              prepTime: prepTime,
              cookTime: cookTime,
              servings: servings,
              difficulty: difficulty,
              ingredient: ingredient,
              comment: comment,
              userNameComment: userNameComment,
            ),
          ],
        ),
      ),
    );
  }
}
