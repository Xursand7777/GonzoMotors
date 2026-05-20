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
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: modifications.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.9,
          ),
          itemBuilder: (context, i) {
            final m = modifications[i];
            final isSelected = m.id == selectedCarId;

            return InkWell(
              onTap: () => onSelect(m.id),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? const Color(0xFFE81E0E) : Colors.transparent,
                    width: 1.0,
                  ),
                  color: const Color(0xFFF7F7F7),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${m.model} ${m.modelYear}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatPrice(m.price),
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            color: Color(0xFFE81E0E),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Expanded(
                          child: Text(
                            'цена с\nрастаможкой',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: Color(0xFFE81E0E),
                              fontSize: 7,
                              fontWeight: FontWeight.w400,
                              height: 1.1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          _formatPrice(m.cipPrice),
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            color: Color(0xFF797979),
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'СIP Tashkent',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: Color(0xFF797979),
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
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
