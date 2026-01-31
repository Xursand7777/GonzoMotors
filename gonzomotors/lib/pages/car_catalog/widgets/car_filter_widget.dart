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


class CarFilterWidget extends StatelessWidget {
  final bool isLoading;
  const CarFilterWidget({super.key, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const CarFilterShimmer();
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

class CarFilterShimmer extends StatelessWidget {
  const CarFilterShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF2A2A2A)
        : const Color(0xFFE9E9E9);

    final highlight = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF3A3A3A)
        : const Color(0xFFF5F5F5);

    return SizedBox(
      height: 100,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          return Column(
            children: [
              _ShimmerBox(
                width: 64,
                height: 64,
                radius: 12,
                baseColor: base,
                highlightColor: highlight,
              ),
              const SizedBox(height: 6),
              _ShimmerBox(
                width: 44,
                height: 12,
                radius: 6,
                baseColor: base,
                highlightColor: highlight,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final double radius;
  final Color baseColor;
  final Color highlightColor;

  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.radius,
    required this.baseColor,
    required this.highlightColor,
  });

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final t = _controller.value; // 0..1
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (rect) {
            // градиент “пробегает” слева направо
            final dx = rect.width * (t * 2 - 1); // -width..+width
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: const [0.2, 0.5, 0.8],
              transform: _SlideGradientTransform(dx),
            ).createShader(rect);
          },
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: widget.baseColor,
              borderRadius: BorderRadius.circular(widget.radius),
            ),
          ),
        );
      },
    );
  }
}

class _SlideGradientTransform extends GradientTransform {
  final double dx;
  const _SlideGradientTransform(this.dx);

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(dx, 0.0, 0.0);
  }
}

