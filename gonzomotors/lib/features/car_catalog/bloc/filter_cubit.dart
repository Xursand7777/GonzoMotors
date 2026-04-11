import 'package:bloc/bloc.dart';
import '../data/models/car_query_options.dart';

class FilterCubit extends Cubit<CarQueryOptions> {
  FilterCubit() : super(const CarQueryOptions());

  void updateQuery(CarQueryOptions Function(CarQueryOptions) updater) {
    emit(updater(state));
  }

  void toggleBodyType(int id) {
    final list = List<int>.from(state.bodyTypeIds ?? []);
    if (list.contains(id)) {
      list.remove(id);
    } else {
      list.add(id);
    }
    emit(state.copyWith(bodyTypeIds: list));
  }

  void toggleBrand(int id) {
    final list = List<int>.from(state.brandIds ?? []);
    if (list.contains(id)) {
      list.remove(id);
    } else {
      list.add(id);
    }
    emit(state.copyWith(brandIds: list));
  }

  void togglePowertrain(String pt) {
    final list = List<String>.from(state.powertrains ?? []);
    if (list.contains(pt)) {
      list.remove(pt);
    } else {
      list.add(pt);
    }
    emit(state.copyWith(powertrains: list));
  }

  void reset() {
    emit(const CarQueryOptions());
  }

  void applyPrice(num minPrice, num maxPrice) {
    emit(state.copyWith(priceMin: minPrice, priceMax: maxPrice));
  }
}
