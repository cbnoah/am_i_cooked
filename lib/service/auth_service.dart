import 'dart:convert';

import 'package:am_i_cooked/config/api_config.dart';
import 'package:am_i_cooked/models/user_model.dart';
import 'package:am_i_cooked/service/token_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final Dio _dio;
  final TokenService _tokenService = TokenService.instance;

  AuthService(this._dio);

  Future<bool> login(String email, String password) async {
    try {
      _dio.options.headers['Content-Type'] = 'application/json';
      final response = await _dio.post(
        ApiConfig.getLoginUrl(),
        data: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final result = response.data; // Ensure this matches your API response
        final UserModel user = UserModel.fromJson(result);
        if (user.token != null) {
          await _tokenService.saveToken(user.token!);
          return true;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Login error: $e');
      }
    }
    return false;
  }

  Future<bool> register(
    String username,
    String email,
    String number,
    String password,
    String confirmPassword,
  ) async {
    try {
      final response = await _dio.post(
        ApiConfig.getRegisterUrl(),
        data: jsonEncode({
          'username': username,
          'password': password,
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        final result = response.data; // Ensure this matches your API response
        final UserModel user = UserModel.fromJson(result);
        if (user.token != null) {
          await _tokenService.saveToken(user.token!);
          return true;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Signup error: $e');
      }
    }
    return false;
  }

  Future<void> logout() async {
    await _tokenService.deleteToken();
  }

  Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid token');
    }
    final payload = utf8.decode(
      base64Url.decode(base64Url.normalize(parts[1])),
    );
    return json.decode(payload);
  }
}
