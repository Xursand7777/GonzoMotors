import 'package:gonzo_motors/core/network/base_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/network/models/pagination.dart';
import '../models/car.dart' show CarModel;




abstract class CarRepository extends BaseRepository {
  CarRepository(super.dio);
  Future<Pagination<CarModel>> getCarCards({Map<String, dynamic>? queryParameters});
}

class CarRepositoryImpl extends CarRepository {
  final SharedPreferences sharedPreferences;
  CarRepositoryImpl(super.dio, this.sharedPreferences);

  @override
  Future<Pagination<CarModel>> getCarCards({Map<String, dynamic>? queryParameters}) async {
    return getListWithPaginationRequest(
      'Common/Cars', 
      fromJson: CarModel.fromJson,
      queryParameters: queryParameters,
    );
  }
}