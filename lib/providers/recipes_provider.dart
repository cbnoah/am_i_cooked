import 'dart:convert';

import 'package:am_i_cooked/config/api_config.dart';
import 'package:am_i_cooked/models/recipe_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final recipesProvider =
    AsyncNotifierProvider<RecipesNotifier, List<RecipeModel>>(RecipesNotifier.new);

final recipeByIdProvider = Provider.family<RecipeModel?, int>((ref, recipeId) {
  final recipesAsync = ref.watch(recipesProvider);

  return recipesAsync.maybeWhen(
    data: (recipes) {
      for (final recipe in recipes) {
        if (recipe.id == recipeId) {
          return recipe;
        }
      }
      return null;
    },
    orElse: () => null,
  );
});

class RecipesNotifier extends AsyncNotifier<List<RecipeModel>> {
  @override
  Future<List<RecipeModel>> build() async {
    return _fetchRecipes();
  }

  Future<List<RecipeModel>> _fetchRecipes() async {
    final response = await http.get(Uri.parse(ApiConfig.getAllRecipesUrl()));

    if (response.statusCode != 200) {
      throw Exception('Failed to load recipes data');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List<dynamic>) {
      throw Exception('Invalid recipes payload');
    }

    final recipes = <RecipeModel>[];

    for (final item in decoded) {
      if (item is! Map<String, dynamic>) continue;
      try {
        recipes.add(RecipeModel.fromJson(item));
      } on FormatException {
        if (kDebugMode) {
          print('Error when receiving Recipe data');
        }
      }
    }

    return recipes;
  }
}
