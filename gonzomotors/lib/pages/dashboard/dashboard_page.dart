import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gonzo_motors/pages/onboarding/onboarding_page.dart';
import '../../core/di/app_injection.dart';
import '../../core/services/deeplink_service.dart';
import '../../core/services/notification_service.dart';
import '../../gen/assets.gen.dart';
import '../car_catalog/car_catalog_page.dart';
import '../profile/profile_page.dart';
import 'cubit/dashboard_cubit.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardCubit(),
      child:  _DashboardView(sl<DeeplinkService>(), sl<NotificationService>()),
    );
  }
}

class _DashboardView extends StatefulWidget {
  final DeeplinkService deeplinkService ;
  final NotificationService notificationService ;
  const _DashboardView(this.deeplinkService,this.notificationService);

  @override
  State<_DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<_DashboardView> {

  @override
  void initState() {
    super.initState();
    // _setupDeeplinkHandlers();
    // _setupNotificationHandlers();
    widget.deeplinkService.initDeepLinkListener();
    widget.notificationService.initNotificationListener();
  }

  @override
  void dispose() {
    widget.deeplinkService.dispose();
    super.dispose();
  }

  // void _setupDeeplinkHandlers() {
  //   widget.deeplinkService.onProductView = (int discountId) {
  //     logger.debug('Discount detail view: $discountId');
  //     context.pushNamed(RouteNames.discountDetail, extra: discountId);
  //   };
  //
  //   widget.deeplinkService.onCustomAction = (Map<String, String> params) {
  //     logger.debug('Custom deeplink action: $params');
  //   };
  // }

  // void _setupNotificationHandlers() {
  //   widget.notificationService.onTapDiscount = (int discountId) {
  //     logger.debug('Notification tapped for discount: $discountId');
  //     context.pushNamed(RouteNames.discountDetail, extra: discountId);
  //   };
  //
  //   widget.notificationService.onTapData = (Map<String, dynamic> params) {
  //     logger.debug('Notification data tapped: $params');
  //   };
  // }


  @override
  Widget build(BuildContext context) {
    final barColor = Theme.of(context).bottomNavigationBarTheme;
    final currentIndex = context.select(
          (DashboardCubit cubit) => cubit.state.currentIndex,
    );
    return Scaffold(
        body: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            return IndexedStack(
              index: currentIndex,
              children: const [
                CarCatalogPage(),
                OnboardingPage(),
                ProfilePage(),
              ],
            );
          },
        ),
        bottomNavigationBar: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            return BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                context.read<DashboardCubit>().changeIndex(index);
              },
              currentIndex: state.currentIndex,
              items: [
                BottomNavigationBarItem(
                  icon: Assets.icons.mdMenu.image(
                    color: barColor.unselectedItemColor,
                    width: 24,
                    height: 24,
                  ),
                  activeIcon: Assets.icons.mdMenu.image(
                    color: barColor.selectedItemColor,
                    width: 24,
                    height: 24,
                  ),
                  label: 'Menu',
                ),
                BottomNavigationBarItem(
                  icon: Assets.icons.mdCatalog.image(
                    color: barColor.unselectedItemColor,
                    width: 24,
                    height: 24,
                  ),
                  activeIcon: Assets.icons.mdCatalog.image(
                    color: barColor.selectedItemColor,
                    width: 24,
                    height: 24,
                  ),
                  label: 'Catalog',
                ),
                BottomNavigationBarItem(
                  icon: Assets.icons.navigationLogo2.image(
                    color: barColor.unselectedItemColor,
                    width: 24,
                    height: 24,
                  ),
                  activeIcon: Assets.icons.navigationLogo2.image(
                    color: barColor.selectedItemColor,
                    width: 24,
                    height: 24,
                  ),
                  label: 'Main',
                ),
                BottomNavigationBarItem(
                  icon: Assets.icons.search.image(
                    color: barColor.unselectedItemColor,
                    width: 24,
                    height: 24,
                  ),
                  activeIcon: Assets.icons.search.image(
                    color: barColor.selectedItemColor,
                    width: 24,
                    height: 24,
                  ),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Assets.icons.profile.image(
                    color: barColor.unselectedItemColor,
                    width: 24,
                    height: 24,
                  ),
                  activeIcon: Assets.icons.profile.image(
                    color: barColor.selectedItemColor,
                    width: 24,
                    height: 24,
                  ),
                  label: 'Profile',
                ),
              ],
            );
          },
        ));
  }

}