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

  Future<void> bootstrapSession() async {
    final refreshToken = await _tokenService.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return;
    }

    final refreshExpired = await _tokenService.isRefreshTokenExpired();
    if (refreshExpired) {
      await _tokenService.clearTokens();
      return;
    }

    final accessExpired = await _tokenService.isAccessTokenExpired();
    if (accessExpired) {
      final refreshed = await refreshAccessToken();
      if (!refreshed) {
        await _tokenService.clearTokens();
      }
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      _dio.options.headers['Content-Type'] = 'application/json';
      final response = await _dio.post(
        ApiConfig.getLoginUrl(),
        data: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = _responseToMap(response.data);
        final accessToken = _extractString(data, ['accessToken']);
        final accessTokenExpiry = _extractDateTime(data, ['accessTokenExpiry']);
        final refreshToken = _extractString(data, ['refreshToken']);
        final refreshTokenExpiry = _extractDateTime(data, [
          'refreshTokenExpiry',
        ]);

        if (accessToken != null &&
            accessTokenExpiry != null &&
            refreshToken != null &&
            refreshTokenExpiry != null) {
          await _tokenService.saveTokens(
            accessToken: accessToken,
            accessTokenExpiry: accessTokenExpiry,
            refreshToken: refreshToken,
            refreshTokenExpiry: refreshTokenExpiry,
          );
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

  Future<bool> refreshAccessToken() async {
    try {
      final refreshToken = await _tokenService.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        return false;
      }

      final response = await _dio.post(
        ApiConfig.getRefreshUrl(),
        data: jsonEncode({'refreshToken': refreshToken}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = _responseToMap(response.data);
        final newAccessToken = _extractString(data, ['accessToken']);
        final accessTokenExpiry = _extractDateTime(data, ['accessTokenExpiry']);
        final newRefreshToken = _extractString(data, ['refreshToken']);
        final refreshTokenExpiry = _extractDateTime(data, [
          'refreshTokenExpiry',
        ]);

        if (newAccessToken != null && accessTokenExpiry != null) {
          await _tokenService.saveAccessToken(
            newAccessToken,
            accessTokenExpiry,
          );
          if (newRefreshToken != null &&
              newRefreshToken.isNotEmpty &&
              refreshTokenExpiry != null) {
            await _tokenService.saveRefreshToken(
              newRefreshToken,
              refreshTokenExpiry,
            );
          }
          return true;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Refresh token error: $e');
      }
    }

    return false;
  }

  Future<bool> register(String username, String email, String password) async {
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
        await login(email, password);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Signup error: $e');
      }
    }
    return false;
  }

  Future<void> logout({bool? allDevices}) async {
    try {
      final refreshToken = await _tokenService.getRefreshToken();
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await _dio.post(
          ApiConfig.getLogoutUrl(),
          data: jsonEncode({
            'refreshToken': refreshToken,
            'allDevices': allDevices == null ? allDevices : false,
          }),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Logout error: $e');
      }
    } finally {
      await _tokenService.clearTokens();
    }
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

  Map<String, dynamic> _responseToMap(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      return responseData;
    }

    if (responseData is Map) {
      return Map<String, dynamic>.from(responseData);
    }

    if (responseData is String && responseData.isNotEmpty) {
      final decoded = jsonDecode(responseData);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
    }

    return <String, dynamic>{};
  }

  String? _extractString(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value is String && value.isNotEmpty) {
        return value;
      }
    }
    return null;
  }

  DateTime? _extractDateTime(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value is String && value.isNotEmpty) {
        final parsed = DateTime.tryParse(value);
        if (parsed != null) {
          return parsed;
        }

        final millis = int.tryParse(value);
        if (millis != null) {
          return DateTime.fromMillisecondsSinceEpoch(millis);
        }
      }

      if (value is int) {
        return DateTime.fromMillisecondsSinceEpoch(value);
      }
    }
    return null;
  }

  DateTime? _extractJwtExpiry(String token) {
    try {
      final payload = parseJwt(token);
      final exp = payload['exp'];
      if (exp is int) {
        return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      }
    } catch (_) {
      // Token non-JWT ou payload invalide: on garde un token sans expiration locale.
    }
    return null;
  }
}
