

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/app_injection.dart';
import '../../core/route/route_names.dart';
import '../../core/theme/text_styles.dart';
import '../../features/auth/bloc/auth_bloc.dart';
import '../../features/profile/bloc/profile_bloc.dart';
import '../../gen/colors.gen.dart';
import '../../shared/keyboard_dismisser/keyboard_dismisser.dart';
import '../../shared/page_dot_Indicator/page_dot_indicator_shared.dart';
import '../success/success_page.dart';
import 'cubit/auth_cubit.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(),
        ),
        BlocProvider(
          create: (context) => AuthBloc(sl.get(), sl.get(), sl.get()),
        ),
      ],
      child: _AuthView()
    );
  }
}

class _AuthView extends StatelessWidget {
  const _AuthView();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();
    final padding = MediaQuery.paddingOf(context);
    return KeyboardDismisser(
      gestures: const [
        GestureType.onTap,
        GestureType.onPanUpdateDownDirection,
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthCubit, AuthPageState>(
            listenWhen: (previous, current) =>
            previous.currentPage != current.currentPage,
            listener: (context, state) {
              if (state.currentPage != 2) {
                FocusScope.of(context).unfocus();
              }
            },
          ),
          BlocListener<AuthBloc, AuthState>(
            listenWhen: (previous, current) =>
            previous.status != current.status,
            listener: (context, state) {
              if (state.resentOtpCode) {
                context.read<AuthCubit>().startResendTimer();
              }

              if (state.status.isSuccess()) {
                cubit.changeCurrentPage(cubit.state.currentPage + 1);
              } else if (state.status.isError()) {
                _showSnackBar(context, state.status.message);
              }
            },
          ),
          BlocListener<AuthBloc, AuthState>(
              listenWhen: (previous, current) =>
              previous.isLogin != current.isLogin,
              listener: (context, state) {
                context.read<ProfileBloc>().add(const GetProfileEvent());

                if (state.isLogin) {
                  if (cubit.state.currentPage != cubit.pages.length - 1) {
                    context.replaceNamed(RouteNames.success,
                        extra: SuccessNavigation.register);
                  } else {
                    context.replaceNamed(RouteNames.success);
                  }
                }
              }),
        ],
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) =>
              _onBackPress(didPop, result, context),
          child: Scaffold(
            body: Padding(
              padding: EdgeInsets.only(
                  top: padding.top + 16, bottom: padding.bottom),
              child: BlocListener<AuthCubit, AuthPageState>(
                listenWhen: (previous, current) =>
                previous.currentPage != current.currentPage,
                listener: (context, state) {
                  cubit.pageController.animateToPage(
                    state.currentPage,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInCubic,
                  );
                },
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: BlocBuilder<AuthCubit, AuthPageState>(
                        buildWhen: (previous, current) =>
                        previous.currentPage != current.currentPage,
                        builder: (context, state) {
                          final currentPage = state.currentPage;
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              BlocBuilder<AuthCubit, AuthPageState>(
                                builder: (context, state) {
                                  if (state.currentPage != 0) {
                                    return const SizedBox();
                                  }

                                  return Positioned(
                                    left: 0,
                                    child: IconButton(
                                      icon: const Icon(Icons.arrow_back),
                                      onPressed: () => context.pop(),
                                      color: ColorName.contentPrimary,
                                    ),
                                  );
                                },
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Qadam: ${currentPage + 1} /${cubit.pages.length}",
                                    style: AppTextStyles.bodyRegularTertiary
                                        .copyWith(
                                        color: ColorName.contentSecondary),
                                  ),
                                  const SizedBox(height: 8),
                                  PageDotIndicatorShared(
                                    controller: cubit.pageController,
                                    itemCount: cubit.pages.length,
                                    activeColor:
                                    ColorName.accentBrandNamePrimary,
                                    inactiveColor: ColorName.lineDivider,
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: PageView.builder(
                          onPageChanged: (index) {
                            context.read<AuthCubit>().changeCurrentPage(index);
                          },
                          controller: cubit.pageController,
                          itemCount: cubit.pages.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return cubit.pages[index];
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onBackPress(bool didPop, result, BuildContext context) {
    if (didPop) {
      return;
    }
    final cubit = context.read<AuthCubit>();

    final currentPage = cubit.state.currentPage;

    if (currentPage == 1) {
      context.read<AuthBloc>().add(const OtpClearEvent());
    } else if (currentPage == 2 || currentPage == 3) {
      return;
    }

    if (currentPage + 1 > 1) {
      cubit.changeCurrentPage(currentPage - 1);
      return;
    } else {
      context.pop();
    }
  }

  void _showSnackBar(BuildContext context, String? message) {
    if (message == null) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
        ),
        behavior: SnackBarBehavior.floating,
        padding: const EdgeInsets.all(16),
        backgroundColor: ColorName.red,
      ),
    );
  }

  void _backButtonPressed(AuthCubit cubit,BuildContext context) {

    final currentPage = cubit.state.currentPage;
    if (currentPage == 0) {
      context.pop();
      return;
    }else if (currentPage == 2 || currentPage ==3) {
      return;
    }

    cubit.changeCurrentPage(currentPage - 1);
  }
}