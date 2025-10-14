part of 'ads_banner_bloc.dart';


class AdsBannerState extends Equatable {
  final BaseStatus status;
  final List<AdsBannerModel> banners;

  const AdsBannerState({
    this.status = const BaseStatus(type: StatusType.initial),
    this.banners = const [],
  });

  AdsBannerState copyWith({
    BaseStatus? status,
    List<AdsBannerModel>? banners,
  }) {
    return AdsBannerState(
      status: status ?? this.status,
      banners: banners ?? this.banners,
    );
  }

  @override
  List<Object> get props => [status, banners];
}
