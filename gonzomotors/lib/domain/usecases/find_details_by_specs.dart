import '../repositories/car_repository.dart';
import '../../data/models/car_details.dart';
import '../../data/models/car_specs.dart';

class FindDetailsBySpecs {
  final CarRepository repo;
  FindDetailsBySpecs(this.repo);

  Future<CarDetails?> call(CarSpecs specs) => repo.findDetailsBySpecs(specs);
}