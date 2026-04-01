import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  static final TokenService _instance = TokenService._internal();
  late FlutterSecureStorage _storage;
  String? _accessToken;

  TokenService._internal() {
    _storage = const FlutterSecureStorage();
  }

  static TokenService get instance {
    return _instance;
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt', value: token);
  }

  Future<String?> getToken() async {
    try {
      return await _storage.read(key: 'jwt');
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'jwt');
  }

  String? get accessToken => _accessToken;
}
