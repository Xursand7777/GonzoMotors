part of 'verification_bloc.dart';

abstract class VerificationEvent extends Equatable {
  const VerificationEvent();

  @override
  List<Object?> get props => [];
}

class VerificationCodeChanged extends VerificationEvent {
  final String code;

  const VerificationCodeChanged(this.code);

  @override
  List<Object?> get props => [code];
}

class VerificationSubmitted extends VerificationEvent {
  const VerificationSubmitted();
}
