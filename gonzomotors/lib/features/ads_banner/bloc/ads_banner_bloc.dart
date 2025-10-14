import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/bloc/base_status.dart';
import '../data/models/ads_banner_model.dart';
import '../data/repository/ads_banner_repository.dart';
part 'ads_banner_event.dart';
part 'ads_banner_state.dart';

class AdsBannerBloc extends Bloc<AdsBannerEvent, AdsBannerState> {

  final AdsBannerRepository repo;

  AdsBannerBloc({required this.repo}) : super(const AdsBannerState()) {
    on<GetBannersEvent>(_getBanners);
    on<SeenBannerEvent>(_seenBanner);
    on<ClickedBannerEvent>(_clickedBanner);
  }


  void _getBanners(GetBannersEvent event, Emitter<AdsBannerState> emit) async {
    emit(state.copyWith(status: BaseStatus.loading()));
    try{
      final response = await repo.getBanners();
      if (response.success && response.data?.items != null) {
        emit(state.copyWith(
            status: BaseStatus.success(), banners: response.data?.items ?? []));
      } else {
        emit(state.copyWith(
            status: BaseStatus.errorWithMessage(message: response.message)));
      }
    }catch (e) {
      emit(state.copyWith(
          status: BaseStatus.errorWithMessage(message: e.toString())));
    }
  }



  void _seenBanner(SeenBannerEvent event, Emitter<AdsBannerState> emit) async{

    if (event.bannerId == null ) return;

    try {
      await repo.seenBanner(event.bannerId.toString());
    } catch (e) {
      // Handle error if needed
    }
  }

  void _clickedBanner(ClickedBannerEvent event, Emitter<AdsBannerState> emit) async {
    if (event.bannerId == null ) return;

    try {
      await repo.clickedBanner(event.bannerId.toString());
    } catch (e) {
      // Handle error if needed
    }
  }
}