part of 'compare_bloc.dart';

abstract class CompareEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CompareInit extends CompareEvent {
  final CarSpecs a;
  final CarSpecs b;
  CompareInit({required this.a, required this.b});

  @override
  List<Object?> get props => [a, b];
}

class CompareToggleHide extends CompareEvent {
  final bool value;
  CompareToggleHide(this.value);
  @override
  List<Object?> get props => [value];
}
