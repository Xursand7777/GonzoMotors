import 'package:gonzo_motors/core/network/base_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/models/api_response.dart';
import '../../../../core/network/models/pagination.dart';
import '../models/car.dart' show CarModel;




abstract class CarRepository extends BaseRepository {
  CarRepository(super.dio);
  Future<ApiResponse<Pagination<CarModel>>> getCarCards();
}

class CarRepositoryImpl extends CarRepository {
  final SharedPreferences sharedPreferences;
  CarRepositoryImpl(super.dio, this.sharedPreferences);

  @override
  Future<ApiResponse<Pagination<CarModel>>> getCarCards() async {
    return getListWithPagination('cars', fromJson: CarModel.fromJson);
  }





}