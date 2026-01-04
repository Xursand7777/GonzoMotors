part of 'onboarding_cubit.dart';

class OnboardingState extends Equatable {
  final int currentPage;
  final bool isFinished ;
  final List<OnboardingData> pagesData;

  const OnboardingState({
    this.currentPage = 0,
    this.pagesData = const [],
    this.isFinished = false,
  });

  OnboardingState copyWith({
    int? currentPage,
    List<OnboardingData>? pagesData,
    bool? isFinished,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      pagesData: pagesData ?? this.pagesData,
      isFinished: isFinished ?? this.isFinished,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    currentPage,
    pagesData,
    isFinished,
  ];
}

class OnboardingData {
  final String title;
  final String description;
  final String imagePath;

  const OnboardingData({
    required this.title,
    required this.description,
    this.imagePath = '',
  });
}
