import '../../data/models/car_details.dart';
import '../../data/models/car_info.dart';
import '../../data/models/car_specs.dart';

abstract class CarRepository {
  Future<List<CarInfo>> getCarCards();
  Future<CarSpecs> getSpecsById(String id);

  /// Найти полные детали по спецификации (имя в формате 'Name (YYYY)')
  Future<CarDetails?> findDetailsBySpecs(CarSpecs s);
}