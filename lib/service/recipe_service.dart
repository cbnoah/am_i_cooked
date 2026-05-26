import 'package:am_i_cooked/config/api_config.dart';
import 'package:am_i_cooked/models/ingredient_model.dart';
import 'package:am_i_cooked/models/recipe_model.dart';
import 'package:am_i_cooked/service/token_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class RecipeService {
  final Dio _dio = Dio();

  RecipeService() {
    _dio.options.connectTimeout = const Duration(
      seconds: ApiConfig.connectTimeout,
    );
  }

  Future<Options> _getOptions() async {
    final token = await TokenService.instance.getAccessToken();
    return Options(
      headers: {
        'Content-Type': 'application/json',
        'access-token': 'Bearer $token',
      },
    );
  }

  Future<RecipeModel> createFullRecipe({
    required String name,
    String? description,
    int? cookingTime,
    int? preparationTime,
    String? difficulty,
    int? xpWinnable,
    int? idPicture,
    int? idUser,
    required List<IngredientModel> ingredients,
  }) async {
    try {
      final data = {
        'name': name,
        'description': description,
        'cooking_time': cookingTime,
        'preparation_time': preparationTime,
        'difficulty': difficulty,
        'XP_winnable': xpWinnable,
        'id_picture': idPicture,
        'id_user': idUser,
        'ingredients': ingredients.map((i) => i.toJson()).toList(),
      };

      final response = await _dio.post(
        ApiConfig.createFullRecipeUrl(),
        data: data,
        options: await _getOptions(),
      );

      if (response.statusCode == 201) {
        return RecipeModel.fromJson(response.data);
      } else {
        throw Exception('Failed to create recipe: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error creating recipe: $e');
      }
      rethrow;
    }
  }

  Future<RecipeModel> updateFullRecipe({
    required int id,
    required String name,
    String? description,
    int? cookingTime,
    int? preparationTime,
    String? difficulty,
    int? xpWinnable,
    int? idPicture,
    required List<IngredientModel> ingredients,
  }) async {
    try {
      final data = {
        'name': name,
        'description': description,
        'cooking_time': cookingTime,
        'preparation_time': preparationTime,
        'difficulty': difficulty,
        'XP_winnable': xpWinnable,
        'id_picture': idPicture,
        'ingredients': ingredients.map((i) => i.toJson()).toList(),
      };

      final response = await _dio.put(
        ApiConfig.updateFullRecipeUrl(id),
        data: data,
        options: await _getOptions(),
      );

      if (response.statusCode == 200) {
        return RecipeModel.fromJson(response.data);
      } else {
        throw Exception('Failed to update recipe: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating recipe: $e');
      }
      rethrow;
    }
  }

  Future<void> deleteFullRecipe(int id) async {
    try {
      final response = await _dio.delete(
        ApiConfig.getRecipeUrl(id),
        options: await _getOptions(),
      );

      if (response.statusCode! < 200 && response.statusCode! >= 300) {
        throw Exception('Failed to delete recipe: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting recipe : $e');
      }
      rethrow;
    }
  }
}
