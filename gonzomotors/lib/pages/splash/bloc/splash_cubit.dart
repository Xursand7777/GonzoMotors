
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gonzo_motors/pages/splash/bloc/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitialState()) {
    startTimer();
  }

  void startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      emit(SplashFinishedState());
    });
  }
}
