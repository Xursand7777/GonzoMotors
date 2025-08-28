import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../data/models/car_info.dart';
import '../../../../data/models/car_specs.dart';
import '../../../../domain/usecases/get_car_cards.dart';
import '../../../../domain/usecases/get_specs_by_id.dart';


part 'car_select_event.dart';
part 'car_select_state.dart';

class CarSelectBloc extends Bloc<CarSelectEvent, CarSelectState> {
  final GetCarCards _getCards;
  final GetSpecsById _getSpecs;

  CarSelectBloc(this._getCards, this._getSpecs)
      : super(const CarSelectState.loading()) {
    on<CarSelectLoad>(_onLoad);
    on<CarSelectToggle>(_onToggle);
    on<CarSelectCompare>(_onCompare);
  }

  Future<void> _onLoad(CarSelectLoad e, Emitter<CarSelectState> emit) async {
    emit(const CarSelectState.loading());
    try {
      final cards = await _getCards();
      emit(CarSelectState.loaded(cards: cards, selected: const {}));
    } catch (err) {
      emit(CarSelectState.error(err.toString()));
    }
  }

  void _onToggle(CarSelectToggle e, Emitter<CarSelectState> emit) {
    final s = state;
    if (s is! CarSelectLoaded) return;
    final selected = Set<String>.from(s.selected);
    if (selected.contains(e.id)) {
      selected.remove(e.id);
    } else if (selected.length < 2) {
      selected.add(e.id);
    }
    emit(s.copyWith(selected: selected));
  }

  Future<void> _onCompare(CarSelectCompare e, Emitter<CarSelectState> emit) async {
    final s = state;
    if (s is! CarSelectLoaded || s.selected.length != 2) return;

    final ids = s.selected.toList();
    final a = await _getSpecs(ids[0]);
    final b = await _getSpecs(ids[1]);

    // Побочный эффект: отдадим результат через состояние
    emit(s.copyWith(compareA: a, compareB: b));
    // UI прочитает compareA/compareB, выполнит навигацию и может отправить CarSelectClearCompare
  }
}
