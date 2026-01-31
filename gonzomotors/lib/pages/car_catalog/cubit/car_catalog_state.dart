

part of 'car_catalog_cubit.dart';

class CarCatalogCubitState extends Equatable {
  final List<CarModel> cars;
  final List<CarModel> visibleCars;

  const CarCatalogCubitState({
    this.cars = const [],
    this.visibleCars = const []
  });

  CarCatalogCubitState copyWith({
    List<CarModel>? cars,
    List<CarModel>? visibleCars,
  }) {
    return CarCatalogCubitState(
      cars: cars ?? this.cars,
      visibleCars: visibleCars ?? this.visibleCars,
    );
  }


  @override
  List<Object?> get props => [cars, visibleCars];
}