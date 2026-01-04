import 'package:shared_preferences/shared_preferences.dart';

class DeviceInfoService {
  final SharedPreferences _sharedPreferences;

  const DeviceInfoService(this._sharedPreferences);

  final String _deviceId = 'device_id';
  final String _model = 'model';
  final String _name = 'name';

  Future<void> saveDeviceInfo({required String deviceId,
    required String model,
    required String name}) async {
    await _sharedPreferences.setString(_deviceId, deviceId);
    await _sharedPreferences.setString(_model, model);
    await _sharedPreferences.setString(_name, name);
  }

  String? getDeviceId() {
    return _sharedPreferences.getString(_deviceId);
  }

  String? getModel() {
    return _sharedPreferences.getString(_model);
  }

  String? getName() {
    return _sharedPreferences.getString(_name);
  }

}