import 'package:flutter/material.dart';

import '../data/models/car_model_detail.dart';

class ModificationsGrid extends StatelessWidget {
  final String title;
  final List<CarModelDetail> modifications;
  final int? selectedCarId;
  final ValueChanged<int> onSelect;

  const ModificationsGrid({
    super.key,
    required this.title,
    required this.modifications,
    required this.selectedCarId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    if (modifications.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: modifications.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.15,
          ),
          itemBuilder: (context, i) {
            final m = modifications[i];
            final isSelected = m.id == selectedCarId;

            return InkWell(
              onTap: () => onSelect(m.id),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? Colors.red : const Color(0xFFE9E9E9),
                    width: isSelected ? 1.5 : 1,
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${m.model} ${m.modelYear}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatPrice(m.price),
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_formatPrice(m.cipPrice)} CIP Tashkent',
                      style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 12),
                    ),
                    const Spacer(),
                    Text(
                      m.powertrain,
                      style: TextStyle(color: Colors.black.withOpacity(0.55), fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  String _formatPrice(num? value) {
    final v = (value ?? 0).round();
    final s = v.toString();
    // 37000 -> 37 000
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final left = s.length - i;
      buf.write(s[i]);
      if (left > 1 && left % 3 == 1) buf.write(' ');
    }
    return '\$${buf.toString()}';
  }
}
