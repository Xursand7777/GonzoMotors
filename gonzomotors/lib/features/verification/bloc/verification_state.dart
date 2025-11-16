part of 'verification_bloc.dart';

class VerificationState extends Equatable {
  final String code;
  final BaseStatus status;
  final String? errorMessage;

  const VerificationState({
    this.code = '',
    this.status = const BaseStatus(type: StatusType.initial),
    this.errorMessage,
  });

  VerificationState copyWith({
    String? code,
    BaseStatus? status,
    String? errorMessage,
  }) {
    return VerificationState(
      code: code ?? this.code,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [code, status, errorMessage];
}
