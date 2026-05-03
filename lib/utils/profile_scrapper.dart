import 'dart:typed_data';
import 'package:am_i_cooked/models/picture_model.dart';
import 'package:am_i_cooked/models/user_model.dart';
import 'package:dio/dio.dart';

import '../config/api_config.dart';
import '../service/token_service.dart';

class ProfileScrapper {
  final Dio _dio = Dio();

  Future<UserModel> fetchUserProfile(int id) async {
    _dio.options.headers['Content-Type'] = 'application/json';
    _dio.options.headers['access-token'] =
        'Bearer ${await TokenService.instance.getAccessToken()}';
    final response = await _dio
        .get(ApiConfig.getUserUrl(id))
        .timeout(const Duration(seconds: 10));
    return UserModel.fromJson(response.data);
  }

  Future<PictureModel> fetchProfilePicture(int id) async {
    _dio.options.headers['access-token'] =
        'Bearer ${await TokenService.instance.getAccessToken()}';
    final response = await _dio
        .get(
          ApiConfig.getProfilePictureUrl(id),
          options: Options(responseType: ResponseType.bytes),
        )
        .timeout(const Duration(seconds: 15));

    if (response.data is List<int>) {
      return PictureModel(
        imgBlob: response.data is! Uint8List
            ? Uint8List.fromList(response.data as List<int>)
            : response.data as Uint8List,
      );
    }

    return PictureModel.fromJson(response.data);
  }

  Future<UserModel> fetchAllUserData(int id) async {
    final user = await fetchUserProfile(id);

    try {
      user.profilePicture = await fetchProfilePicture(id);
    } catch (_) {
      user.profilePicture = null;
    }

    return user;
  }

  Future<bool> modifyUserProfile(int id, String username, String email) async {
    Dio dio = Dio();
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['access-token'] =
        'Bearer ${await TokenService.instance.getAccessToken()}';
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
}
