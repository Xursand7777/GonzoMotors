import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/bloc/base_status.dart';
import '../data/models/car.dart' show CarModel;
import '../data/repository/car_repository.dart';

part 'car_catalog_event.dart';
part 'car_catalog_state.dart';

class CarCatalogBloc extends Bloc<CarCatalogEvent, CarCatalogState> {
  final CarRepository repo;

  CarCatalogBloc({required this.repo}) : super(const CarCatalogState()) {
    on<GetCarsEvent>(_getCars);
  }

  void _getCars(GetCarsEvent event, Emitter<CarCatalogState> emit) async {
    emit(state.copyWith(status: BaseStatus.loading()));
    try {
      final response = await repo.getCarCards();
      if (response.success && response.data?.items != null) {
        emit(state.copyWith(
            status: BaseStatus.success(), cars: response.data?.items ?? []));
      } else {
        emit(state.copyWith(
            status: BaseStatus.errorWithMessage(message: response.message)));
      }
    }
    catch(e) {
      emit(state.copyWith(
          status: BaseStatus.errorWithMessage(message: e.toString())));
    }

  }






}