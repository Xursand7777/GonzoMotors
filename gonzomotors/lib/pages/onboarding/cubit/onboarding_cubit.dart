import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/local/onboarding_service.dart';
import '../../../gen/assets.gen.dart';
part 'onboarding_state.dart';


class OnboardingCubit extends Cubit<OnboardingState> {
  final OnboardingService _onboardingService;
  OnboardingCubit(this._onboardingService) : super(const OnboardingState()){
    _initializePagesData();
  }
  void _initializePagesData() {
    emit(state.copyWith(pagesData: pagesData));
  }

  void nextPage() {
    if (state.currentPage < state.pagesData.length - 1) {
      emit(state.copyWith(currentPage: state.currentPage + 1));
    }else {
      _onboardingService.setOnboardingCompleted(true);
      emit(state.copyWith(isFinished: true));
    }
  }

  void previousPage() {
    if (state.currentPage > 0) {
      emit(state.copyWith(currentPage: state.currentPage - 1));
    }
  }

  void changePage(int pageIndex) {
    if (pageIndex >= 0 && pageIndex < state.pagesData.length) {
      emit(state.copyWith(currentPage: pageIndex));
    }
  }
}

final pagesData = [
  OnboardingData(
    title: 'Moomkin — barcha chegirmalar bir joyda',
    description: 'Hududingizdagi barcha aksiya, chegirma va maxsus takliflarni aniq, tez va oson toping.\n',
    imagePath:  '',
  ),
  OnboardingData(
    title: 'Kerakli chegirmani bir zumda toping',
    description: 'Mahsulot, xizmat yoki kompaniya nomini yozing — eng mos aksiya va takliflar darhol chiqadi.',
    imagePath:  '',
  ),
  OnboardingData(
    title: 'Kategoriyalar bo‘yicha qulay saralash',
    description: 'Oziq-ovqatdan texnikagacha — sizga kerak bo‘lgan barcha bo‘limlar bo‘yicha yangi chegirmalarni kuzating.',
    imagePath:  '',
  ),
  OnboardingData(
    title: 'Sevimli kompaniyalardan maxsus takliflar',
    description: 'Mashhur brend va do‘konlarning hozirgi chegirmalarini ko‘rib boring, yangi aksiya chiqsa xabar oling.',
    imagePath:  '',
  ),
];