import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FcmService {
  final FlutterSecureStorage _storage;
  static const _tokenKey = 'fcm_token';

  String? _cachedToken;
  FcmService(this._storage);


  Future<void> saveToken(String token) async {

    _cachedToken = token;
    await _storage.write(key: _tokenKey, value: token);
  }


  Future<String?> getToken() async {
    return _cachedToken ??= await _storage.read(key: _tokenKey);
  }


  Future<void> _deleteTokens() async {
    _cachedToken = null;
    await _storage.delete(key: _tokenKey);
  }

  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void > clearTokens() async {
    await _deleteTokens();
  }

}