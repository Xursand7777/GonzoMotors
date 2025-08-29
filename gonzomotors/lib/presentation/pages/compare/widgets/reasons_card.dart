import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../data/models/car_specs.dart';

class ReasonsCard extends StatelessWidget {
  const ReasonsCard({super.key, required this.a, required this.reasons});
  final CarSpecs a;
  final List<String> reasons;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;
    final platform = theme.platform;

    final IconData checkIcon =
    (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS)
        ? CupertinoIcons.check_mark
        : Icons.check_rounded;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Почему ${a.name} лучше?', style: tt.titleMedium),
            const SizedBox(height: 8),

            // пункты причин
            ...reasons.map(
                  (r) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(checkIcon, size: 18, color: cs.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        r,
                        style: tt.bodyMedium, // без хардкода размера/цвета
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 6),
            Text(
              'Прокрутите вниз для подробностей…',
              style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
