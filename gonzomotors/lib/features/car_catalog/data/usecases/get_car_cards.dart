import '../repository/car_repository.dart';
import '../../../../data/models/car_info.dart';

class GetCarCards {
  final CarRepository repo;
  GetCarCards(this.repo);
  Future<List<CarInfo>> call() => repo.getCarCards();
}
