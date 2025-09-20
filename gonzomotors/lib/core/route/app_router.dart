import 'package:go_router/go_router.dart';
import 'package:gonzo_motors/core/route/route_names.dart';
import 'package:gonzo_motors/presentation/pages/select/select_cars_page.dart';

import '../../main.dart';
final GoRouter appRouter = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/home',
  observers: [],
  onException: (context, state, router) {
  },
  routes: [
      GoRoute(
        path: '/home',
        name: RouteNames.home,
        builder: (context, state) => const SelectCarsPage(),
      )
  ],
);