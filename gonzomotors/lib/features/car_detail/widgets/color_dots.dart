import 'package:flutter/material.dart';

class ColorDots extends StatelessWidget {
  final List<Color> colors;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const ColorDots({
    super.key,
    required this.colors,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(colors.length, (i) {
        final isSelected = i == selectedIndex;

        return GestureDetector(
          onTap: () => onSelect(i),
          child: Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.black : Colors.black.withOpacity(0.15),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Center(
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors[i],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
