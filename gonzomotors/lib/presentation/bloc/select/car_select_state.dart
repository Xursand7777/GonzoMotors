part of 'car_select_bloc.dart';

abstract class CarSelectState extends Equatable {
  const CarSelectState();
  @override
  List<Object?> get props => [];
  const factory CarSelectState.loading() = CarSelectLoading;
  const factory CarSelectState.error(String message) = CarSelectError;
  const factory CarSelectState.loaded({
    required List<CarInfo> cards,
    required Set<String> selected,
    CarSpecs? compareA,
    CarSpecs? compareB,
  }) = CarSelectLoaded;
}

class CarSelectLoading extends CarSelectState {
  const CarSelectLoading();
}

class CarSelectError extends CarSelectState {
  final String message;
  const CarSelectError(this.message);
  @override
  List<Object?> get props => [message];
}

class CarSelectLoaded extends CarSelectState {
  final List<CarInfo> cards;
  final Set<String> selected;
  final CarSpecs? compareA;
  final CarSpecs? compareB;

  const CarSelectLoaded({
    required this.cards,
    required this.selected,
    this.compareA,
    this.compareB,
  });

  bool get canCompare => selected.length == 2;

  CarSelectLoaded copyWith({
    List<CarInfo>? cards,
    Set<String>? selected,
    CarSpecs? compareA,
    CarSpecs? compareB,
  }) =>
      CarSelectLoaded(
        cards: cards ?? this.cards,
        selected: selected ?? this.selected,
        compareA: compareA,
        compareB: compareB,
      );

  @override
  List<Object?> get props => [cards, selected, compareA, compareB];
}
