import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:gonzo_motors/core/network/dio_client.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/data_sources/car_local_ds.dart';
import '../../data/repositories/car_repository_impl.dart';
import '../../domain/repositories/car_repository.dart';
import '../../domain/usecases/find_details_by_specs.dart';
import '../../domain/usecases/get_car_cards.dart';
import '../../domain/usecases/get_specs_by_id.dart';

final sl = GetIt.instance;

Future<void> initInjection() async {
  final dio = DioClient();
  final sharedPreferences = await SharedPreferences.getInstance();
  final InternetConnectionChecker connectionChecker =
  InternetConnectionChecker.createInstance(
      addresses: [AddressCheckOption(uri: Uri.parse('https://www.google.com'))]);
  final Connectivity connectivity = Connectivity();
  // core
  sl.registerSingleton(connectivity);
  sl.registerSingleton(connectionChecker);
  sl.registerSingleton(dio.dio);
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  // data source
  sl.registerLazySingleton<CarLocalDataSource>(() => CarLocalDataSourceImpl());

  // repository
  sl.registerLazySingleton<CarRepository>(() => CarRepositoryImpl(sl()));

  // usecases
  sl.registerLazySingleton(() => GetCarCards(sl()));
  sl.registerLazySingleton(() => GetSpecsById(sl()));
  sl.registerLazySingleton(() => FindDetailsBySpecs(sl()));
}