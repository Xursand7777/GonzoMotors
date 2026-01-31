import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import '../../../features/car_catalog/data/models/car.dart';
import 'package:equatable/equatable.dart';
part 'car_catalog_state.dart';

class CarCatalogCubit extends Cubit<CarCatalogCubitState> {
  CarCatalogCubit() : super(CarCatalogCubitState());

  void reset() {
    emit(const CarCatalogCubitState());
  }

  void setCars(List<CarModel> cars) {
    final initialCount = (cars.length).clamp(0, 6); // старт 6
    emit(state.copyWith(
      cars: cars,
      visibleCars: cars.sublist(0, initialCount),
    ));
  }

  void addCars() {
    HapticFeedback.selectionClick();

    final currentVisible = state.visibleCars.length;
    final total = state.cars.length;

    if (currentVisible >= total) return;

    final newLength = (currentVisible + 6).clamp(0, total); // например +6
    emit(state.copyWith(
      visibleCars: state.cars.sublist(0, newLength),
    ));
  }


}