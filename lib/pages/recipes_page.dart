import 'package:flutter/material.dart';
import '../components/criteria_bar.dart';
import '../components/recipe_details.dart';

class RecipesPage extends StatelessWidget {
  const RecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de la recette'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              "https://www.apero-bordeaux.fr/wp-content/uploads/2024/02/20240216_65cfa1ce1fa54-1024x683.jpg",
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),

            const RecipeCriteriaBar(
              criteria: ['Végétarien', 'Rapide', '< 30 min', 'Sans gluten'],
            ),

            const SizedBox(height: 8),

            const RecipeDetails(
              recipeName: 'Poulet Roti',
              author: 'Chef Jean',
              prepTime: 15,
              cookTime: 45,
              servings: 4,
              difficulty: 'Facile',
            ),
          ],
        ),
      ),
    );
  }
}
