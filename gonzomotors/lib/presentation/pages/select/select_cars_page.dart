import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/models/car_info.dart' as model;
import '../../bloc/select/car_select_bloc.dart';
import '../compare/compare_page.dart';


class SelectCarsPage extends StatelessWidget {
  const SelectCarsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Выберите 2 авто')),
      floatingActionButton: BlocBuilder<CarSelectBloc, CarSelectState>(
        builder: (context, state) {
          final enabled = (state is CarSelectLoaded) && state.canCompare;
          return FloatingActionButton.extended(
            onPressed: enabled ? () {
              context.read<CarSelectBloc>().add(CarSelectCompare());
            } : null,
            icon: const Icon(Icons.compare_arrows),
            label: Text('Compare${state is CarSelectLoaded ? ' (${state.selected.length}/2)' : ''}'),
          );
        },
      ),
      body: BlocConsumer<CarSelectBloc, CarSelectState>(
        listenWhen: (prev, next) =>
        next is CarSelectLoaded && (next.compareA != null && next.compareB != null),
        listener: (context, state) {
          final s = state as CarSelectLoaded;
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => ComparePage.prefilled(a: s.compareA!, b: s.compareB!)),
          );
        },
        builder: (context, state) {
          if (state is CarSelectLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CarSelectError) {
            return Center(child: Text('Ошибка: ${state.message}'));
          }
          final s = state as CarSelectLoaded;
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: s.cards.length,
            itemBuilder: (_, i) {
              final c = s.cards[i];
              final selected = s.selected.contains(c.id);
              return _CarPickCard(
                car: c,
                selected: selected,
                onToggle: () => context.read<CarSelectBloc>().add(CarSelectToggle(c.id)),
              );
            },
          );
        },
      ),
    );
  }
}


class _CarPickCard extends StatelessWidget {
  const _CarPickCard({
    required this.car,
    required this.selected,
    required this.onToggle,
  });

  final model.CarInfo car;
  final bool selected;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final border = RoundedRectangleBorder(borderRadius: BorderRadius.circular(16));

    return Material(
      color: cs.surface,
      elevation: 1,
      shape: border,
      child: InkWell(
        onTap: onToggle,
        customBorder: border,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 110,
                      height: 72,
                      child: Image.asset(car.imageUrl, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${car.name} (${car.year})',
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 18, runSpacing: 10,
                          children: const [],
                        ),
                        Wrap(
                          spacing: 18, runSpacing: 10,
                          children: [
                            _Spec(icon: Icons.directions_car_outlined, labelBuilder: (c) => c.bodyType),
                            _Spec(icon: Icons.electric_bolt, labelBuilder: (c) => c.powertrain),
                            _Spec(icon: Icons.speed, labelBuilder: (c) => '${c.topSpeedKmh} km/h'),
                            _Spec(icon: Icons.precision_manufacturing_outlined, labelBuilder: (c) => '${c.horsepower} hp'),
                          ].map((w) => Builder(builder: (_) => w.copyWith(car))).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 6, right: 6,
              child: InkWell(
                onTap: onToggle,
                borderRadius: BorderRadius.circular(20),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: selected ? Colors.green : cs.primary,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(.12), blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  child: Icon(selected ? Icons.check : Icons.add, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Spec extends StatelessWidget {
  const _Spec({required this.icon, required this.labelBuilder, model.CarInfo? car}) : _car = car;
  final IconData icon;
  final String Function(model.CarInfo) labelBuilder;
  final model.CarInfo? _car;

  _Spec copyWith(model.CarInfo car) => _Spec(icon: icon, labelBuilder: labelBuilder, car: car);

  @override
  Widget build(BuildContext context) {
    final car = _car!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.grey.shade600),
        const SizedBox(width: 6),
        Text(labelBuilder(car), style: TextStyle(color: Colors.grey.shade800)),
      ],
    );
  }
}
