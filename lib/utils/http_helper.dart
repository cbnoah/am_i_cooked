import 'dart:convert';
import 'dart:io';
import 'package:am_i_cooked/config/api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:am_i_cooked/utils/snack_bar_handler.dart';

class HttpHelper {

  /// GET request with error handling and mounted check
  static Future<T?> safeGet<T>(
    String url,
    T Function(String body) parser, {
    required BuildContext context,
    required bool Function() isMounted,
  }) async {
    try {
      final response = await http
          .get(Uri.parse(url))
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
  static Future<T?> safeMultipartPost<T>(
    String url,
    List<http.MultipartFile> files,
    T Function(String body) parser, {
    required BuildContext context,
    required bool Function() isMounted,
  }) async {
    try {
      final uri = Uri.parse(url);
      final request = http.MultipartRequest('POST', uri);
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
  static Future<T?> safePatch<T>(
    String url,
    Map<String, dynamic> body,
    T Function(String body) parser, {
    required BuildContext context,
    required bool Function() isMounted,
  }) async {
    try {
      final response = await http
          .patch(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
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

  /// Load user profile picture URL
  static Future<String?> loadUserProfile(
    int userId, {
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

    // 2. Get picture URL if picture_id exists
    final pictureId = userData['profile_picture_id'];
    if (pictureId != null) {
      final pictureData = await safeGet<Map<String, dynamic>>(
        '${ApiConfig.baseUrl}/pictures/$pictureId',
        (body) => jsonDecode(body) as Map<String, dynamic>,
        context: context,
        isMounted: isMounted,
      );

      if (!isMounted() || pictureData == null) return null;
      return pictureData['url'] as String?;
    }

    return null;
  }

  /// Upload user profile picture and return image URL
  static Future<String?> uploadUserImage(
    int userId,
    String filePath, {
    required BuildContext context,
    required bool Function() isMounted,
  }) async {
    final multipartFile = await http.MultipartFile.fromPath(
      'avatar',
      filePath,
    );

    final result = await safeMultipartPost<Map<String, dynamic>>(
      ApiConfig.getUploadUrl(userId),
      [multipartFile],
      (body) => jsonDecode(body) as Map<String, dynamic>,
      context: context,
      isMounted: isMounted,
    );

    if (!isMounted() || result == null) return null;
    showSuccessSnackbar('Image uploaded with success!', context);
    return result['url'] as String?;
  }

  /// Save user profile (username, email)
  static Future<bool> saveUserProfile(
    int userId,
    String username,
    String email, {
    required BuildContext context,
    required bool Function() isMounted,
  }) async {
    final result = await safePatch<Map<String, dynamic>>(
      ApiConfig.getUserUrl(userId),
      {
        'username': username,
        'email': email,
      },
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