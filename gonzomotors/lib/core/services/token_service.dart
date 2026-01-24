import 'dart:developer';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  final FlutterSecureStorage _storage;
  static const _tokenKey = 'auth_token';
  static const _refreshTokenKey = 'refresh_token';

  String? _cachedToken;
  String? _cachedRefreshToken;

  TokenService(this._storage);

  Future<void> initialize() async {
    try {
      _cachedToken = await _storage.read(key: _tokenKey);
      _cachedRefreshToken = await _storage.read(key: _refreshTokenKey);
    } catch (e) {
      // Log error
      log('Token initialization failed: $e');
    }
  }

  bool isExpired(String token) {
    return JwtDecoder.isExpired(token);
  }

  DateTime getExpirationDate(String token) {
    return JwtDecoder.getExpirationDate(token);
  }

  Future<void> saveToken(String token) async {
    if (token.isEmpty) {
      throw ArgumentError('Token cannot be empty');
    }
    _cachedToken = token;
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    if (refreshToken.isEmpty) {
      throw ArgumentError('Refresh token cannot be empty');
    }
    _cachedRefreshToken = refreshToken;
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<String?> getToken() async {
    return _cachedToken ??= await _storage.read(key: _tokenKey);
  }

  Future<String?> getRefreshToken() async {
    return _cachedRefreshToken ??= await _storage.read(key: _refreshTokenKey);
  }

  Future<String?> refreshToken() async {
    _cachedToken = await _storage.read(key: _tokenKey);
    return _cachedToken;
  }

  Future<String?> refreshRefreshToken() async {
    _cachedRefreshToken = await _storage.read(key: _refreshTokenKey);
    return _cachedRefreshToken;
  }

  Future<void> clearTokens() async {
    _cachedToken = null;
    _cachedRefreshToken = null;
    await Future.wait([
      _storage.delete(key: _tokenKey),
      _storage.delete(key: _refreshTokenKey),
    ]); // Parallel deletion - tezroq!
  }

  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  bool hasTokenCached() {
    return _cachedToken != null && _cachedToken!.isNotEmpty;
  }

  Future<void> updateTokens({
    required String token,
    required String refreshToken,
  }) async {
    await Future.wait([
      saveToken(token),
      saveRefreshToken(refreshToken),
    ]);
  }
}