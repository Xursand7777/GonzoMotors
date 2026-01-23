
part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final BaseStatus status;
  final bool isVerified;
  final int resendCodeTime;
  final DateTime? userDateOfBirth;
  final String? smsAuth;
  final bool isLogin;
  final String? nameError;
  final String? birthDateError;
  final bool isUserInfoValid;
  final bool resentOtpCode;
  final String? pinfl;
  final String? series;
  final String? seriesNumber;


  const AuthState({
    this.status = const BaseStatus(type: StatusType.initial),
    this.isVerified = false,
    this.resendCodeTime = 60,
    this.userDateOfBirth,
    this.smsAuth,
    this.isLogin = false,
    this.nameError,
    this.birthDateError,
    this.isUserInfoValid = false,
    this.pinfl,
    this.series,
    this.seriesNumber,
    this.resentOtpCode = false,

  });

  AuthState copyWith({
    BaseStatus? status,
    bool? isVerified,
    int? resendCodeTime,
    DateTime? userDateOfBirth,
    String? smsAuth,
    bool? isLogin,
    String? nameError,
    String? birthDateError,
    bool? isUserInfoValid,
    bool? resentOtpCode,
    String? pinfl,
    String? series,
    String? seriesNumber,
  }) {
    return AuthState(
      status: status ?? BaseStatus.initial(),
      isVerified: isVerified ?? this.isVerified,
      resendCodeTime: resendCodeTime ?? this.resendCodeTime,
      userDateOfBirth: userDateOfBirth ?? this.userDateOfBirth,
      smsAuth: smsAuth ?? this.smsAuth,
      isLogin: isLogin ?? false,
      nameError: nameError,
      birthDateError: birthDateError,
      isUserInfoValid: isUserInfoValid ?? this.isUserInfoValid,
      resentOtpCode: resentOtpCode ?? false,
      pinfl:  pinfl ?? this.pinfl,
      series:  series?? this.series,
      seriesNumber:  seriesNumber ?? this.seriesNumber,
    );
  }

  @override
  List<Object?> get props => [
    status,
    isVerified,
    resendCodeTime,
    userDateOfBirth,
    smsAuth,
    isLogin,
    nameError,
    birthDateError,
    isUserInfoValid,
    resentOtpCode,
    pinfl,
    series,
    seriesNumber,
  ];
}