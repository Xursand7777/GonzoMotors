import 'package:bloc/bloc.dart';
import '../../../core/bloc/base_status.dart';
import '../data/models/filter_options.dart';
import '../data/repository/filter_options_repository.dart';

class FilterOptionsState {
  final BaseStatus status;
  final FilterOptions options;

  const FilterOptionsState({
    required this.status,
    this.options = const FilterOptions(),
  });

  FilterOptionsState copyWith({
    BaseStatus? status,
    FilterOptions? options,
  }) {
    return FilterOptionsState(
      status: status ?? this.status,
      options: options ?? this.options,
    );
  }
}

class FilterOptionsCubit extends Cubit<FilterOptionsState> {
  final FilterOptionsRepository repo;

  FilterOptionsCubit({required this.repo}) 
      : super(FilterOptionsState(status: BaseStatus.initial())) {
    loadOptions();
  }

  Future<void> loadOptions({bool forceRefresh = false}) async {
    emit(state.copyWith(status: BaseStatus.loading()));
    try {
      final options = await repo.getFilterOptions(forceRefresh: forceRefresh);
      emit(state.copyWith(status: BaseStatus.success(), options: options));
    } catch (e) {
      emit(state.copyWith(status: BaseStatus.errorWithMessage(message: e.toString())));
    }
  }
}
