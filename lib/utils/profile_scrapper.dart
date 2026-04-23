import 'package:am_i_cooked/models/user_model.dart';
import 'package:dio/dio.dart';

import '../config/api_config.dart';
import '../service/token_service.dart';

Future<UserModel> fetchUserProfile(int id) async {
  Dio dio = Dio();
  final response = await dio.get(ApiConfig.getUserUrl(id));
  return UserModel.fromJson(response.data);
}

Future<bool> modifyUserProfile(int id, String username, String email) async {
  Dio dio = Dio();
  dio.options.headers['Content-Type'] = 'application/json';
  dio.options.headers['access-token'] = 'Bearer ${await TokenService.instance.getAccessToken()}';
  try {
    final response = await dio.patch(
      ApiConfig.getUserUrl(id),
      data: {'username': username, 'email': email},
    );
    return response.statusCode == 200 || response.statusCode == 204;
  } catch (e) {
    print('Error modifying user profile: $e');
    return false;
  }
}