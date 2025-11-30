import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/base_repository.dart';
import '../../../../core/network/models/pagination.dart';
import '../models/ads_banner_model.dart';

abstract class AdsBannerRepository extends BaseRepository {
  AdsBannerRepository(super.dio);

  Future<Pagination<AdsBannerModel>> getBanners();
  Future<void> seenBanner(String id);
  Future<void> clickedBanner(String id);

}

class AdsBannerRepositoryImpl extends AdsBannerRepository {
  final SharedPreferences sharedPreferences;
  AdsBannerRepositoryImpl(super.dio, this.sharedPreferences);

  @override
  Future<Pagination<AdsBannerModel>> getBanners() async {
    return getListWithPaginationRequest('AdsBanner', fromJson: AdsBannerModel.fromJson);
  }

  @override
  Future<void> clickedBanner(String id) {
    return postNoContent('ads-banner/click/$id');
  }

  @override
  Future<void> seenBanner(String id) async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final savedDate = sharedPreferences.getString('seen_banner_$id');

    if (savedDate != today) {
      await postNoContent('ads-banner/seen/$id');
      await sharedPreferences.setString('seen_banner_$id', today);
    }
  }
}