import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseTokenService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  static String? _cachedToken;

  /// FCM token ni olish va saqlash
  static Future<String?> getFCMToken() async {
    try {
      if (_cachedToken != null) {
        return _cachedToken;
      }

      String? token;

      if (Platform.isIOS) {
        // iOS uchun APNS token olish
        String? apnsToken = await _messaging.getAPNSToken();
        if (apnsToken != null) {
          // FCM token olish
          token = await _messaging.getToken();
        } else {
          // Callback orqali token olish
          _messaging.onTokenRefresh.listen((newToken) {
            _cachedToken = newToken;
            setAnalyticsUserId(newToken);
          });
          token = await _messaging.getToken();
        }
      } else {
        // Android uchun
        token = await _messaging.getToken();
      }

      if (token != null) {
        _cachedToken = token;
        await setAnalyticsUserId(token);
      }

      return token;
    } catch (e) {
      print('FCM token olishda xatolik: $e');
      return null;
    }
  }

  /// FCM token ni Firebase Analytics ga user ID sifatida o'rnatish
  static Future<void> setAnalyticsUserId(String token) async {
    try {
      await _analytics.setUserId(id: token);
    } catch (e) {
      print('Analytics user ID o\'rnatishda xatolik: $e');
    }
  }

  /// Token yangilanishini kuzatish
  static void setupTokenRefreshListener() {
    _messaging.onTokenRefresh.listen((newToken) {
      _cachedToken = newToken;
      setAnalyticsUserId(newToken);
      print('FCM token yangilandi: ${newToken.substring(0, 20)}...');
    });
  }

  /// Cached token ni olish
  static String? getCachedToken() {
    return _cachedToken;
  }

  /// Token mavjudligini tekshirish
  static bool hasToken() {
    return _cachedToken != null && _cachedToken!.isNotEmpty;
  }
}