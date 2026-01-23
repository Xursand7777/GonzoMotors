import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  static const _accessTokenKey = 'accessToken';
  static const _refreshTokenKey = 'refreshToken';
  static const _phoneKey = 'phoneNumber';
  static final _storage = const FlutterSecureStorage();

  static Future<void> saveTokens(String accessToken, {String? refreshToken}) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    if (refreshToken != null) {
      await _storage.write(key: _refreshTokenKey, value: refreshToken);
    }
  }

  static Future<String?> getAccessToken() async =>
      await _storage.read(key: _accessTokenKey);

  static Future<String?> getRefreshToken() async =>
      await _storage.read(key: _refreshTokenKey);

  static Future<void> clear() async {
    await _storage.deleteAll();
  }

  static Future<void> savePhoneNumber(String phone) async {
    await _storage.write(key: _phoneKey, value: phone);
  }

  static Future<String?> getPhoneNumber() async {
    return await _storage.read(key: _phoneKey);
  }

  static Future<void> clearPhone() async {
    await _storage.delete(key: _phoneKey);
  }

}