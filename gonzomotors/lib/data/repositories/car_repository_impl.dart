import 'package:gonzomotors/data/models/car_details.dart';

import '../../domain/repositories/car_repository.dart';
import '../data_sources/car_local_ds.dart';
import '../models/car_info.dart';
import '../models/car_specs.dart';

class CarRepositoryImpl implements CarRepository {
  final CarLocalDataSource local;
  CarRepositoryImpl(this.local);

  @override
  Future<List<CarInfo>> getCarCards() => local.getCards();

  @override
  Future<CarSpecs> getSpecsById(String id) => local.getSpecs(id);


  @override
  Future<CarDetails?> findDetailsBySpecs(CarSpecs s) async {
    // ожидаем формат 'Name (YYYY)' — такой же, как в CarDetails.toCompare()
    final re = RegExp(r'^(.*)\s*\((\d{4})\)$');
    final m = re.firstMatch(s.name);
    String? base;
    int? year;
    if (m != null) {
      base = m.group(1)!.trim();
      year = int.tryParse(m.group(2)!);
    }
    final all = await local.getAllDetails(); // добавим в datasource метод
    if (base != null && year != null) {
      for (final d in all) {
        if (d.name == base && d.year == year) return d;
      }
    }
    if (base != null) {
      for (final d in all) {
        if (d.name.toLowerCase() == base.toLowerCase()) return d;
      }
      for (final d in all) {
        if (d.name.toLowerCase().startsWith(base.toLowerCase())) return d;
      }
    }
    return null;
  }
}
