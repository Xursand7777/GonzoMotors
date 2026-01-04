import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smart_auth/smart_auth.dart';

import '../../../core/bloc/base_status.dart';
import '../../../core/services/token_service.dart';
import '../../../core/utils/mask_text_input_formatter.dart';
import '../data/repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;
  final SmartAuth _smsAuth;
  final TokenService _tokenService;


  AuthBloc(this._repository,this._smsAuth,this._tokenService) : super(const AuthState()) {
    on<CheckPhoneNumberEvent>(_onCheckPhoneNumber);
    on<ConfirmPhoneNumberEvent>(_onConfirmPhoneNumber);
    on<ChangeOtpEvent>(_onChangeOtp);
    on<SetUserDateEvent>(_onSetUserDate);
    on<ResendOtpCodeEvent>(_onResendOtpCode);
    on<GetUserSmsAuthEvent>(_onSetUserSmsAuth);
    on<ValidateUserInfoEvent>(_onValidateUserInfo);
    on<CheckUserInfoValidationEvent>(_onCheckUserInfoValidation);
    on<OtpClearEvent>(_onOtpClear);
    on<UserPassportDataEvent>(_onUserPassport);
    add(const GetUserSmsAuthEvent());
  }

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();

  final MaskTextInputFormatter _phoneMaskFormatter = MaskTextInputFormatter(
    mask: '## ### ## ##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  final MaskTextInputFormatter _birthDateMaskFormatter = MaskTextInputFormatter(
    mask: '##.##.####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  TextEditingController get phoneController => _phoneController;
  TextEditingController get pinController => _pinController;
  TextEditingController get nameController => _nameController;
  TextEditingController get lastController => _lastController;
  TextEditingController get birthDateController => _birthDateController;
  MaskTextInputFormatter get phoneMaskFormatter => _phoneMaskFormatter;
  MaskTextInputFormatter get birthDateMaskFormatter => _birthDateMaskFormatter;

  @override
  Future<void> close() {
    _phoneController.dispose();
    _pinController.dispose();
    _nameController.dispose();
    _lastController.dispose();
    _birthDateController.dispose();
    return super.close();
  }

  void _onCheckPhoneNumber(CheckPhoneNumberEvent event, Emitter<AuthState> emit) async{
    emit(
      state.copyWith(
        isVerified:  _phoneController.text.isNotEmpty && _phoneController.text.length == 12,
      ),
    );
  }

  void _onConfirmPhoneNumber(ConfirmPhoneNumberEvent event, Emitter<AuthState> emit) async {
    if(state.status.isLoading()) return;
    if (!state.isVerified) return;
    emit(state.copyWith(status: const BaseStatus(type: StatusType.loading)));
    try {
      final phone = '+998${_phoneMaskFormatter.getUnmaskedText()}';
      final data = {
        'phone': phone,
      };
      if(!Platform.isIOS){
        state.smsAuth != null ? data['hash_code'] = state.smsAuth! : null;
      }

      await _repository.sendPhoneVerification(query: data);
      emit(state.copyWith(
          status: BaseStatus.success()));

      emit(state.copyWith(
          status: BaseStatus.paging(),resentOtpCode:  true));

    }on DioException catch(e){
      if (e.response != null && e.response?.data != null) {
        final errorData = e.response?.data;
        String errorMessage = 'Xatolik yuz berdi';

        if (errorData is Map<String, dynamic> && errorData.containsKey('message')) {
          errorMessage = errorData['message'];
        } else if (errorData is String) {
          errorMessage = errorData;
        }

        emit( state.copyWith(
          status: BaseStatus.errorWithMessage(message: errorMessage),
        ));
        log('Auth bloc DioException otp ${e.response?.data}');
      } else {
        emit( state.copyWith(
          status: BaseStatus.errorWithMessage(message: e.message),
        ));
        log('Auth bloc DioException otp ${e.message}');
      }

    } catch (e) {
      emit(state.copyWith(
        status: BaseStatus(type: StatusType.error, message: e.toString()),
      ));
    }
  }

  FutureOr<void> _onChangeOtp(ChangeOtpEvent event, Emitter<AuthState> emit) async{
    log('Otp changed: ${_pinController.text}');
    if(_pinController.text.length != 4) return;

    if (state.status.isLoading()) return;

    emit(state.copyWith(
        status:  BaseStatus.loading()
    ));

    final phone = '+998${_phoneMaskFormatter.getUnmaskedText()}';

    try {
      final data = {
        'phone': phone,
        'code': _pinController.text,
      };
      final res = await _repository.verifyOtpCode(query: data);

      if (res.data != null && res.success == true) {
        if (res.data?.accessToken != null && res.data!.refreshToken != null) {
          await _tokenService.saveToken(res.data!.accessToken!);
          await _tokenService.saveRefreshToken(res.data!.refreshToken!);
          emit(
              state.copyWith(
                status: BaseStatus.completed(),
                isLogin: true,
              )
          );
        } else if (res.data?.temporaryToken != null) {
          await _tokenService.saveToken(res.data!.temporaryToken!);
          emit(
              state.copyWith(
                status: BaseStatus.completed(),
              )
          );
        }

        /*await _tokenService.saveToken(res.data!.accessToken!);
        await _tokenService.saveRefreshToken(res.data!.refreshToken!);
        emit(
            state.copyWith(
              otpCodeStatus:  BaseStatus.completed(),
              isLogin:  res.data?.temporaryToken != null,
            )
        );*/
      } else {
        emit(
            state.copyWith(
              status: BaseStatus.errorWithMessage(message: res.message),
            )
        );
      }
    }on DioException catch(e){

      if (e.response != null && e.response?.data != null) {
        final errorData = e.response?.data;
        String errorMessage = 'Xatolik yuz berdi';

        if (errorData is Map<String, dynamic> && errorData.containsKey('message')) {
          errorMessage = errorData['message'];
        } else if (errorData is String) {
          errorMessage = errorData;
        }

        emit( state.copyWith(
          status: BaseStatus.errorWithMessage(message: errorMessage),
        ));
        log('Auth bloc DioException otp ${e.response?.data}');
      } else {
        emit( state.copyWith(
          status: BaseStatus.errorWithMessage(message: e.message),
        ));
        log('Auth bloc DioException otp ${e.message}');
      }
    } catch(e,s){
      emit( state.copyWith(
        status: BaseStatus.errorWithMessage(message: e.toString()),
      ));
      log('Auth bloc Error otp $e, $s');
    }
  }

  FutureOr<void> _onSetUserDate(SetUserDateEvent event, Emitter<AuthState> emit) async{
    // Format the date as dd.mm.yyyy
    final formattedDate = '${event.date.day.toString().padLeft(2, '0')}.${event.date.month.toString().padLeft(2, '0')}.${event.date.year}';
    _birthDateController.text = formattedDate;

    emit(state.copyWith(
      userDateOfBirth: event.date,
      birthDateError: null,
    ));

    // Check validation after setting date
    add(const CheckUserInfoValidationEvent());
  }

  void _onResendOtpCode(ResendOtpCodeEvent event, Emitter<AuthState> emit) async {
    if(state.status.isLoading()) return;

    emit (state.copyWith(
      status:  BaseStatus.loading(),
    ));
    try {
      final phone = '+998${_phoneMaskFormatter.getUnmaskedText()}';
      final data = {
        'phone': phone,
      };
      state.smsAuth != null ? data['hash_code'] = state.smsAuth! : null;

      await _repository.sendPhoneVerification(query: data);
      emit(state.copyWith(
          status: BaseStatus.paging(),resentOtpCode: true));

    }on DioException catch(e){
      if (e.response != null && e.response?.data != null) {
        final errorData = e.response?.data;
        String errorMessage = 'Xatolik yuz berdi';

        if (errorData is Map<String, dynamic> && errorData.containsKey('message')) {
          errorMessage = errorData['message'];
        } else if (errorData is String) {
          errorMessage = errorData;
        }

        emit( state.copyWith(
          status: BaseStatus.errorWithMessage(message: errorMessage),
        ));
        log('Auth bloc DioException otp ${e.response?.data}');
      } else {
        emit( state.copyWith(
          status: BaseStatus.errorWithMessage(message: e.message),
        ));
        log('Auth bloc DioException otp ${e.message}');
      }

    } catch (e) {
      emit(state.copyWith(
        status: BaseStatus(type: StatusType.error, message: e.toString()),
      ));
    }
  }

  void _onSetUserSmsAuth(GetUserSmsAuthEvent event, Emitter<AuthState> emit) async {
    final smsService = await _smsAuth.getAppSignature();
    emit(state.copyWith(
      smsAuth: smsService.data,
    ));
  }

  FutureOr<void> _onValidateUserInfo(ValidateUserInfoEvent event, Emitter<AuthState> emit) async {
    String? nameError;
    String? birthDateError;

    // Validate name (required)
    if (_nameController.text.trim().isEmpty) {
      nameError = "Ism kiritish majburiy";
    } else if (_nameController.text.trim().length < 2) {
      nameError = "Ism kamida 2 ta harfdan iborat bo'lishi kerak";
    }

    // Validate birth date if entered
    if (_birthDateController.text.trim().isNotEmpty) {
      final birthDateText = _birthDateController.text.trim();

      // Check if format is correct (dd.mm.yyyy)
      if (birthDateText.length != 10) {
        birthDateError = "Sana to'liq kiritilmagan (dd.mm.yyyy)";
      } else {
        try {
          final parts = birthDateText.split('.');
          if (parts.length != 3) {
            birthDateError = "Sana noto'g'ri formatda kiritilgan";
          } else {
            final day = int.tryParse(parts[0]);
            final month = int.tryParse(parts[1]);
            final year = int.tryParse(parts[2]);

            if (day == null || month == null || year == null) {
              birthDateError = "Sana noto'g'ri kiritilgan";
            } else if (day < 1 || day > 31) {
              birthDateError = "Kun 1 dan 31 gacha bo'lishi kerak";
            } else if (month < 1 || month > 12) {
              birthDateError = "Oy 1 dan 12 gacha bo'lishi kerak";
            } else if (year < 1900 || year > DateTime.now().year) {
              birthDateError = "Yil noto'g'ri kiritilgan";
            } else {
              // Check if date is valid
              try {
                final date = DateTime(year, month, day);
                if (date.isAfter(DateTime.now())) {
                  birthDateError = "Tug'ilgan sana kelajakda bo'lishi mumkin emas";
                }
                // Check minimum age (optional, e.g., 14 years)
                final age = DateTime.now().year - year;
                if (age < 14) {
                  birthDateError = "Yoshingiz kamida 14 bo'lishi kerak";
                }
              } catch (e) {
                birthDateError = "Noto'g'ri sana kiritilgan";
              }
            }
          }
        } catch (e) {
          birthDateError = "Sana noto'g'ri formatda kiritilgan";
        }
      }
    }

    if (nameError != null || birthDateError != null) {
      emit(state.copyWith(
        nameError: nameError,
        birthDateError: birthDateError,
        isUserInfoValid: false,
      ));
      return;
    }

    if (state.status.isLoading()) return;

    // Register user
    emit(state.copyWith(
      status: BaseStatus.loading(),
      nameError: null,
      birthDateError: null,
    ));

    try {
      final data = {
        'phone': '+998${_phoneMaskFormatter.getUnmaskedText()}',
        'first_name': _nameController.text.trim(),
      };

      if (_lastController.text.trim().isNotEmpty) {
        data['last_name'] = _lastController.text.trim();
      }

      if (state.userDateOfBirth != null) {
        data['date_of_birth'] = state.userDateOfBirth!.toIso8601String();
      } else if (_birthDateController.text.trim().isNotEmpty) {
        // Parse manually entered date
        final parts = _birthDateController.text.trim().split('.');
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        final date = DateTime(year, month, day);
        data['date_of_birth'] = date.toIso8601String();
      }

      final res = await _repository.registerUserProfile(query: data);

      if (res.data != null && res.success ==true ){
        if(res.data?.accessToken != null && res.data?.refreshToken != null){
          await _tokenService.saveToken(res.data!.accessToken!);
          await _tokenService.saveRefreshToken(res.data!.refreshToken!);

          emit(
              state.copyWith(
                status: BaseStatus.completed(),
                isLogin: true,
              )
          );

        }
      }else{
        emit (state.copyWith(
          isUserInfoValid:  false,

          status:  BaseStatus.errorWithMessage(message: res.message),
        ));
      }

    } catch (e, s) {
      log('Error registering user: $e $s');
      emit(state.copyWith(
        status: BaseStatus.errorWithMessage(message: 'Xatolik yuz berdi'),
        isUserInfoValid: false,
      ));
    }
  }
  void _onCheckUserInfoValidation(CheckUserInfoValidationEvent event, Emitter<AuthState> emit) {
    final isNameValid = _nameController.text.trim().isNotEmpty && _nameController.text.trim().length >= 2;

    emit(state.copyWith(
      isUserInfoValid: isNameValid,
      nameError: null,
      birthDateError: null,
    ));
  }

  // void _onUserUniversitySelected(UserUniversitySelectedEvent event, Emitter<AuthState> emit) async{
  //
  //   if (state.status.isLoading()) return;
  //
  //   final Map<String, String> errors = {};
  //
  //   if ((state.series != null && state.series!.isNotEmpty)|| (state.seriesNumber != null && state.seriesNumber!.isNotEmpty)) {
  //     if (state.series == null || state.series!.length != 2) {
  //       errors['series'] = 'Pasport seriyasi 2 ta harf bo\'lishi kerak';
  //     }
  //     if (state.seriesNumber == null || state.seriesNumber!.length != 7) {
  //       errors['seriesNumber'] = 'Pasport raqami 7 ta raqamdan iborat bo\'lishi kerak';
  //     }
  //   }
  //
  //   if (state.pnfl != null && state.pnfl!.isNotEmpty && state.pnfl!.length != 14) {
  //     errors['pnfl'] = 'PNFL 14 ta raqamdan iborat bo\'lishi kerak';
  //   }
  //
  //   if (errors.isNotEmpty) {
  //     emit(state.copyWith(
  //       status: BaseStatus.errorWithMessage(message: errors.values.first),
  //     ));
  //     return;
  //   }
  //
  //   emit(state.copyWith(
  //     status: BaseStatus.loading(),
  //   ));
  //
  //   try {
  //     final data = {
  //       'university_id': int.tryParse(event.university.code?.toString() ?? '0') ?? 0,
  //       'university_name': event.university.name,
  //     };
  //
  //     if (state.series != null && state.seriesNumber != null) {
  //       data['passport_series'] = '${state.series}${state.seriesNumber}';
  //     }
  //
  //     if (state.pnfl != null) {
  //       data['pinfl'] = state.pnfl.toString();
  //     }
  //     if(event.isCreate){
  //       final res = await _repository.createStudent(query: data);
  //
  //       if (res.success == true) {
  //         emit(state.copyWith(
  //           status: BaseStatus.completed(),
  //           isLogin: true,
  //         ));
  //       } else {
  //         emit(state.copyWith(
  //           status: BaseStatus.errorWithMessage(message: res.message),
  //         ));
  //       }
  //     }else{
  //       final res = await _repository.updateStudent(query: data);
  //
  //       if (res.success == true) {
  //         emit(state.copyWith(
  //           status: BaseStatus.completed(),
  //           isLogin: true,
  //         ));
  //       } else {
  //         emit(state.copyWith(
  //           status: BaseStatus.errorWithMessage(message: res.message),
  //         ));
  //       }
  //     }
  //
  //
  //   } catch (e, s) {
  //     log('Error selecting university: $e $s');
  //     emit(state.copyWith(
  //       status: BaseStatus.errorWithMessage(message: 'Xatolik yuz berdi'),
  //     ));
  //   }
  // }


  void _onOtpClear(OtpClearEvent event, Emitter<AuthState> emit) async{
    _pinController.clear();
    emit(state.copyWith(
      status: BaseStatus.initial(),
    ));

  }

  void _onUserPassport(UserPassportDataEvent event, Emitter<AuthState> emit) async{

    if(event.pnfl != null){
      emit(state.copyWith(
          pnfl: event.pnfl
      ));
      return;
    }

    if (event.series != null && event.isNumber ){
      emit(state.copyWith(
          seriesNumber:  event.series
      ));

    }else{
      emit(
          state.copyWith(
            series: event.series,
          )
      );
    }


  }
}