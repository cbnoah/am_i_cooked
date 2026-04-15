import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  static final TokenService _instance = TokenService._internal();
  late FlutterSecureStorage _storage;
  String? _accessToken;
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _accessExpiresAtKey = 'access_expires_at';
  static const String _refreshExpiresAtKey = 'refresh_expires_at';

  TokenService._internal() {
    _storage = const FlutterSecureStorage();
  }

  static TokenService get instance {
    return _instance;
  }

  Stream<String?> get accessTokenStream async* {
    while (true) {
      yield await getAccessToken();
      await Future.delayed(const Duration(seconds: 2));
      print("looped");
    }
  }

  String? get accessToken => _accessToken;

  Future<void> saveAccessToken(String token, [DateTime? date]) async {
    _accessToken = token;
    await _storage.write(key: _accessTokenKey, value: token);
    if (date != null) {
      await _storage.write(
        key: _accessExpiresAtKey,
        value: date.millisecondsSinceEpoch.toString(),
      );
    }
  }

  Future<void> saveRefreshToken(String token, [DateTime? date]) async {
    await _storage.write(key: _refreshTokenKey, value: token);
    if (date != null) {
      await _storage.write(
        key: _refreshExpiresAtKey,
        value: date.millisecondsSinceEpoch.toString(),
      );
    }
  }

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required DateTime refreshTokenExpiry,
    required DateTime accessTokenExpiry,
  }) async {
    await saveAccessToken(accessToken, accessTokenExpiry);
    await saveRefreshToken(refreshToken, refreshTokenExpiry);
  }

  Future<String?> getAccessToken() async {
    try {
      _accessToken ??= await _storage.read(key: _accessTokenKey);
      print("access token $_accessToken");
      return _accessToken;
    } catch (e) {
      return null;
    }
  }

  Future<DateTime?> getAccessTokenExpiry() async {
    try {
      final expiryString = await _storage.read(key: _accessExpiresAtKey);
      if (expiryString != null) {
        return DateTime.fromMillisecondsSinceEpoch(int.parse(expiryString));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: _refreshTokenKey);
    } catch (e) {
      return null;
    }
  }

  Future<DateTime?> getRefreshTokenExpiry() async {
    try {
      final expiryString = await _storage.read(key: _refreshExpiresAtKey);
      if (expiryString != null) {
        return DateTime.fromMillisecondsSinceEpoch(int.parse(expiryString));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> isAccessTokenExpired({
    Duration tolerance = const Duration(seconds: 30),
  }) async {
    final expiry = await getAccessTokenExpiry();
    if (expiry == null) return true;
    return DateTime.now().isAfter(expiry.subtract(tolerance));
  }

  Future<bool> isRefreshTokenExpired({
    Duration tolerance = const Duration(seconds: 30),
  }) async {
    final expiry = await getRefreshTokenExpiry();
    if (expiry == null) return true;
    return DateTime.now().isAfter(expiry.subtract(tolerance));
  }

  Future<void> clearTokens() async {
    _accessToken = null;
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _accessExpiresAtKey);
    await _storage.delete(key: _refreshExpiresAtKey);
  }
}
