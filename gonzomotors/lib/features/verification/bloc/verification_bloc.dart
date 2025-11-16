import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gonzo_motors/core/bloc/base_status.dart';
import 'package:gonzo_motors/core/log/talker_logger.dart';
import 'package:equatable/equatable.dart';
import '../../../core/storage/flutter_storage.dart';
import '../data/repository/verification_repository.dart';

part 'verification_event.dart';
part 'verification_state.dart';

class VerificationBloc extends Bloc<VerificationEvent, VerificationState> {
  final VerificationRepository repository;
  final String phoneNumber;

  VerificationBloc({
    required this.repository,
    required this.phoneNumber,
  }) : super(const VerificationState()) {
    on<VerificationCodeChanged>(_onCodeChanged);
    on<VerificationSubmitted>(_onSubmitted);
  }

  void _onCodeChanged(
      VerificationCodeChanged event,
      Emitter<VerificationState> emit,
      ) {
    emit(
      state.copyWith(
        code: event.code,
        status: const BaseStatus(type: StatusType.initial),
        errorMessage: null,
      ),
    );
  }

  Future<void> _onSubmitted(
      VerificationSubmitted event,
      Emitter<VerificationState> emit,
      ) async {
    if (state.code.isEmpty || state.code.length < 6) {
      emit(
        state.copyWith(
          status: const BaseStatus(type: StatusType.error),
          errorMessage: 'Введите 6-значный код',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: const BaseStatus(type: StatusType.loading),
        errorMessage: null,
      ),
    );

    try {
      final response = await repository.loginVerification(
        phoneNumber: phoneNumber,
        code: state.code,
      );

      final result = response.data['result'];
      final accessToken = result['accessToken'];
      final refreshToken = result['refreshToken'];

      await AuthStorage.saveTokens(accessToken, refreshToken: refreshToken);

      emit(
        state.copyWith(
          status: const BaseStatus(type: StatusType.success),
        ),
      );
    } catch (ex, st) {
      logger.error("Ошибка при верификации", ex, st);
      emit(
        state.copyWith(
          status: const BaseStatus(type: StatusType.error),
          errorMessage:
          'Произошла ошибка при верификации. Попробуйте снова.',
        ),
      );
    }
  }

}
