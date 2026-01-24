import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../features/profile/data/models/user_model.dart';

class UserService {
  final FlutterSecureStorage _storage;
  static const String userModel = 'user_model';


  UserService(this._storage);

  UserModel? _cachedUser;

  Future<UserModel?> getUser() async {
    if (_cachedUser != null) {
      return _cachedUser;
    }
    String? userJson = await _storage.read(key: userModel);
    if (userJson != null) {
      Map<String,dynamic> user = jsonDecode( userJson);
      _cachedUser = UserModel.fromJson(user);
      return _cachedUser;
    }
    return null;
  }

  Future<void> saveUser(UserModel user) async {
    _cachedUser = user;
    String userJson = jsonEncode(user.toJson());
    await _storage.write(key: userModel, value: userJson);
  }

  Future<void> clearUser() async {
    _cachedUser = null;
    await _storage.delete(key: userModel);
  }

}