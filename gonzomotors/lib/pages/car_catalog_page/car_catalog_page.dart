import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gonzo_motors/features/car_catalog/widgets/car_list.dart';
import '../../../features/car_catalog/widgets/compare_fab.dart';
import '../compare_page/compare_page.dart';

class SelectCarsPage extends StatelessWidget {
  const SelectCarsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;

    void openCompare(a, b) {
      final route = (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS)
          ? CupertinoPageRoute(builder: (_) => ComparePage.prefilled(a: a, b: b))
          : MaterialPageRoute(builder: (_) => ComparePage.prefilled(a: a, b: b));

      Navigator.of(context).push(route);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Выберите 2 авто'),
        // адаптивная высота/тенюшка уже handled Material3; цветов не хардкодим
      ),
      // FAB у тебя уже адаптивный внутри (CompareFab)
      floatingActionButton: CompareFab(onCompare: openCompare),
      body: const SafeArea( // чуть лучше на iOS с жестами/выемками
        minimum: EdgeInsets.only(bottom: 8),
        child: CarsList(),
      ),
    );
  }
}
