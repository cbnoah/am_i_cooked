import 'package:flutter/material.dart';
import '../components/criteria_bar.dart';
import '../components/recipe_details.dart';

class RecipesPage extends StatelessWidget {
  final String recipeTitle;
  final String imagePath;
  final List<String> criteria;
  final String author;
  final int prepTime;
  final int cookTime;
  final int servings;
  final String difficulty;

  const RecipesPage({
    super.key,
    this.recipeTitle = 'Poulet Roti',
    this.imagePath = "https://www.apero-bordeaux.fr/wp-content/uploads/2024/02/20240216_65cfa1ce1fa54-1024x683.jpg",
    this.criteria = const ['Poulet', 'Rapide', '< 30 min'],
    this.author = 'Chef Jean',
    this.prepTime = 15,
    this.cookTime = 45,
    this.servings = 4,
    this.difficulty = 'Facile',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipeTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              imagePath,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            RecipeCriteriaBar(criteria: criteria),
            const SizedBox(height: 8),
            RecipeDetails(
              recipeName: recipeTitle,
              author: author,
              prepTime: prepTime,
              cookTime: cookTime,
              servings: servings,
              difficulty: difficulty,
            ),
          ],
        ),
      ),
    );
  }
}
