import 'package:flutter/material.dart';

class SpecChip extends StatelessWidget {
  const SpecChip({
    super.key,
    required this.icon,
    required this.text,
    this.iconSize = 18,
  });

  final IconData icon;
  final String text;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final textStyle =
    theme.textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant);

    return IconTheme.merge(
      data: IconThemeData(
        size: iconSize,
        color: cs.onSurfaceVariant, // вместо Colors.grey.*
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(width: 6),
          // текст адаптируется к теме и доступности
          Text(
            text,
            style: textStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
