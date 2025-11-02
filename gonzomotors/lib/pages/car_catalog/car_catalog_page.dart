import 'package:flutter/material.dart';
import 'package:gonzo_motors/features/car_catalog/widgets/car_list.dart';
import '../../features/ads_banner/widgets/ads_banners.dart';
import '../../gen/assets.gen.dart';
import '../../shared/app_bar/app_bar_shared.dart';

class CarCatalogPage extends StatelessWidget {
  const CarCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
    return SelectCarsPageView();
  }
}

class SelectCarsPageView extends StatefulWidget {
  const SelectCarsPageView({super.key});


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
            width: MediaQuery.sizeOf(context).width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Assets.icons.logo.image(height: 40, width: 60),
                _notificationIcon(onTap: () {}),
              ],
            ),
          ),
        ],
      ),
      // floatingActionButton: CompareFab(onCompare: widget.onCompare),
      body: SafeArea(
        minimum: const EdgeInsets.only(bottom: 8),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: AdsBannerWidget(),
            ),
            const Expanded(
              child: CarsList(),
            ),
          ],
        ),
      ),
    );
  }
}