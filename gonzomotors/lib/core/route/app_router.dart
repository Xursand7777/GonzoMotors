import 'package:go_router/go_router.dart';
import 'package:gonzo_motors/core/route/route_names.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../main.dart';
import '../../pages/car_catalog/car_catalog_page.dart';
import '../../pages/connection_check/connection_check_page.dart';
import '../../pages/dashboard/dashboard_page.dart';
import '../../pages/splash/splash_page.dart';
import '../log/talker_logger.dart';

final GoRouter appRouter = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/splash',
  observers: [TalkerRouteObserver(logger)],
  onException: (context, state, router) {
    router.goNamed(RouteNames.home);
  },
  routes: [
    GoRoute(
      path: '/splash',
      name: RouteNames.splash,
      builder: (context, state) => const SplashPage(),
      // redirect: (context, state) => '/',
    ),
      GoRoute(
        path: '/home',
        name: RouteNames.home,
        builder: (context, state) => const SelectCarsPage(),
      ),
    // GoRoute(
    //     path: '/dashboard',
    //     name: RouteNames.dashboard,
    //     builder: (_, __) => const DashboardPage()),
    GoRoute(
      path: '/__offline__',
      name: RouteNames.offline,
      builder: (context, state) => const OfflinePage(),
    ),
  ],
);