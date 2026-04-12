import 'package:gonzo_motors/core/network/base_repository.dart';
import '../models/compare_result.dart';

abstract class CompareRepository extends BaseRepository {
  CompareRepository(super.dio);
  
  Future<CompareResult> getComparison(int carId1, int carId2);
}

class CompareRepositoryImpl extends CompareRepository {
  CompareRepositoryImpl(super.dio);

  @override
  Future<CompareResult> getComparison(int carId1, int carId2) async {
    final res = await dio.get('Cars/compare', queryParameters: {
      'leftId': carId1,
      'rightId': carId2,
    });
    
    return CompareResult.fromJson(res.data as Map<String, dynamic>);
  }
}
