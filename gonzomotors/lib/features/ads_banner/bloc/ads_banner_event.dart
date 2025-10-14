part of 'ads_banner_bloc.dart';

sealed class AdsBannerEvent extends Equatable {
  const AdsBannerEvent();

  @override
  List<Object?> get props => [];
}

class GetBannersEvent extends AdsBannerEvent {
  const GetBannersEvent();

  @override
  List<Object?> get props => [];
}

class SeenBannerEvent extends AdsBannerEvent {
  final int? bannerId;

  const SeenBannerEvent(this.bannerId);

  @override
  List<Object?> get props => [bannerId];
}


class ClickedBannerEvent extends AdsBannerEvent {
  final int? bannerId;

  const ClickedBannerEvent(this.bannerId);

  @override
  List<Object?> get props => [bannerId];
}