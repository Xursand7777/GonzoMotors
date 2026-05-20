import 'package:flutter/material.dart';
import '../data/models/car_model_detail.dart';

class SpecsTable extends StatelessWidget {
  final CarModelDetail? detail;

  const SpecsTable({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    final d = detail;
    if (d == null || d.characteristics == null) return const SizedBox.shrink();

    final perf = d.characteristics!.performance;
    final vol = d.characteristics!.volumeMass;
    final bat = d.characteristics!.battery;
    final tr = d.characteristics!.transmission;
    final eng = d.characteristics!.engine;

    final rows = <_SpecRow>[
      _SpecRow('Разгон до сотни', perf?.zeroTo100 != null ? '${perf!.zeroTo100}с' : '—'),
      _SpecRow('Запас хода', bat?.capacityKwh != null ? '${bat!.capacityKwh} kWh' : '—'),
      _SpecRow('Тип аккумулятора', bat?.batteryType ?? '—'),
      _SpecRow('Вместимость багаж', vol?.trunkVolumeMax != null ? '${vol!.trunkVolumeMax}' : '—'),
      _SpecRow('Мощность электрод', eng?.totalPowerHp != null ? '${eng!.totalPowerHp}' : '—'),
      _SpecRow('Мощность батареи', eng?.totalPowerKw != null ? '${eng!.totalPowerKw}' : '—'),
      _SpecRow('Типы приводов', tr?.driveType ?? '—'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFEBEBEB), width: 1.0),
      ),
      child: Column(
        children: List.generate(rows.length, (i) {
          final r = rows[i];
          final isLast = i == rows.length - 1;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              border: isLast
                  ? null
                  : const Border(bottom: BorderSide(color: Color(0xFFBEBEBE), width: 0.5)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    r.label,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      color: Color(0xFF797979),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  r.value,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _SpecRow {
  final String label;
  final String value;
  _SpecRow(this.label, this.value);
}
