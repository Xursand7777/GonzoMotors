import 'package:get_it/get_it.dart';
import '../data/data_sources/car_local_ds.dart';
import '../data/repositories/car_repository_impl.dart';
import '../domain/repositories/car_repository.dart';
import '../domain/usecases/find_details_by_specs.dart';
import '../domain/usecases/get_car_cards.dart';
import '../domain/usecases/get_specs_by_id.dart';

final sl = GetIt.instance;

Future<void> initInjection() async {
  // data source
  sl.registerLazySingleton<CarLocalDataSource>(() => CarLocalDataSourceImpl());

  // repository
  sl.registerLazySingleton<CarRepository>(() => CarRepositoryImpl(sl()));

  // usecases
  sl.registerLazySingleton(() => GetCarCards(sl()));
  sl.registerLazySingleton(() => GetSpecsById(sl()));
  sl.registerLazySingleton(() => FindDetailsBySpecs(sl()));
}