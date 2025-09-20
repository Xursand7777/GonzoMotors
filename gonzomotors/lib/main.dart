import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_observer.dart';

import 'core/di/app_injection.dart';
import 'core/bloc/observer.dart';
import 'core/log/talker_logger.dart';
import 'core/theme/app_theme.dart';

import 'domain/usecases/find_details_by_specs.dart';
import 'presentation/bloc/compare/compare_bloc.dart';
import 'presentation/bloc/select/car_select_bloc.dart';

import 'core/route/app_router.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MultiBlocObserver([
    TalkerBlocObserver(talker: logger),
  ]);

  await initInjection();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CarSelectBloc>(
          create: (_) => CarSelectBloc(sl(), sl())..add(CarSelectLoad()),
        ),
        BlocProvider<CompareBloc>(
          create: (_) => CompareBloc(sl<FindDetailsBySpecs>()),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system, // системная светлая/тёмная
        // Оборачиваем всё в CupertinoTheme, чтобы iOS-виджеты брали цвета/шрифты
        builder: (context, child) => CupertinoTheme(
          data: AppTheme.cupertinoFrom(context),
          child: child!,
        ),
      ),
    );
  }
}
