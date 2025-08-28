import '../card_db.dart';
import '../models/car_details.dart';
import '../models/car_info.dart';
import '../models/car_specs.dart';

abstract class CarLocalDataSource {
  Future<List<CarInfo>> getCards();
  Future<CarSpecs> getSpecs(String id);
  Future<List<CarDetails>> getAllDetails();
}

class CarLocalDataSourceImpl implements CarLocalDataSource {
  @override
  Future<List<CarInfo>> getCards() async => carCards;

  @override
  Future<CarSpecs> getSpecs(String id) async => specsById(id);


  @override
  Future<List<CarDetails>> getAllDetails() async => carDb;



}
