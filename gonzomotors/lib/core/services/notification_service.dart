



import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../log/talker_logger.dart';

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  logger.debug('Background message: ${message.notification?.title}');
  //await NotificationService()._saveLastNotification(message.data);
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  Function(int)? onTapCar;
  Function(Map<String, dynamic>)? onTapData;

  Future<void> initialize() async {
    try {
      logger.debug("NotificationService initializing...");

      await _initLocalNotifications();

      await _requestPermissions();

      FirebaseMessaging.onMessage.listen(
            (RemoteMessage message) async {
          logger.debug('Foreground notification received: ${message.notification?.title}');

          await _showLocalNotification(message);
        },
        onError: (err) {
          logger.debug('Foreground notification error: $err');
        },
      );

      FirebaseMessaging.onMessageOpenedApp.listen(
            (RemoteMessage message) async {
          logger.debug('Notification tapped: ${message.notification?.title}');
          await _handleNotificationTap(message);
        },
        onError: (err) {
          logger.debug('Notification tap error: $err');
        },
      );

      FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

      logger.debug("NotificationService initialized successfully");
    } catch (e) {
      logger.debug('NotificationService initialization error: $e');
    }
  }

  Future<void> _initLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        logger.debug('Local notification tapped: ${response.payload}');
        if (response.payload != null) {
          _handleLocalNotificationPayload(response.payload!);
        }
      },
    );

    const androidChannel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.high,
      icon: '@mipmap/ic_launcher',

      priority: Priority.high,
      showWhen: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Create payload with action and id
    String payload = _createPayload(message.data);

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? 'Yangi xabar',
      message.notification?.body ?? 'Sizda yangi xabar bor',
      notificationDetails,
      payload: payload,
    );

  }

  String _createPayload(Map<String, dynamic> data) {
    final String? action = data['action'] ?? data['car'] ?? data['type'];
    final String? id = data['id'] ?? data['car_id'] ?? data['car_id'];

    return 'action:$action,id:$id';
  }

  /// Handle local notification payload
  void _handleLocalNotificationPayload(String payload) {
    try {
      logger.debug('Handling local notification payload: $payload');


      final parts = payload.split(',');
      String? action;
      String? id;

      for (String part in parts) {
        if (part.startsWith('action:')) {
          action = part.split(':')[1];
        } else if (part.startsWith('id:')) {
          id = part.split(':')[1];
        }
      }

      // Handle based on action
      if (action == 'car' && id != null && onTapCar != null) {
        onTapCar!(int.tryParse(id) ?? 0);
      } else if (onTapData != null) {
        onTapData!({
          'action': action ?? 'unknown',
          'id': id,
          'payload': payload,
        });
      }
    } catch (e) {
      logger.debug('Error handling local notification payload: $e');
    }
  }

  Future<void> initNotificationListener() async {
    try {
      // Check if app was launched from notification
      final initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        _handleNotificationTap(initialMessage);
      }
    } catch (e) {
      logger.debug('Error handling initial notification: $e');
    }
  }

  Future<void> _handleNotificationTap(RemoteMessage message) async {
    try {
      // await _saveLastNotification(message.data);
      logger.debug('Received notification tap: ${message.data}');
      await _handleNotificationData(message.data);
    } catch (e) {
      logger.debug('Error handling notification tap: $e');
    }
  }

  Future<void> _handleNotificationData(Map<String, dynamic> data) async {
    final String? action = data['discount'] ?? data['action'] ?? data['type'];
    final String? id = data['id'] ?? data['product_id'] ?? data['discount_id'];

    switch (action) {
      case 'discount':
        if (id != null && onTapCar != null) {
          onTapCar!(int.tryParse(id) ?? 0);
        }
        break;
      case 'action':
        if (onTapData != null) {
          onTapData!({
            'action': action,
            'data': data,
          });
        }
        break;
      default:
        if (onTapData != null) {
          onTapData!({
            'action': action ?? 'unknown',
            'data': data,
          });
        }
    }
  }

  Future<void> _requestPermissions() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      carPlay: false,
      criticalAlert: false,
      announcement: false,
    );

    logger.debug('Notification permission: ${settings.authorizationStatus}');
  }


  Future<String?> getLastNotification() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('last_notification');
  }
}