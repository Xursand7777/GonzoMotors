import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gonzo_motors/features/car_catalog/bloc/car_select_bloc.dart';

import '../bloc/car_select_event.dart';
import 'car_pick_card.dart';


class CarsList extends StatelessWidget {
  const CarsList({super.key});

  @override
  Widget build(BuildContext context) {
    // Можно оставить BlocBuilder, но BlocSelector точечно выдернет нужные поля
    return BlocBuilder<CarSelectBloc, CarSelectState>(
      builder: (context, state) {
        if (state is CarSelectLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is CarSelectError) {
          return Center(child: Text('Ошибка: ${state.message}'));
        }
        if (state is! CarSelectLoaded) {
          return const SizedBox.shrink();
        }

        return _CarsListView();
      },
    );
  }
}

class _CarsListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 🎯 Тянем только то, что нужно списку: карточки и выбранные id
    final cards = context.select<CarSelectBloc, List<dynamic>>(
          (b) => (b.state as CarSelectLoaded).cards,
    );
    final selectedIds = context.select<CarSelectBloc, Set<String>>(
          (b) => (b.state as CarSelectLoaded).selected,
    );

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: cards.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final car = cards[i];
        final selected = selectedIds.contains(car.id);
        return CarPickCard(
          car: car,
          selected: selected,
          onToggle: () =>
              context.read<CarSelectBloc>().add(CarSelectToggle(car.id)),
        );
      },
    );
  }
}
