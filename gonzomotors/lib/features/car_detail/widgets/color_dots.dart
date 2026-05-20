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
            width: 23,
            height: 23,
            margin: const EdgeInsets.symmetric(horizontal: 4.5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.black : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Center(
              child: Container(
                width: 15,
                height: 15,
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
