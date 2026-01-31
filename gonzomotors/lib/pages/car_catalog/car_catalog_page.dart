import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../core/network/refreshable_page_mixin.dart';
import '../../features/ads_banner/bloc/ads_banner_bloc.dart';
import '../../features/ads_banner/widgets/ads_banners.dart';
import '../../features/car_catalog/bloc/car_catalog_bloc.dart';
import '../../gen/colors.gen.dart';
import '../../pages/car_catalog/widgets/car_filter_widget.dart';
import '../../gen/assets.gen.dart';
import '../../shared/app_bar/app_bar_shared.dart';
import 'package:gonzo_motors/features/car_catalog/widgets/car_list.dart';

import '../../shared/custom_footer/custom_footer_shared.dart';
import 'cubit/car_catalog_cubit.dart';

class CarCatalogPage extends StatelessWidget {
  const CarCatalogPage({super.key});

  @override
  Widget build(BuildContext context) => const SelectCarsPageView();
}

class SelectCarsPageView extends StatefulWidget {
  const SelectCarsPageView({super.key});

  @override
  State<SelectCarsPageView> createState() => _SelectCarsPageViewState();
}

class _SelectCarsPageViewState extends State<SelectCarsPageView> with RefreshablePageMixin {
  late final RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);

    // начальная загрузка
    context.read<CarCatalogBloc>().add(const GetCarsEvent());
    context.read<AdsBannerBloc>().add(const GetBannersEvent());
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _onRefreshAll() {
     context.read<CarCatalogCubit>().reset();
     context.read<CarCatalogBloc>().add(const GetCarsEvent());
     context.read<AdsBannerBloc>().add(const GetBannersEvent());
    // context.read<FilterBloc>().add(const GetFiltersEvent());
  }

  @override
  void onConnectionRestored() {
    _onRefreshAll();
  }

  void _loadMoreCars() {
    final cubit = context.read<CarCatalogCubit>();
    final canLoadMore = cubit.state.visibleCars.length < cubit.state.cars.length;

    if (!canLoadMore) {
      _refreshController.loadNoData();
      return;
    }

    cubit.addCars();
    _refreshController.loadComplete();
  }

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

      body: SafeArea(
        minimum: const EdgeInsets.only(bottom: 8),
        child: BlocConsumer<CarCatalogBloc, CarCatalogState>(
          listener: (context, state) {
            if (state.status.isError()) {
              _refreshController.refreshFailed();
              return;
            }

            // когда пришли новые машины — прокинуть в cubit
            if (state.status.isSuccess()) {
              context.read<CarCatalogCubit>().setCars(state.cars);
            }

            if (!state.status.isLoading()) {
              _refreshController.refreshCompleted();
              _refreshController.loadComplete();
            }
          },

          builder: (context, state) {
            final cubitState = context.watch<CarCatalogCubit>().state;
            final canLoadMore = cubitState.visibleCars.length < cubitState.cars.length;
            final paddingTop = MediaQuery.paddingOf(context).top;
            final isLoading = state.status.isLoading();
            return SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              enablePullUp: canLoadMore,
              onRefresh: _onRefreshAll,
              header: const WaterDropHeader(),
              onLoading: _loadMoreCars,
              footer: const CustomFooterShared(noDataText: ""),
              // ✅ ОДИН общий скролл на всю страницу
              child: CustomScrollView(
                slivers: [
                  PinnedHeaderSliver(
                    child: ColoredBox(
                      color: ColorName.surfacePrimary,
                      child: SizedBox(
                        height: paddingTop,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 10)),
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: AdsBannerWidget(),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 12),
                      child: CarFilterWidget(isLoading: isLoading),
                    ),
                  ),

                  // ✅ список как sliver (внутри CarsList)
                  CarsListSliver(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
