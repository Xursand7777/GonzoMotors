part of 'compare_bloc.dart';

abstract class CompareState extends Equatable {
  const CompareState();
  @override
  List<Object?> get props => [];

  const factory CompareState.loading() = CompareLoading;
  const factory CompareState.error(String message) = CompareError;
  const factory CompareState.loaded({
    required CarSpecs a,
    required CarSpecs b,
    required bool hideEquals,
    required List<String> reasons,
    CarDetails? detA,
    CarDetails? detB,
  }) = CompareLoaded;
}

class CompareLoading extends CompareState { const CompareLoading(); }

class CompareError extends CompareState {
  final String message;
  const CompareError(this.message);
  @override List<Object?> get props => [message];
}

class CompareLoaded extends CompareState {
  final CarSpecs a;
  final CarSpecs b;
  final bool hideEquals;
  final List<String> reasons;
  final CarDetails? detA;
  final CarDetails? detB;

  const CompareLoaded({
    required this.a,
    required this.b,
    required this.hideEquals,
    required this.reasons,
    this.detA,
    this.detB,
  });

  CompareLoaded copyWith({
    CarSpecs? a,
    CarSpecs? b,
    bool? hideEquals,
    List<String>? reasons,
    CarDetails? detA,
    CarDetails? detB,
  }) => CompareLoaded(
    a: a ?? this.a,
    b: b ?? this.b,
    hideEquals: hideEquals ?? this.hideEquals,
    reasons: reasons ?? this.reasons,
    detA: detA ?? this.detA,
    detB: detB ?? this.detB,
  );

  @override List<Object?> get props => [a, b, hideEquals, reasons, detA, detB];
}
