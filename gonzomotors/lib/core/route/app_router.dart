import 'package:go_router/go_router.dart';
import 'package:gonzo_motors/core/route/route_names.dart';
import 'package:gonzo_motors/pages/onboarding/onboarding_page.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../main.dart';
import '../../pages/connection_check/connection_check_page.dart';
import '../../pages/dashboard/dashboard_page.dart';
import '../../pages/phone_register/phone_register_page.dart';
import '../../pages/profile/profile_page.dart';
import '../../pages/splash/splash_page.dart';
import '../../pages/success/success_page.dart';
import '../../pages/verification/verification_page.dart';
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
        path: '/onboarding',
    name: RouteNames.onboarding,
    builder: (context, state) => const OnboardingPage()
    ),
    GoRoute(
      path: '/phone-register',
      name: 'phone_register',
      builder: (_, __) => const PhoneRegisterPage(),
    ),
    GoRoute(
      path: '/verification',
      name: RouteNames.verification,
      builder: (context, state) {
        final phone = state.extra as String;
        return VerificationPage(phone: phone);
      },
    ),
    GoRoute(
      path: '/profile',
      name: RouteNames.profile,
      builder: (_, __) => const ProfilePage(),
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