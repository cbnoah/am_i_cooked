import 'dart:convert';

import 'package:am_i_cooked/config/api_config.dart';
import 'package:am_i_cooked/models/recipe_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../service/token_service.dart';

final recipesProvider =
    AsyncNotifierProvider<RecipesNotifier, List<RecipeModel>>(
      RecipesNotifier.new,
    );

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

  final Dio _dio = Dio();

  Future<List<RecipeModel>> _fetchRecipes() async {
    _dio.options.headers['Content-Type'] = 'application/json';
    _dio.options.headers['access-token'] =
        'Bearer ${await TokenService.instance.getAccessToken()}';

    try {
      final response = await _dio.get(ApiConfig.getAllRecipesUrl());
      if (response.statusCode != 200) {
        throw Exception('Failed to load recipes data');
      }

      if (response.data is! List<dynamic>) {
        throw Exception('Invalid recipes payload');
      }

      final recipes = <RecipeModel>[];

      for (final item in response.data) {
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
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching recipes: $e');
      }
      throw Exception('Failed to load recipes data');
    }
  }
}
