import 'package:equatable/equatable.dart';

abstract class CarDetailEvent extends Equatable {
  const CarDetailEvent();

  @override
  List<Object?> get props => [];
}

class CarDetailOpened extends CarDetailEvent {
  final int? modelId;
  final int? preferredCarId; // optional

  const CarDetailOpened({
    required this.modelId,
    this.preferredCarId,
  });

  @override
  List<Object?> get props => [modelId, preferredCarId];
}

class CarDetailRefresh extends CarDetailEvent {
  const CarDetailRefresh();
}

class CarDetailSelectModification extends CarDetailEvent {
  final int carId;
  const CarDetailSelectModification(this.carId);

  @override
  List<Object?> get props => [carId];
}

class CarDetailSelectColor extends CarDetailEvent {
  final int index;
  const CarDetailSelectColor(this.index);

  @override
  List<Object?> get props => [index];
}

class CarDetailToggleFavorite extends CarDetailEvent {
  const CarDetailToggleFavorite();
}

class CarDetailBuyPressed extends CarDetailEvent {
  const CarDetailBuyPressed();
}

class CarDetailTestDrivePressed extends CarDetailEvent {
  const CarDetailTestDrivePressed();
}
