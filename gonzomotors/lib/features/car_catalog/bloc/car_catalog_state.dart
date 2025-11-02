part of 'car_catalog_bloc.dart';

class CarCatalogState extends Equatable {
  final BaseStatus status;
  final List<CarModel> cars;

  const CarCatalogState({
    this.status = const BaseStatus(type: StatusType.initial),
    this.cars = const [],
  });

  CarCatalogState copyWith({
    BaseStatus? status,
    List<CarModel>? cars,
  }) {
    return CarCatalogState(
      status: status ?? this.status,
      cars: cars ?? this.cars,
    );
  }

  @override
  List<Object> get props => [status, cars];

}