import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:gonzo_motors/core/network/dio_client.dart';
import 'package:gonzo_motors/features/verification/data/repository/verification_repository.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/ads_banner/data/repository/ads_banner_repository.dart';
import '../../features/car_catalog/data/repository/car_repository.dart';
import '../../features/user_location/data/repository/user_location_repository.dart';
import '../services/deeplink_service.dart';
import '../services/notification_service.dart';
import '../services/token_service.dart';

final sl = GetIt.instance;

Future<void> initInjection() async {
  final dio = DioClient();
  final deeplinkService = DeeplinkService();
  final notificationService = NotificationService();
  final sharedPreferences = await SharedPreferences.getInstance();
  final InternetConnectionChecker connectionChecker =
  InternetConnectionChecker.createInstance(
      addresses: [AddressCheckOption(uri: Uri.parse('https://www.google.com'))]);
  final Connectivity connectivity = Connectivity();
  const FlutterSecureStorage secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      resetOnError: true,
    ),
  );
  final TokenService tokenService = TokenService(secureStorage)..initialize();
  // core
  sl.registerSingleton(connectivity);
  sl.registerSingleton(connectionChecker);
  sl.registerSingleton(dio.dio);
  sl.registerSingleton<SharedPreferences>(sharedPreferences);
  sl.registerSingleton(deeplinkService);
  sl.registerSingleton(notificationService);

  // data source


  // repository
  sl.registerLazySingleton<CarRepository>(() => CarRepositoryImpl(sl.get(), sl.get()));
  sl.registerLazySingleton<UserLocationRepository>(() => UserLocationRepositoryImpl(sl.get(), sl.get()));
  sl.registerLazySingleton<AdsBannerRepository>(() => AdsBannerRepositoryImpl(sl.get(), sl.get()));
  sl.registerLazySingleton<VerificationRepository>(() => VerificationRepositoryImpl(sl.get()));

}