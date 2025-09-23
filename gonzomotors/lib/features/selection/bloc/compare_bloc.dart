import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/enums/car.dart';
import '../../../../data/models/car_details.dart';
import '../../../data/models/car_specs.dart';
import '../../../../data/models/compare_models.dart';
import '../data/usecases/find_details_by_specs.dart';


part 'compare_event.dart';
part 'compare_state.dart';

class CompareBloc extends Bloc<CompareEvent, CompareState> {
  final FindDetailsBySpecs _find;

  CompareBloc(this._find) : super(const CompareState.loading()) {
    on<CompareInit>(_onInit);
    on<CompareToggleHide>(_onToggleHide);
  }

  Future<void> _onInit(CompareInit e, Emitter<CompareState> emit) async {
    emit(const CompareState.loading());
    try {
      final A = await _find(e.a);
      final B = await _find(e.b);

      // причины — простая бизнес-логика на основе двух CarSpecs
      final reasons = _whyABetter(e.a, e.b);

      emit(CompareState.loaded(
        a: e.a,
        b: e.b,
        detA: A,
        detB: B,
        hideEquals: false,
        reasons: reasons,
      ));
    } catch (err) {
      emit(CompareState.error(err.toString()));
    }
  }

  void _onToggleHide(CompareToggleHide e, Emitter<CompareState> emit) {
    final s = state;
    if (s is! CompareLoaded) return;
    emit(s.copyWith(hideEquals: e.value));
  }

  // --- бизнес-логика "почему A лучше"
  List<String> _whyABetter(CarSpecs A, CarSpecs B) {
    final out = <String>[];
    if (A.seats > B.seats) out.add('1 больше пассажирских мест — ${A.seats} vs ${B.seats}');
    if (A.speakers > B.speakers) out.add('Больше динамиков — ${A.speakers} vs ${B.speakers}');
    if (A.baseWarrantyYears > B.baseWarrantyYears) {
      out.add('${A.baseWarrantyYears - B.baseWarrantyYears} years больше базовая гарантия — ${A.baseWarrantyYears} vs ${B.baseWarrantyYears}');
    }
    if (A.extWarrantyYears > B.extWarrantyYears) {
      out.add('${A.extWarrantyYears - B.extWarrantyYears} years дольше доп. гарантия — ${A.extWarrantyYears} vs ${B.extWarrantyYears}');
    }
    for (final c in Car.values) {
      if ((A.norm[c] ?? 0) - (B.norm[c] ?? 0) >= 12) {
        out.add('Лучше по категории «${carLabel(c)}»');
      }
    }
    if (out.isEmpty) out.add('Модели сопоставимы — явных преимуществ нет.');
    return out;
  }
}
