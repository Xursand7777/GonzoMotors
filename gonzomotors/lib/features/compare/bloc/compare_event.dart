import 'package:equatable/equatable.dart';

abstract class CompareEvent extends Equatable {
  const CompareEvent();

  @override
  List<Object?> get props => [];
}

class LoadComparisonEvent extends CompareEvent {
  final int carId1;
  final int carId2;

  const LoadComparisonEvent({required this.carId1, required this.carId2});

  @override
  List<Object?> get props => [carId1, carId2];
}
