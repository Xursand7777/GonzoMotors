import '../../../core/bloc/base_status.dart';
import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/auth/widgets/auth_widgets.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthPageState> {
  Timer? _resendTimer;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final PageController _pageController = PageController();

  List<Widget>  pages  = [];

  PageController get pageController => _pageController;

  TextEditingController get phoneController => _phoneController;

  TextEditingController get pinController => _pinController;

  TextEditingController get nameController => _nameController;

  AuthCubit() : super(const AuthPageState()){
     pages = authPages;
  }

  @override
  Future<void> close() {
    _pageController.dispose();
    _phoneController.dispose();
    _pinController.dispose();
    _resendTimer?.cancel();
    return super.close();
  }

  void onPhoneNumberChanged() {
    emit(state.copyWith(
      isVerified: _phoneController.text.isNotEmpty &&
          _phoneController.text.length >= 12,
    ));
  }

  void setPages(List<Widget> newPages) {
    pages = newPages;
    emit(state);
  }

  Future<void> submitPhoneNumber() async {
    if (!state.isVerified) return;

    emit(state.copyWith(status: const BaseStatus(type: StatusType.loading)));

    await Future.delayed(const Duration(seconds: 2));

    emit(state.copyWith(
      currentPage: state.currentPage + 1,
      status: const BaseStatus(type: StatusType.success),
      isVerified: true,
      resendCodeTime: 60,
    ));

    startResendTimer(duration: 60);
  }

  Future<void> onOtpCodeChanged() async {
    if (_pinController.text.length != 4) return;

    emit(state.copyWith(
      otpCodeStatus: const BaseStatus(type: StatusType.loading),
    ));

    await Future.delayed(const Duration(seconds: 2));

    if (_pinController.text == "1234") {
      emit(state.copyWith(
        otpCodeStatus: const BaseStatus(type: StatusType.success),
      ));

      await Future.delayed(const Duration(seconds: 2));

      emit(state.copyWith(
        currentPage: state.currentPage + 1,
        otpCodeStatus: const BaseStatus(type: StatusType.initial),
      ));
    } else {
      emit(state.copyWith(
        otpCodeStatus: const BaseStatus(
            type: StatusType.error, message: "Invalid OTP code"),
      ));
    }
  }

  void startResendTimer({int duration = 60}) {
    _resendTimer?.cancel();

    emit(state.copyWith(resendCodeTime: duration));

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isClosed) {
        timer.cancel();
        return;
      }

      if (state.resendCodeTime <= 0) {
        timer.cancel();
        _resendTimer = null;
        emit(state.copyWith(
          resendCodeTime: 0,
          status: const BaseStatus(type: StatusType.initial),
        ));
      } else {
        emit(state.copyWith(resendCodeTime: state.resendCodeTime - 1));
      }
    });
  }

  void changeCurrentPage(int page) {
    emit(state.copyWith(
      currentPage: page,
    ));
  }

  void setUserDateOfBirth(DateTime? date) {
    emit(state.copyWith(
      userDateOfBirth: date,
    ));
  }

  Future<void> resendOtpCode() async {
    if (state.resendCodeTime > 0) return;

    emit(state.copyWith(
      status: const BaseStatus(
          type: StatusType.success,
          message: "Code resent successfully"
      ),
    ));

    startResendTimer(duration: 60);
  }
}