import 'package:shared_preferences/shared_preferences.dart';

final class OnboardingService {
  final SharedPreferences _sharedPreferences;
  static const _onboardingKey = 'onboarding_completed';
  OnboardingService(this._sharedPreferences);

  ///TODO: Refactor initialization logic if needed
  Future<void> initialize(String? token) async {
    if(token == null || token.isEmpty) {
      await setOnboardingCompleted(false);
    }else{
      await setOnboardingCompleted(true);
    }
  }

  Future<void> setOnboardingCompleted(bool completed) async {
    await _sharedPreferences.setBool(_onboardingKey, completed);
  }

  bool isOnboardingCompleted() {
    return _sharedPreferences.getBool(_onboardingKey) ?? false;
  }
}