import 'package:go_router/go_router.dart';
import 'package:gonzo_motors/core/route/route_names.dart';

import '../../main.dart';
import '../../pages/car_catalog_page/car_catalog_page.dart';

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