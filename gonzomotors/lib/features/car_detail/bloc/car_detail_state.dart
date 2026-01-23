import 'package:equatable/equatable.dart';
import 'package:gonzo_motors/core/bloc/base_status.dart';

import '../data/models/car_model_detail.dart';
import '../data/repository/car_detail_repository.dart';



class CarDetailState extends Equatable {
  final BaseStatus status;

  /// Список модификаций (карточки Premium/Flagship/…)
  final List<CarModelDetail> modifications;

  /// Выбранная модификация (detail)
  final CarModelDetail? selected;

  final int selectedColorIndex;

  final bool isFavorite;
  final String? pdfUrl;
  final List<CarFeatureCard> featureCards;

  final String? errorMessage;

  const CarDetailState({
    this.status =  const BaseStatus(type: StatusType.initial),
    this.modifications = const [],
    this.selected,
    this.selectedColorIndex = 0,
    this.isFavorite = false,
    this.pdfUrl,
    this.featureCards = const [],
    this.errorMessage,
  });

  CarDetailState copyWith({
    BaseStatus? status,
    List<CarModelDetail>? modifications,
    CarModelDetail? selected,
    int? selectedColorIndex,
    bool? isFavorite,
    String? pdfUrl,
    List<CarFeatureCard>? featureCards,
    String? errorMessage,
  }) {
    return CarDetailState(
      status: status ?? this.status,
      modifications: modifications ?? this.modifications,
      selected: selected ?? this.selected,
      selectedColorIndex: selectedColorIndex ?? this.selectedColorIndex,
      isFavorite: isFavorite ?? this.isFavorite,
      pdfUrl: pdfUrl ?? this.pdfUrl,
      featureCards: featureCards ?? this.featureCards,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    modifications,
    selected,
    selectedColorIndex,
    isFavorite,
    pdfUrl,
    featureCards,
    errorMessage,
  ];
}
