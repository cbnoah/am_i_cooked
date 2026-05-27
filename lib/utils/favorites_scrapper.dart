import 'package:dio/dio.dart';

import '../config/api_config.dart';
import '../service/token_service.dart';

class FavoriteScreapper {

  Future<List<dynamic>> fetchUserFavorites(int userId) async {
    final dio = Dio();
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['access-token'] =
        'Bearer ${await TokenService.instance.getAccessToken()}';

    print('Fetching favorites for user $userId from API...');

    final response = await dio
        .get(ApiConfig.getUserFavoritesUrl(userId))
        .timeout(const Duration(seconds: 10));

    print('Favorites API Response Status: ${response.statusCode}');
    print('Favorites API Response Data: ${response.data}');

    if (response.statusCode != 200) {
      throw Exception('Failed to load user favorites data');
    }

    if (response.data is! List<dynamic>) {
      throw Exception('Invalid user favorites payload');
    }

    return response.data;
  }

  Future<bool> fetchIfIsFavorite(int userId, int recipeId) async {
    final dio = Dio();
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['access-token'] =
        'Bearer ${await TokenService.instance.getAccessToken()}';

    print('Checking if recipe $recipeId is favorite for user $userId...');

    final response = await dio
        .get(ApiConfig.getSpecificFavoriteUrl(userId, recipeId))
        .timeout(const Duration(seconds: 10));

    print('Favorite check response: ${response.statusCode}, data: ${response.data}');

    if (response.statusCode != 200) {
      throw Exception('Failed to load favorite status');
    }

    if (response.data is! Map<String, dynamic>) {
      throw Exception('Invalid favorite status payload');
    }

    return response.data['result'] ?? false;
  }

  Future<bool> toggleFavorite(int userId, int recipeId) async {
    final dio = Dio();
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['access-token'] =
        'Bearer ${await TokenService.instance.getAccessToken()}';

    print('Toggling favorite status for user $userId, recipe $recipeId');

    Response<dynamic> response;
    bool result = false;

    final isFavorite = await fetchIfIsFavorite(userId, recipeId);
    print('Current favorite status: $isFavorite');

    if (isFavorite) {
      print('Deleting favorite...');
      response = await dio
          .delete(
            ApiConfig.getSpecificFavoriteUrl(userId, recipeId),
          )
          .timeout(const Duration(seconds: 10));
      result = false;
    } else {
      print('Adding favorite...');
      response = await dio
          .post(
            ApiConfig.getFavoritesUrl(),
            data: {'id_user': userId, 'id_recipe': recipeId},
          )
          .timeout(const Duration(seconds: 10));
      result = true;
    }

    print('Toggle response: ${response.statusCode}, data: ${response.data}');

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to toggle favorite status (${response.statusCode})');
    }

    if (response.data is! Map<String, dynamic>) {
      throw Exception('Invalid toggle favorite response payload');
    }

    print('Toggle completed, result=$result');
    return result;
  }
}
