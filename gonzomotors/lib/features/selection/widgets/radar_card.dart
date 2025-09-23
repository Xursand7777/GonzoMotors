import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/enums/car.dart';
import '../../../data/models/car_specs.dart';

class RadarCard extends StatelessWidget {
  const RadarCard({
    super.key,
    required this.a,
    required this.b,
    required this.cats,
    required this.titles,
  });

  final CarSpecs a;
  final CarSpecs b;
  final List<Car> cats;
  final List<String> titles;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // заголовочные «пилюли»
            Container(
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  Expanded(child: _TabPill(text: a.name, selected: true)),
                  const SizedBox(width: 6),
                  Expanded(child: _TabPill(text: b.name, selected: false)),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // сам радар
            AspectRatio(
              aspectRatio: 1.1,
              child: RadarChart(
                RadarChartData(
                  radarBackgroundColor: Colors.transparent,
                  radarShape: RadarShape.polygon,
                  tickCount: 4,
                  // ✅ вместо серого — токены темы
                  ticksTextStyle: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant) ??
                      TextStyle(fontSize: 10, color: cs.onSurfaceVariant),
                  gridBorderData: BorderSide(color: cs.outlineVariant, width: 1),
                  titleTextStyle: tt.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ) ??
                      const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                  getTitle: (index, angle) => RadarChartTitle(
                    text: titles[index],
                    angle: angle,
                  ),
                  dataSets: [
                    RadarDataSet(
                      // ✅ цвета из палитры — корректно и в dark
                      fillColor: cs.primary.withOpacity(.45),
                      borderColor: cs.primary,
                      entryRadius: 2,
                      dataEntries: cats
                          .map((c) => RadarEntry(value: (a.norm[c] ?? 0).clamp(0, 100)))
                          .toList(),
                    ),
                    RadarDataSet(
                      fillColor: cs.secondary.withOpacity(.45),
                      borderColor: cs.secondary,
                      entryRadius: 2,
                      dataEntries: cats
                          .map((c) => RadarEntry(value: (b.norm[c] ?? 0).clamp(0, 100)))
                          .toList(),
                    ),
                  ],
                ),
                swapAnimationDuration: const Duration(milliseconds: 300),
              ),
            ),

            const SizedBox(height: 8),

            // легенда
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _LegendDot(color: cs.primary, text: a.name),
                const SizedBox(width: 16),
                _LegendDot(color: cs.secondary, text: b.name),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.text});
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Row(
      children: [
        // ✅ контрастная точка + тонкая обводка для тёмной темы
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color.withOpacity(.75),
            shape: BoxShape.circle,
            border: Border.all(color: cs.outlineVariant, width: 1),
          ),
        ),
        const SizedBox(width: 6),
        SizedBox(
          width: 140,
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: tt.labelSmall?.copyWith(color: cs.onSurface) ??
                const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class _TabPill extends StatelessWidget {
  const _TabPill({required this.text, required this.selected});
  final String text;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final bg = selected ? cs.primary : cs.surface;
    final fg = selected ? cs.onPrimary : cs.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: tt.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: fg,
        ) ??
            TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }
}
