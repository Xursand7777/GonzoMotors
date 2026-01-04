part of 'auth_cubit.dart';

class AuthPageState extends Equatable {
  final BaseStatus status;
  final BaseStatus otpCodeStatus;
  final bool isVerified;
  final int currentPage;
  final int resendCodeTime;
  final DateTime? userDateOfBirth;

  // final int resendAttempts;

  const AuthPageState( {
    this.otpCodeStatus = const BaseStatus(type: StatusType.initial),
    this.status = const BaseStatus(type: StatusType.initial),
    this.isVerified = false,
    this.currentPage = 0,
    this.resendCodeTime = 60,
    this.userDateOfBirth,
    // this.resendAttempts = 0,
  });

  AuthPageState copyWith({
    BaseStatus? status,
    BaseStatus? otpCodeStatus,
    bool? isVerified,
    int? currentPage,
    int? resendCodeTime,
    DateTime? userDateOfBirth,
    //  int? resendAttempts,
  }) {
    return AuthPageState(
      resendCodeTime: resendCodeTime ?? this.resendCodeTime,
      otpCodeStatus: otpCodeStatus ?? this.otpCodeStatus,
      currentPage: currentPage ?? this.currentPage,
      status: status ?? this.status,
      isVerified: isVerified ?? this.isVerified,
      userDateOfBirth: userDateOfBirth ?? this.userDateOfBirth,
      //  resendAttempts: resendAttempts ?? this.resendAttempts,
    );
  }

  @override
  List<Object?> get props => [
    status,
    otpCodeStatus,
    isVerified,
    resendCodeTime,
    currentPage,
    userDateOfBirth,
    // resendAttempts,
  ];
}
