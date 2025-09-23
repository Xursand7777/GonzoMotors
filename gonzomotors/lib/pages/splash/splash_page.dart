

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/route/route_names.dart';
import '../../features/connection_checker/bloc/connection_checker_bloc.dart';
import '../../gen/assets.gen.dart';
import 'bloc/splash_cubit.dart';
import 'bloc/splash_state.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit(),
      child: const SplashView(),
    );
  }
}

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return BlocListener<ConnectionCheckerBloc, ConnectionCheckerState>(
      listener: (context, state) {
        if (state.isConnected) {
          context.read<SplashCubit>().startTimer();
        }
      },
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          final isConnected =
              context.read<ConnectionCheckerBloc>().state.isConnected;
          if (isConnected && state is SplashFinishedState) {
            context.goNamed(RouteNames.home);
          }
        },
        child: Scaffold(
          body: Center(
            child: Assets.icons.splash.image(width: screenSize.width),
          ),
        ),
      ),
    );
  }
}
