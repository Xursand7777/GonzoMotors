import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gonzo_motors/core/bloc/base_status.dart';

import '../data/models/car_model_detail.dart';
import '../data/repository/car_detail_repository.dart';
import 'car_detail_event.dart';
import 'car_detail_state.dart';

class CarDetailBloc extends Bloc<CarDetailEvent, CarDetailState> {
  final CarDetailRepository repository;

  int? _modelId;

  CarDetailBloc({required this.repository}) : super(const CarDetailState()) {
    on<CarDetailOpened>(_onOpened);
    on<CarDetailRefresh>(_onRefresh);
    on<CarDetailSelectModification>(_onSelectModification);
    on<CarDetailSelectColor>(_onSelectColor);
    on<CarDetailToggleFavorite>(_onToggleFavorite);
    on<CarDetailBuyPressed>(_onBuy);
    on<CarDetailTestDrivePressed>(_onTestDrive);
  }

  Future<void> _onOpened(
      CarDetailOpened event,
      Emitter<CarDetailState> emit,
      ) async {
    emit(state.copyWith(status: BaseStatus.loading(), errorMessage: null));

    try {
      final mods = await repository.getModificationsByModelId(event.modelId);

      if (mods.isEmpty) {
        emit(state.copyWith(
          status: BaseStatus.completed(),
          errorMessage: 'Нет модификаций по этой модели',
          modifications: const [],
          selected: null,
        ));
        return;
      }

      final preferred = event.preferredCarId;
      final selectedId = (preferred != null && mods.any((m) => m.id == preferred))
          ? preferred
          : mods.first.id;

      final detail = await repository.getCarDetailByCarId(selectedId);
      final pdfUrl = await repository.getPdfUrl(selectedId);
      final cards = await repository.getFeatureCards(selectedId);

      emit(state.copyWith(
        status: BaseStatus.success(),
        modifications: mods,
        selected: detail,
        pdfUrl: pdfUrl,
        featureCards: cards,
        selectedColorIndex: 0,
      ));
    } catch (e) {
      emit(
        state.copyWith(
          status: BaseStatus.errorWithMessage(message: e.toString()),
        ));
    }
  }

  Future<void> _onRefresh(CarDetailRefresh event, Emitter<CarDetailState> emit) async {
    final modelId = _modelId;
    if (modelId == null) return;

    // add(CarDetailStarted(
    //   modelId: modelId,
    //   initialCarId: state.selected?.id,
    // ));
  }

  Future<void> _onSelectModification(
      CarDetailSelectModification event,
      Emitter<CarDetailState> emit,
      ) async {
    // Важно: модификации НЕ перезагружаем — они уже есть
    emit(state.copyWith(status: BaseStatus.loading(), errorMessage: null));

    try {
      final detail = await repository.getCarDetailByCarId(event.carId);
      final pdfUrl = await repository.getPdfUrl(event.carId);
      final cards = await repository.getFeatureCards(event.carId);

      emit(state.copyWith(
        status: BaseStatus.success(),
        selected: detail,
        pdfUrl: pdfUrl,
        featureCards: cards,
        selectedColorIndex: 0,
      ));
    } catch (e) {
      emit(
          state.copyWith(
            status: BaseStatus.errorWithMessage(message: e.toString()),
          ));
    }
  }


  void _onSelectColor(CarDetailSelectColor event, Emitter<CarDetailState> emit) {
    emit(state.copyWith(selectedColorIndex: event.index));
  }

  void _onToggleFavorite(CarDetailToggleFavorite event, Emitter<CarDetailState> emit) {
    emit(state.copyWith(isFavorite: !state.isFavorite));
  }

  void _onBuy(CarDetailBuyPressed event, Emitter<CarDetailState> emit) {
    // TODO: navigation / checkout / open telegram / etc
  }

  void _onTestDrive(CarDetailTestDrivePressed event, Emitter<CarDetailState> emit) {
    // TODO: show bottomsheet / form
  }
}
