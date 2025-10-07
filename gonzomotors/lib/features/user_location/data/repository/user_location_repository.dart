import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/base_repository.dart';

abstract class UserLocationRepository extends BaseRepository {
  UserLocationRepository(super.dio);

  Future<void> saveUserPermissionDate(DateTime dateTime);

  Future<DateTime?> getUserPermissionDate();

  Future<void> saveUserLocation(Position position);

  Future<Position> getUserLocation();
}

class UserLocationRepositoryImpl extends UserLocationRepository {
  final SharedPreferences sharedPreferences;

  UserLocationRepositoryImpl(super.dio, this.sharedPreferences);

  final String _userPermissionDateKey = 'user_permission_date';
  final String _userLocationKey = 'user_location';

  @override
  Future<Position> getUserLocation() async {
    final locationString = sharedPreferences.getString(_userLocationKey);
    if (locationString == null) {
      throw Exception('User location not found');
    }
    try {
      final positionMap = jsonDecode(locationString) as Map<String, dynamic>;
      return Position.fromMap(positionMap);
    } catch (e) {
      // Handle parsing error
      throw Exception('Error parsing user location: $e');
    }
  }

  @override
  Future<DateTime?> getUserPermissionDate() async {
    final dateString = sharedPreferences.getString(_userPermissionDateKey);
    if (dateString == null) {
      return null;
    }
    try {
      final dateTime =
      DateTime.fromMicrosecondsSinceEpoch(int.parse(dateString));
      return dateTime;
    } catch (e) {
      // Handle parsing error
      return null;
    }
  }

  @override
  Future<void> saveUserLocation(Position position) async {
    sharedPreferences.setString(
        _userLocationKey, jsonEncode(position.toJson()));
  }

  @override
  Future<void> saveUserPermissionDate(DateTime dateTime) async {
    final dateString = dateTime.microsecondsSinceEpoch;
    await sharedPreferences.setString('user_permission_date', dateString.toString());
    return;
  }
}