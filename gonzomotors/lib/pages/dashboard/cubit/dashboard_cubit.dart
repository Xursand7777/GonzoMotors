import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(const DashboardState.initial());

  void changeIndex(int index) {
    HapticFeedback.selectionClick();
    emit(state.copyWith(currentIndex: index));
  }
}