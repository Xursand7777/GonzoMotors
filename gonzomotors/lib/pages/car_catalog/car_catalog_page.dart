import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gonzo_motors/features/car_catalog/widgets/car_list.dart';
import '../../../features/car_catalog/widgets/compare_fab.dart';
import '../../gen/assets.gen.dart';
import '../../shared/app_bar/app_bar_shared.dart';
import '../compare/compare_page.dart';

class SelectCarsPage extends StatelessWidget {
  const SelectCarsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;

    void openCompare(dynamic a, dynamic b) {
      final route = (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS)
          ? CupertinoPageRoute(builder: (_) => ComparePage.prefilled(a: a, b: b))
          : MaterialPageRoute(builder: (_) => ComparePage.prefilled(a: a, b: b));
      Navigator.of(context).push(route);
    }
    return SelectCarsPageView(onCompare: openCompare);
  }
}

class SelectCarsPageView extends StatefulWidget {
  const SelectCarsPageView({super.key, required this.onCompare});
  final void Function(dynamic a, dynamic b) onCompare;

  @override
  State<SelectCarsPageView> createState() => _SelectCarsPageViewState();
}

class _SelectCarsPageViewState extends State<SelectCarsPageView> {
  Widget _notificationIcon({VoidCallback? onTap}) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(100),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Assets.icons.notification.image(width: 24, height: 24),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarShared(
        showBack: false,
        actions: [
          SizedBox(
            width: MediaQuery.sizeOf(context).width - 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Assets.icons.logo.image(height: 40, width: 120),
                _notificationIcon(onTap: () {}),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: CompareFab(onCompare: widget.onCompare),
      body: const SafeArea(
        minimum: EdgeInsets.only(bottom: 8),
        child: CarsList(),
      ),
    );
  }
}