import 'package:go_router/go_router.dart';
import 'package:gonzo_motors/core/route/route_names.dart';
import 'package:gonzo_motors/pages/auth/auth_page.dart';
import 'package:gonzo_motors/pages/onboarding/onboarding_page.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../main.dart';
import '../../pages/car_detail/car_detail_page.dart';
import '../../pages/catalog/catalog_page.dart';
import '../../pages/connection_check/connection_check_page.dart';
import '../../pages/dashboard/dashboard_page.dart';
import '../../pages/profile/profile_page.dart';
import '../../pages/splash/splash_page.dart';
import '../../pages/success/success_page.dart';
import '../log/talker_logger.dart';




final GoRouter appRouter = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/onboarding',
  observers: [TalkerRouteObserver(logger)],
  onException: (context, state, router) {
    router.goNamed(RouteNames.dashboard);
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
        builder: (context, state) => const DashboardPage(),
      ),
    GoRoute(
        path: '/dashboard',
        name: RouteNames.dashboard,
        builder: (_, __) => const DashboardPage()),
    GoRoute(
      path: '/__offline__',
      name: RouteNames.offline,
      builder: (context, state) => const OfflinePage(),
    ),
    GoRoute(
      path: '/auth',
      name: RouteNames.auth,
      builder: (_, __) => const AuthPage(),
    ),
    GoRoute(
        path: '/onboarding',
    name: RouteNames.onboarding,
    builder: (context, state) => const OnboardingPage()
    ),
    GoRoute(
      path: '/profile',
      name: RouteNames.profile,
      builder: (_, __) => const ProfilePage(),
    ),
    GoRoute(
      path: '/car-detail',
      name: RouteNames.carDetail,
      builder: (_, __) => const CarDetailPage(),
    ),
    GoRoute(
      path: '/catalog',
      name: RouteNames.catalog,
      builder: (_, __) => const CatalogPage(),
    ),
    GoRoute(
      path: '/success',
      name: RouteNames.success,
      builder: (_, state) {
        if (state.extra is SuccessNavigation) {
          final args = state.extra as SuccessNavigation;
          return SuccessPage(
            navigation: args,
          );
        }
        return const SuccessPage();
      },
    ),
  ],
);