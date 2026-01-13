import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di/app_injection.dart';
import '../../core/route/route_names.dart';
import '../../core/theme/text_styles.dart';
import '../../gen/colors.gen.dart';
import 'package:go_router/go_router.dart';
import '../../shared/button/button_shared.dart';
import '../../shared/padding/padding_shared.dart';
import '../../shared/page_dot_Indicator/page_dot_indicator_shared.dart';
import 'cubit/onboarding_cubit.dart';




class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingCubit(sl.get()),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatefulWidget {
  const _OnboardingView();

  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<_OnboardingView> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OnboardingCubit>();
    return MultiBlocListener(
      listeners: [
        BlocListener<OnboardingCubit, OnboardingState>(
          listener: (context, state) {
            if (state.currentPage == _pageController.page?.round()) {
              return;
            }

            _pageController.animateToPage(
              state.currentPage,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
        ),
        BlocListener<OnboardingCubit, OnboardingState>(
          listenWhen: (previous, current) =>
          previous.isFinished != current.isFinished,
          listener: (context, state) {
            if (state.isFinished) {
              context.goNamed(RouteNames.auth);
            }
          },
        ),
      ],
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                itemBuilder: (context, index) {
                  return Image.asset(
                    cubit.state.pagesData[index].imagePath,
                    fit: BoxFit.cover,
                  );
                },
                itemCount: cubit.state.pagesData.length,
                onPageChanged: (value) => cubit.changePage(value),
                controller: _pageController,
                scrollDirection: Axis.horizontal,
              ),
            ),
            ColoredBox(
              color: ColorName.contentInverse,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 32.0, horizontal: 32),
                child: Column(
                  children: [
                    BlocBuilder<OnboardingCubit, OnboardingState>(
                      builder: (context, state) {
                        final data = state.pagesData[state.currentPage];
                        return Column(
                          children: [
                            Text(
                              data.title,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.headlineSemiboldSecondary,
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Text(
                              data.description,
                              style: AppTextStyles.specialBodyMediumPrimary,
                              textAlign: TextAlign.center,

                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    PageDotIndicatorShared(
                        controller: _pageController,
                        itemCount: cubit.state.pagesData.length),
                    const SizedBox(
                      height: 24,
                    ),
                    BlocBuilder<OnboardingCubit, OnboardingState>(
                      builder: (context, state) {
                        final isLastPage = state.currentPage ==
                            cubit.state.pagesData.length - 1;

                        return ButtonSharedWidget.auth(
                          text:  isLastPage ? 'Moshinalarni koʻrish' :'Davom etish',
                          onTap: () => _onTap(context),
                        );
                      },
                    ),
                    PaddingShared.bottom(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTap(BuildContext context) {
    context.read<OnboardingCubit>().nextPage();
  }
}


