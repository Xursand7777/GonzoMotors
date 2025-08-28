part of 'car_select_bloc.dart';

abstract class CarSelectEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CarSelectLoad extends CarSelectEvent {}

class CarSelectToggle extends CarSelectEvent {
  final String id;
  CarSelectToggle(this.id);
  @override
  List<Object?> get props => [id];
}

class CarSelectCompare extends CarSelectEvent {}
