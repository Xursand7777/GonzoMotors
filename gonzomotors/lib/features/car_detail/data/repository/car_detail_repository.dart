import '../models/car_model_detail.dart';
import 'package:gonzo_motors/core/network/base_repository.dart';

abstract class CarDetailRepository extends BaseRepository {
  CarDetailRepository(super.dio);

  /// Модификации по модели (modelId)
  /// Возвращает список модификаций (Premium/Flagship/…)
  Future<List<CarModelDetail>> getModificationsByModelId(int? modelId);

  /// Детальная инфа по выбранной модификации (carId)
  Future<CarModelDetail> getCarDetailByCarId(int carId);

  /// (опционально) PDF по модификации
  Future<String?> getPdfUrl(int carId);

  /// (опционально) Feature cards для карусели
  Future<List<CarFeatureCard>> getFeatureCards(int carId);
}

/// Пример DTO под “карточки снизу”
class CarFeatureCard {
  final String title;
  final String description;
  final String imageUrl;

  CarFeatureCard({
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  factory CarFeatureCard.fromJson(Map<String, dynamic> json) => CarFeatureCard(
    title: (json['title'] ?? '') as String,
    description: (json['description'] ?? '') as String,
    imageUrl: (json['imageUrl'] ?? '') as String,
  );
}

class CarDetailRepositoryImpl extends CarDetailRepository {

  CarDetailRepositoryImpl(super.dio);

  @override
  Future<List<CarModelDetail>> getModificationsByModelId(int? modelId) async {
    // TODO: поменяй на свой endpoint
    final res = await dio.get('/cars/model/$modelId/modifications');

    final list = (res.data as List? ?? []);
    return list
        .map((e) => CarModelDetail.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<CarModelDetail> getCarDetailByCarId(int carId) async {
    // TODO: поменяй на свой endpoint
    final res = await dio.get('/cars/$carId/detail');
    return CarModelDetail.fromJson(res.data as Map<String, dynamic>);
  }

  @override
  Future<String?> getPdfUrl(int carId) async {
    // TODO: optional endpoint
    try {
      final res = await dio.get('/cars/$carId/pdf');
      return (res.data?['url'] as String?);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<CarFeatureCard>> getFeatureCards(int carId) async {
    // TODO: optional endpoint
    try {
      final res = await dio.get('/cars/$carId/features');
      final list = (res.data as List? ?? []);
      return list
          .map((e) => CarFeatureCard.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
