import '../repositories/car_repository.dart';
import '../../data/models/car_specs.dart';

class GetSpecsById {
  final CarRepository repo;
  GetSpecsById(this.repo);
  Future<CarSpecs> call(String id) => repo.getSpecsById(id);
}
