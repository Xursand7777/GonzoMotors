part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
}

class CheckPhoneNumberEvent extends AuthEvent {
  const CheckPhoneNumberEvent();

  @override
  List<Object?> get props => [];
}

class ConfirmPhoneNumberEvent extends AuthEvent {
  const ConfirmPhoneNumberEvent();

  @override
  List<Object?> get props => [];
}

class ChangeOtpEvent extends AuthEvent {
  const ChangeOtpEvent();

  @override
  List<Object?> get props => [];
}

class SetUserDateEvent extends AuthEvent {
  final DateTime date;

  const SetUserDateEvent({
    required this.date,
  });

  @override
  List<Object?> get props => [date];
}

class StartResendCodeTimerEvent extends AuthEvent {
  const StartResendCodeTimerEvent();

  @override
  List<Object?> get props => [];
}

class ResendOtpCodeEvent extends AuthEvent {
  const ResendOtpCodeEvent();

  @override
  List<Object?> get props => [];
}

class GetUserSmsAuthEvent extends AuthEvent {
  const GetUserSmsAuthEvent();

  @override
  List<Object?> get props => [];
}

class ValidateUserInfoEvent extends AuthEvent {
  const ValidateUserInfoEvent();

  @override
  List<Object?> get props => [];
}

class CheckUserInfoValidationEvent extends AuthEvent {
  const CheckUserInfoValidationEvent();

  @override
  List<Object?> get props => [];
}

class OtpClearEvent extends AuthEvent {
  const OtpClearEvent();

  @override
  List<Object?> get props => [];
}

class UserPassportDataEvent extends AuthEvent {
  final String? pinfl;
  final String? series;
  final bool isNumber;

  const UserPassportDataEvent({
    this.pinfl,
    this.series,
    this.isNumber = false,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    pinfl,
    series,
    isNumber,
  ];
}
