import 'package:flutter/material.dart';
import 'package:gonzo_motors/features/car_catalog/data/models/filter_model.dart';
import '../../../gen/assets.gen.dart';

/// --- Градиенты для фильтров ---
const electroGradient = RadialGradient(
  colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
  center: Alignment.center,
  radius: 1.0,
);

const hybridGradient = LinearGradient(
  colors: [Color(0xFF00C6FF), Color(0xFF6DD400)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const premiumGradient = RadialGradient(
  colors: [Color(0xFFF5E6A1), Color(0xFFE8B510)],
  center: Alignment.center,
  radius: 1.0,
);

const popularGradient = RadialGradient(
  colors: [Color(0xFFFF416C), Color(0xFFFF4B2B)],
  center: Alignment.center,
  radius: 1.0,
);

const availableGradient = RadialGradient(
  colors: [Color(0xFF77CA99), Color(0xFF00B05E)],
  center: Alignment.center,
  radius: 1.0,
);

/// --- Список фильтров ---
final filters = [
  CarFilterModel(
    id: 1,
    name: 'Электро',
    icon: Assets.icons.electro.image(width: 54, height: 54, color: Colors.white),
    backgroundGradient: electroGradient,
    queryKey: 'electro',
    value: 'electro',
  ),
  CarFilterModel(
    id: 2,
    name: 'Гибрид',
    icon: Assets.icons.hybrid.image(width: 54, height: 54, color: Colors.white),
    backgroundGradient: hybridGradient,
    queryKey: 'hybrid',
    value: 'hybrid',
  ),
  CarFilterModel(
    id: 3,
    name: 'Премиум',
    icon: Assets.icons.premium.image(width: 54, height: 54, color: Colors.white),
    backgroundGradient: premiumGradient,
    queryKey: 'premium',
    value: 'premium',
  ),
  CarFilterModel(
    id: 4,
    name: 'Популярные',
    icon: Assets.icons.popular.image(width: 54, height: 54, color: Colors.white),
    backgroundGradient: popularGradient,
    queryKey: 'popular',
    value: 'popular',
  ),
  CarFilterModel(
    id: 5,
    name: 'Наличии',
    icon: Assets.icons.available.image(width: 54, height: 54, color: Colors.white),
    backgroundGradient: availableGradient,
    queryKey: 'available',
    value: 'available',
  ),
];

/// --- Виджет фильтров ---
class CarFilterWidget extends StatelessWidget {
  const CarFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final f = filters[index];
          return Column(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: f.backgroundGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: f.icon),
              ),
              const SizedBox(height: 6),
              Text(
                f.name,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
