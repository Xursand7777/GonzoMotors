import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gonzomotors/presentation/bloc/compare/compare_bloc.dart';
import 'package:gonzomotors/presentation/bloc/select/car_select_bloc.dart';
import 'core/app_injection.dart';
import 'domain/usecases/find_details_by_specs.dart';
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
      child: const MaterialApp(
        home: SelectCarsPage(),
      ),
    );
  }
}

