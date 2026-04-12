import 'package:equatable/equatable.dart';
import '../../core/bloc/base_status.dart';
import '../data/models/compare_result.dart';

class CompareState extends Equatable {
  final BaseStatus status;
  final CompareResult? result;

  const CompareState({
    this.status = const BaseStatus.initial(),
    this.result,
  });

  CompareState copyWith({
    BaseStatus? status,
    CompareResult? result,
  }) {
    return CompareState(
      status: status ?? this.status,
      result: result ?? this.result,
    );
  }

  @override
  List<Object?> get props => [status, result];
}
