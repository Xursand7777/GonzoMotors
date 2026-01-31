import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:gonzo_motors/core/network/dio_client.dart';
import 'package:gonzo_motors/core/services/user_service.dart';
import 'package:gonzo_motors/features/auth/data/repository/auth_repository.dart';
import 'package:gonzo_motors/features/car_detail/data/repository/car_detail_repository.dart';
import 'package:gonzo_motors/features/profile/data/repository/profile_repository.dart';
import 'package:gonzo_motors/features/verification/data/repository/verification_repository.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_auth/smart_auth.dart';
import '../../features/ads_banner/data/repository/ads_banner_repository.dart';
import '../../features/car_catalog/data/repository/car_repository.dart';
import '../../features/user_location/data/repository/user_location_repository.dart';
import '../local/onboarding_service.dart';
import '../services/deeplink_service.dart';
import '../services/device_info_service.dart';
import '../services/fcm_service.dart';
import '../services/notification_service.dart';
import '../services/token_service.dart';

final sl = GetIt.instance;

Future<void> initInjection() async {
  const FlutterSecureStorage secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      resetOnError: true,
    ),
  );
  final TokenService tokenService = TokenService(secureStorage)..initialize();

  final deeplinkService = DeeplinkService();
  final notificationService = NotificationService();
  final sharedPreferences = await SharedPreferences.getInstance();
  final deviceInfoService = DeviceInfoService(sharedPreferences);
  final userService = UserService(secureStorage);
  final FcmService fcmService = FcmService(secureStorage);
  final dioClient = DioClient(
    tokenService: tokenService,
    fcmService: fcmService,
    deviceInfoService: deviceInfoService,
  );
  final InternetConnectionChecker connectionChecker =
  InternetConnectionChecker.createInstance(
      addresses: [AddressCheckOption(uri: Uri.parse('https://www.google.com'))]);
  final Connectivity connectivity = Connectivity();
  final smsAuth = SmartAuth.instance;

  try {
    String? token;
    if (Platform.isIOS) {
      String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      if (apnsToken != null) {
        token = await FirebaseMessaging.instance.getToken();
      } else {
        FirebaseMessaging.instance.onTokenRefresh.listen((token) {});
      }
    } else {
      token = await FirebaseMessaging.instance.getToken();
    }
    if (token != null && token.isNotEmpty) {
      await fcmService.saveToken(token);
    }
    token = null;
  } catch (_) {}


  // core
  sl.registerSingleton(connectivity);
  sl.registerSingleton(connectionChecker);
  sl.registerSingleton(dioClient.dio);
  sl.registerSingleton<SharedPreferences>(sharedPreferences);
  sl.registerSingleton(deeplinkService);
  sl.registerSingleton<TokenService>(tokenService);
  sl.registerSingleton<DeviceInfoService>(deviceInfoService);
  sl.registerSingleton<UserService>(userService);
  sl.registerSingleton(notificationService);
  sl.registerLazySingleton(() => OnboardingService(sl.get()));
  sl.registerSingleton(fcmService);
  sl.registerSingleton(smsAuth);




  // data source


  // repository
  sl.registerLazySingleton<CarRepository>(() => CarRepositoryImpl(sl.get(), sl.get()));
  sl.registerLazySingleton<UserLocationRepository>(() => UserLocationRepositoryImpl(sl.get(), sl.get()));
  sl.registerLazySingleton<AdsBannerRepository>(() => AdsBannerRepositoryImpl(sl.get(), sl.get()));
  sl.registerLazySingleton<VerificationRepository>(() => VerificationRepositoryImpl(sl.get()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl.get()));
  sl.registerLazySingleton<CarDetailRepository>(() => CarDetailRepositoryImpl(sl.get()));
  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(sl.get()));
}