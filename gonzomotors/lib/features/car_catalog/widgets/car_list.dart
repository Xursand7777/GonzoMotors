import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gonzo_motors/features/car_catalog/bloc/car_catalog_bloc.dart';
import 'car_pick_card.dart';


class CarsList extends StatelessWidget {
  const CarsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CarCatalogBloc, CarCatalogState>(
      builder: (context, state) {
        return _CarsListView();
      },
    );
  }
}

class _CarsListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final cards = context.select<CarCatalogBloc, List<dynamic>>(
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
          retailPriceText: r"$92 000 – Цена с растаможкой",
          cipPriceText:  r"$77 000 – Цена CIP Tashkent",
        );
      },
    );
  }
}
