import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/bloc/base_status.dart';
import '../data/repository/compare_repository.dart';
import 'compare_event.dart';
import 'compare_state.dart';

class CompareBloc extends Bloc<CompareEvent, CompareState> {
  final CompareRepository repository;

  CompareBloc({required this.repository}) : super(const CompareState()) {
    on<LoadComparisonEvent>(_onLoadComparison);
  }

  Future<void> _onLoadComparison(
    LoadComparisonEvent event,
    Emitter<CompareState> emit,
  ) async {
    emit(state.copyWith(status: BaseStatus.loading()));
    try {
      final result = await repository.getComparison(event.carId1, event.carId2);
      emit(state.copyWith(
        status: BaseStatus.success(),
        result: result,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: BaseStatus.errorWithMessage(message: e.toString()),
      ));
    }
  }
}
