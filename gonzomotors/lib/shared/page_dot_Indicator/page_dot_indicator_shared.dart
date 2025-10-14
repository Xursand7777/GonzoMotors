import 'package:flutter/material.dart';

import '../../gen/colors.gen.dart';


class PageDotIndicatorShared extends StatelessWidget {
  final PageController controller;
  final int itemCount;
  final Color? activeColor;
  final Color? inactiveColor;

  const PageDotIndicatorShared._({
    super.key,
    required this.controller,
    required this.itemCount,
    this.activeColor,
    this.inactiveColor,
  });

  factory PageDotIndicatorShared({
    Key? key,
    required PageController controller,
    required int itemCount,
    Color? activeColor,
    Color? inactiveColor,
  }) {
    activeColor ??= ColorName.contentSecondary;
    inactiveColor ??= ColorName.contentSecondary.withValues(alpha: 0.33);
    return PageDotIndicatorShared._(
      key: key,
      controller: controller,
      itemCount: itemCount,
      activeColor: activeColor,
      inactiveColor: inactiveColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        double currentPage = 0;
        try {
          currentPage = controller.page ?? controller.initialPage.toDouble();
        } catch (_) {}

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(itemCount, (index) {
            final selectedness =
            (1.0 - (currentPage - index).abs()).clamp(0.0, 1.0);
            final isActive = selectedness > 0.5;

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 1.5),
              width:
              isActive ? 15 * selectedness : 5, // active bo‘lsa uzunlashadi
              height: 5,
              decoration: BoxDecoration(
                color: Color.lerp(inactiveColor, activeColor, selectedness),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        );
      },
    );
  }
}