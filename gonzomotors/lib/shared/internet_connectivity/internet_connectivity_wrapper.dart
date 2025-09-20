import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/route/route_names.dart';
import '../../main.dart';
import 'bloc/connection_checker_bloc.dart';

class InternetConnectivityWrapper extends StatelessWidget {
  final Widget child;
  const InternetConnectivityWrapper({required this.child, super.key});

  void _handleInternetConnectionChanged(bool isConnected) {
    if (!isConnected) {
      navigatorKey.currentContext!.pushNamed(RouteNames.offline);
    } else {
      final currentRoute = GoRouter.of(navigatorKey.currentContext!)
          .routerDelegate
          .currentConfiguration
          .last
          .route
          .name;
      if (currentRoute == RouteNames.offline) {
        navigatorKey.currentContext!.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectionCheckerBloc, ConnectionCheckerState>(
      listener: (context, state) =>
          _handleInternetConnectionChanged(state.isConnected),
      child: child,
    );
  }
}