import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../pages/car_catalog/cubit/car_catalog_cubit.dart';
import '../../../pages/car_detail/car_detail_page.dart';
import '../../ads_banner/bloc/ads_banner_bloc.dart';
import '../data/models/car.dart';
import 'car_pick_card.dart';
import 'package:gonzo_motors/features/car_catalog/bloc/car_catalog_bloc.dart';

class CarsListSliver extends StatelessWidget {


  const CarsListSliver({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CarCatalogBloc>().state;
    // Берём "видимые" машины из cubit (для load-more по кускам)
    final visibleCars = context.select<CarCatalogCubit, List<CarModel>>(
          (c) => c.state.visibleCars,
    );

    // Если cubit ещё не синхронизирован (например, первый билд) — покажем bloc.cars
    final carsToShow = visibleCars.isNotEmpty ? visibleCars : state.cars;

    // Пустой стартовый лоадер
    if (state.status.isLoading()) {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.78,
          ),
          delegate: SliverChildBuilderDelegate(
                (context, i) => const CarProductCardShimmer(),
            childCount: 6,
          ),
        ),
      );
    }


    // Ошибка, если вообще ничего не было загружено
    if (state.status.isError() && state.cars.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.wifi_off_rounded,
                  size: 48,
                  color: Colors.redAccent,
                ),
                const SizedBox(height: 12),
                Text(
                  state.status.message ?? "Ошибка загрузки",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                ElevatedButton.icon(
                  onPressed: () {
                    // 🔁 повторная загрузка
                    context.read<CarCatalogBloc>().add(const GetCarsEvent());
                    context.read<AdsBannerBloc>().add(const GetBannersEvent());
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text("Обновить"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }


    // Пусто (нет машин)
    if (state.cars.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: Text("Машины не найдены")),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.78,
        ),
        delegate: SliverChildBuilderDelegate(
              (context, i) {
            final car = carsToShow[i];
            return CarProductCard(
              car: car,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CarDetailPage(
                      modelId: car.modelId,
                      initialCarId: car.id,
                    ),
                  ),
                );
              },
            );
          },
          childCount: carsToShow.length,
        ),
      ),
    );
  }
}
