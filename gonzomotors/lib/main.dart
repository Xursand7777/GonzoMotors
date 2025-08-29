import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/app_injection.dart';
import 'core/theme/app_theme.dart';

import 'domain/usecases/find_details_by_specs.dart';
import 'presentation/bloc/compare/compare_bloc.dart';
import 'presentation/bloc/select/car_select_bloc.dart';
import 'presentation/pages/select/select_cars_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system, // системная светлая/тёмная
        // Оборачиваем всё в CupertinoTheme, чтобы iOS-виджеты брали цвета/шрифты
        builder: (context, child) => CupertinoTheme(
          data: AppTheme.cupertinoFrom(context),
          child: child!,
        ),
        home: const SelectCarsPage(),
      ),
    );
  }
}
