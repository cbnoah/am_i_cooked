import 'dart:convert';
import 'dart:io';
import 'package:am_i_cooked/config/api_config.dart';
import 'package:am_i_cooked/service/token_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:am_i_cooked/utils/snack_bar_handler.dart';

class HttpHelper {

  /// GET request with error handling and mounted check
  static Future<T?> safeGet<T>(String url,
      T Function(String body) parser, {
        required BuildContext context,
        required bool Function() isMounted,
      }) async {
    try {
      final token = await TokenService.instance.getAccessToken();
      final response = await http
          .get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'access-token': 'Bearer $token',
        },
      )
          .timeout(const Duration(seconds: 15));

      if (!isMounted()) return null;

      if (response.statusCode == 200) {
        return parser(response.body);
      } else {
        showErrorSnackbar('Error: ${response.statusCode}', context);
        return null;
      }
    } on SocketException catch (e) {
      if (isMounted()) {
        showErrorSnackbar('Network Error: ${e.message}', context);
      }
      debugPrint('Socket error: $e');
      return null;
    } catch (e) {
      if (isMounted()) {
        showErrorSnackbar('Error: $e', context);
      }
      debugPrint('Error: $e');
      return null;
    }
  }

  /// POST multipart (for uploads)
  static Future<T?> safeMultipartPost<T>(String url,
      List<http.MultipartFile> files,
      T Function(String body) parser, {
        required BuildContext context,
        required bool Function() isMounted,
      }) async {
    try {
      final token = await TokenService.instance.getAccessToken();
      final uri = Uri.parse(url);
      final request = http.MultipartRequest('POST', uri);
      request.headers.addAll({
        'access-token': 'Bearer $token',
      });
      request.files.addAll(files);

      final response = await request.send().timeout(
        const Duration(seconds: 30),
      );

      if (!isMounted()) return null;

      final body = await response.stream.bytesToString();

      if (response.statusCode != 201) {
        showErrorSnackbar('Upload Error: ${response.statusCode}', context);
        debugPrint('Upload error: $body');
        return null;
      }

      return parser(body);
    } on SocketException catch (e) {
      if (isMounted()) {
        showErrorSnackbar('Network Error: ${e.message}', context);
      }
      debugPrint('Socket error upload: $e');
      return null;
    } catch (e) {
      if (isMounted()) {
        showErrorSnackbar('Error: $e', context);
      }
      debugPrint('Exception upload: $e');
      return null;
    }
  }

  /// PATCH request with JSON body
  static Future<T?> safePatch<T>(String url,
      Map<String, dynamic> body,
      T Function(String body) parser, {
        required BuildContext context,
        required bool Function() isMounted,
      }) async {
    try {
      final token = await TokenService.instance.getAccessToken();
      final response = await http
          .patch(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'access-token': 'Bearer $token',
        },
        body: jsonEncode(body),
      )
          .timeout(const Duration(seconds: 15));

      if (!isMounted()) return null;

      if (response.statusCode == 200) {
        return parser(response.body);
      } else {
        showErrorSnackbar('Error: ${response.statusCode}', context);
        debugPrint('Patch error: ${response.body}');
        return null;
      }
    } on SocketException catch (e) {
      if (isMounted()) {
        showErrorSnackbar('Network Error: ${e.message}', context);
      }
      debugPrint('Socket error patch: $e');
      return null;
    } catch (e) {
      if (isMounted()) {
        showErrorSnackbar('Error: $e', context);
      }
      debugPrint('Exception patch: $e');
      return null;
    }
  }

  // ========== HIGH-LEVEL BUSINESS LOGIC ==========

  /// Load user profile picture BLOB and return as data URL
  static Future<String?> loadUserProfile(int userId, {
    required BuildContext context,
    required bool Function() isMounted,
  }) async {
    // 1. Get user data
    final userData = await safeGet<Map<String, dynamic>>(
      ApiConfig.getUserUrl(userId),
          (body) => jsonDecode(body) as Map<String, dynamic>,
      context: context,
      isMounted: isMounted,
    );

    if (!isMounted() || userData == null) return null;

    // 2. Get picture BLOB if picture_id exists
    final pictureId = userData['profile_picture_id'];
    if (pictureId != null) {
      try {
        final token = await TokenService.instance.getAccessToken();
        final response = await http
            .get(
          Uri.parse('${ApiConfig.baseUrl}/pictures/$pictureId'),
          headers: {
            'Content-Type': 'application',
            'access-token': 'Bearer $token',
          },
        )
            .timeout(const Duration(seconds: 15));

        if (!isMounted()) return null;

        if (response.statusCode == 200) {
          // Convert BLOB to base64 data URL
          final base64Image = base64Encode(response.bodyBytes);
          return 'data:image/jpeg;base64,$base64Image';
        }
      } catch (e) {
        debugPrint('Error loading picture: $e');
      }
    }

    return null;
  }

  /// Upload user profile picture as BLOB and return success status
  static Future<bool> uploadUserImage(int userId,
      String filePath, {
        required BuildContext context,
        required bool Function() isMounted,
      }) async {
    final multipartFile = await http.MultipartFile.fromPath(
      'img_blob',
      filePath,
    );

    final result = await safeMultipartPost<Map<String, dynamic>>(
      ApiConfig.getProfilePictureUrl(userId),
      [multipartFile],
          (body) => jsonDecode(body) as Map<String, dynamic>,
      context: context,
      isMounted: isMounted,
    );

    if (!isMounted() || result == null) return false;

    showSuccessSnackbar('Image uploaded with success!', context);
    return true;
  }

  /// Upload recipe picture as BLOB and return success status
  static Future<bool> uploadRecipeImage(int recipeId,
      String filePath, {
        required BuildContext context,
        required bool Function() isMounted,
      }) async {
    final multipartFile = await http.MultipartFile.fromPath(
      'img_blob',
      filePath,
    );

    final result = await safeMultipartPost<Map<String, dynamic>>(
      ApiConfig.getRecipePictureUrl(recipeId),
      [multipartFile],
          (body) => jsonDecode(body) as Map<String, dynamic>,
      context: context,
      isMounted: isMounted,
    );

    if (!isMounted() || result == null) return false;

    showSuccessSnackbar('Recipe image uploaded with success!', context);
    return true;
  }

  /// Save user profile (username, email)
  static Future<bool> saveUserProfile(int userId,
      String username, {
        required BuildContext context,
        required bool Function() isMounted,
      }) async {
    final result = await safePatch<Map<String, dynamic>>(
      ApiConfig.getUserUrl(userId),
      {'username': username},
          (body) => jsonDecode(body) as Map<String, dynamic>,
      context: context,
      isMounted: isMounted,
    );

    if (!isMounted()) return false;

    if (result != null) {
      showSuccessSnackbar('Profil mis à jour avec succès!', context);
      return true;
    }

    return false;
  }
}