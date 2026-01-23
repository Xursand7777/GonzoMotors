import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gonzo_motors/features/car_catalog/bloc/car_catalog_bloc.dart';
import '../../../pages/car_detail/car_detail_page.dart';
import '../../car_detail/data/repository/car_detail_repository.dart';
import '../data/models/car.dart';
import 'car_pick_card.dart';


class CarsList extends StatelessWidget {
  const CarsList({super.key});


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CarCatalogBloc, CarCatalogState>(
      builder: (context, state) {
        if (state.status.isLoading()) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status.isError()) {
          return Center(
            child: Text(
              state.status.message ?? "Ошибка загрузки",
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (state.cars.isEmpty) {
          return const Center(child: Text("Машины не найдены"));
        }
        return _CarsListView();
      },
    );
  }

}

class _CarsListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final cards = context.select<CarCatalogBloc, List<CarModel>>(
          (b) => (b.state).cars,
    );

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.94,
      ),
      itemCount: cards.length,
      itemBuilder: (context, i) {
        final car = cards[i];
        return CarProductCard(
          car: car,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CarDetailPage(
                  modelId: car.modelId,
                  initialCarId: car.id,
                  repository: context.read<CarDetailRepository>(),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
