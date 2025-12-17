import 'package:flutter/material.dart';

import '../components/recipe_details.dart';

class RecipeDetailPage extends StatelessWidget {
  final String recipeTitle;
  final String imagePath;

  const RecipeDetailPage({
    super.key,
    required this.recipeTitle,
    required this.imagePath,
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(

        children: [

          SizedBox(height: 50,),
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            child: Image.network(
              imagePath,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
          ),
          RecipeDetails(
            recipeName: recipeTitle,
            author: 'Chef Martin',
            prepTime: 15,
            cookTime: 45,
            servings: 4,
            difficulty: 'Facile',
          ),
        ],
      ),
    );
  }
}
