part of 'car_catalog_bloc.dart';

class CarCatalogState extends Equatable {
  final BaseStatus status;
  final List<CarModel> cars;
  final List<CarModel> visibleCars;

  const CarCatalogState({
    this.status = const BaseStatus(type: StatusType.initial),
    this.cars = const [],
    this.visibleCars = const []
  });

  CarCatalogState copyWith({
    BaseStatus? status,
    List<CarModel>? cars,
    List<CarModel>? visibleCars,
  }) {
    return CarCatalogState(
      status: status ?? this.status,
      cars: cars ?? this.cars,
      visibleCars: visibleCars ?? this.visibleCars,
    );
  }

  @override
  List<Object> get props => [status, cars, visibleCars];

}