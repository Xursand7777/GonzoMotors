import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';
import '../data/models/car.dart';

class CarProductCard extends StatelessWidget {
  const CarProductCard({
    super.key,
    required this.car,
    this.onTap,
    this.onCompare,
    this.onFavorite,
    this.compareCount,
    this.isFavorite = false,
  });

  final CarModel car;
  final VoidCallback? onTap;
  final VoidCallback? onCompare;
  final VoidCallback? onFavorite;

  final int? compareCount;
  final bool isFavorite;

  String _formatPrice(int? price) {
    if (price == null) return '';
    final str = price.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      buffer.write(str[i]);
      if ((str.length - i - 1) % 3 == 0 && i != str.length - 1) {
        buffer.write(' ');
      }
    }
    return '\$$buffer';
  }

  String _getBrandLogo(String carName) {
    final name = carName.trim().toLowerCase();
    if (name.contains('zeekr')) {
      return 'assets/icons/zeekr_logo.png';
    } else if (name.contains('xiaomi')) {
      return 'assets/icons/xiamo.png';
    }
    return 'assets/icons/zeekr_logo.png';
  }

  @override
  Widget build(BuildContext context) {
    const radius = 14.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // logo слева, фиксированный размер
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(3),
                      child: Image.asset(
                        _getBrandLogo(car.name),
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.directions_car,
                          size: 14,
                          color: Color(0xFF202938),
                        ),
                      ),
                    ),
                    const Spacer(), // ← занимает всё свободное место
                    _ActionButtons(
                      compareCount: compareCount,
                      onCompare: onCompare,
                      onFavorite: onFavorite,
                      isFavorite: isFavorite,
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Car image (center)
                Expanded(
                  child: Center(
                    child: Image.network(
                      car.imageCardUrl,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.directions_car_filled,
                        size: 48,
                        color: Color(0xFF9A9A9A),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Title
                Text(
                  car.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 4),

                // Price row: big red + small hint
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatPrice(car.price),
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE81E0E),
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 2),
                      child: Text(
                        'цена с\nрастаможкой',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 7,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFE81E0E),
                          height: 1.1,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // CIP line
                Text(
                  '${_formatPrice(car.cipPrice)} CIP Tashkent',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    color: Color(0xFF797979),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.onCompare,
    required this.onFavorite,
    required this.compareCount,
    required this.isFavorite,
  });

  final VoidCallback? onCompare;
  final VoidCallback? onFavorite;
  final int? compareCount;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SquareIconButton(
          size: 24,
          background: const Color(0xFFEBEBEB),
          icon: Assets.icons.compare.image(
            width: 14,
            height: 14,
            color: const Color(0xFF202938),
          ),
          onTap: onCompare,
          badge: (compareCount != null && compareCount! > 0)
              ? compareCount!.toString()
              : null,
        ),
        const SizedBox(width: 10),
        _SquareIconButton(
          size: 24,
          background: const Color(0xFFEBEBEB),
          icon: Assets.icons.heart.image(
            width: 14,
            height: 14,
            color: isFavorite ? const Color(0xFFFF594C) : const Color(0xFF202938),
          ),
          onTap: onFavorite,
        ),
      ],
    );
  }
}

class _SquareIconButton extends StatelessWidget {
  const _SquareIconButton({
    required this.size,
    required this.background,
    required this.icon,
    this.onTap,
    this.badge,
  });

  final double size;
  final Color background;
  final Widget icon;
  final VoidCallback? onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(4),
          child: Ink(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(child: icon),
          ),
        ),
        if (badge != null)
          Positioned(
            right: -6,
            top: -6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: const BoxDecoration(
                color: Color(0xFFFF594C),
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
              child: Center(
                child: Text(
                  badge!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                    height: 1.0,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}



class CarProductCardShimmer extends StatelessWidget {
  const CarProductCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    const radius = 14.0;

    return Shimmer.fromColors(
      baseColor: ColorName.contentMuted,
      highlightColor: ColorName.contentSecondary,
      child: Container(
        decoration: BoxDecoration(
          color: ColorName.backgroundPrimary,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // top row: spacer + action buttons placeholders
              Row(
                children: const [
                  Spacer(),
                  _ShimmerSquare(size: 24, radius: 6),
                  SizedBox(width: 10),
                  _ShimmerSquare(size: 24, radius: 6),
                ],
              ),

              const SizedBox(height: 10),

              // image placeholder (expanded)
              Expanded(
                child: Center(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // title line
              const _ShimmerLine(height: 16, radius: 8, widthFactor: 0.75),

              const SizedBox(height: 10),

              // price row: big price + small hint
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  _ShimmerLine(height: 14, radius: 8, width: 90),
                  SizedBox(width: 10),
                  _ShimmerBlock(height: 22, width: 52, radius: 8),
                ],
              ),

              const SizedBox(height: 8),

              // CIP line
              const _ShimmerLine(height: 12, radius: 8, widthFactor: 0.6),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShimmerSquare extends StatelessWidget {
  final double size;
  final double radius;
  const _ShimmerSquare({required this.size, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class _ShimmerLine extends StatelessWidget {
  final double height;
  final double radius;
  final double? width;
  final double? widthFactor;

  const _ShimmerLine({
    required this.height,
    required this.radius,
    this.width,
    this.widthFactor,
  });

  @override
  Widget build(BuildContext context) {
    final w = width ??
        (MediaQuery.sizeOf(context).width *
            (widthFactor ?? 0.7)); // fallback
    return Container(
      height: height,
      width: w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class _ShimmerBlock extends StatelessWidget {
  final double height;
  final double width;
  final double radius;

  const _ShimmerBlock({
    required this.height,
    required this.width,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}