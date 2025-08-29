import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../data/models/car_info.dart' as model;
import 'spec_chip.dart';

class CarPickCard extends StatelessWidget {
  const CarPickCard({
    super.key,
    required this.car,
    required this.selected,
    required this.onToggle,
  });

  final model.CarInfo car;
  final bool selected;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;
    final platform = theme.platform;
    final border = RoundedRectangleBorder(borderRadius: BorderRadius.circular(16));

    IconData _addIcon() => (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS)
        ? CupertinoIcons.add
        : Icons.add_rounded;

    IconData _checkIcon() => (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS)
        ? CupertinoIcons.check_mark
        : Icons.check_rounded;

    // используем цвета из темы: primary — обычное состояние, tertiary — «успех»
    final Color badgeColor = selected ? cs.tertiary : cs.primary;
    final Color badgeIconColor = cs.onPrimary; // достаточно контрастно и там, и там

    void _handleToggle() {
      // нативная тактильная отдача (на iOS/Android), безопасно на других
      Feedback.forTap(context);
      onToggle();
    }

    return Material(
      color: cs.surface,
      elevation: 1,
      shape: border,
      child: InkWell(
        onTap: _handleToggle,
        customBorder: border,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // картинка
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 110,
                      height: 72,
                      child: Image.asset(
                        car.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: cs.surfaceContainerHighest,
                          alignment: Alignment.center,
                          child: Icon(Icons.directions_car, color: cs.onSurfaceVariant),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // текст и спеки
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // заголовок — из textTheme, без хардкода
                        Text(
                          '${car.name} (${car.year})',
                          style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 18,
                          runSpacing: 10,
                          children: [
                            SpecChip(icon: Icons.directions_car_outlined, text: car.bodyType),
                            SpecChip(icon: Icons.electric_bolt, text: car.powertrain),
                            SpecChip(icon: Icons.speed, text: '${car.topSpeedKmh} km/h'),
                            SpecChip(icon: Icons.precision_manufacturing_outlined, text: '${car.horsepower} hp'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // адаптивная круглая кнопка (Material/Cupertino иконки + цвета из темы)
            Positioned(
              top: 6,
              right: 6,
              child: Tooltip(
                message: selected ? 'Выбрано' : 'Добавить',
                child: InkWell(
                  onTap: _handleToggle,
                  borderRadius: BorderRadius.circular(20),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: badgeColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.12),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      selected ? _checkIcon() : _addIcon(),
                      color: badgeIconColor,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
