import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/models/car_details.dart' as db;
import 'diff_section.dart';

List<Widget> buildSectionsFromDetails(
    BuildContext context, // 👈 добавили контекст для локали
    db.CarDetails? A,
    db.CarDetails? B, {
      required bool hideEquals,
    }) {
  if (A == null || B == null) {
    return const [
      DiffSection(
        title: 'Производительность',
        rows: [
          DiffRow('0–100 км/ч', '—', '—', higherIsBetter: false),
          DiffRow('Макс. скорость', '—', '—'),
          DiffRow('Мощность', '—', '—'),
        ],
      ),
    ];
  }

  // ===== Локале-зависимое форматирование чисел =====
  final locale = Localizations.localeOf(context).toLanguageTag();
  String n(num v, {int d = 0}) {
    final f = NumberFormat.decimalPattern(locale)
      ..minimumFractionDigits = d
      ..maximumFractionDigits = d;
    return f.format(v);
  }

  // Можно оставить 'есть/нет' — это контент, не UI. При желании локализуй.
  String yes(bool x) => x ? 'есть' : 'нет';

  final perf = DiffSection(
    title: 'Производительность',
    hideEquals: hideEquals,
    rows: [
      DiffRow('0–100 км/ч', '${n(A.perf.zeroTo100, d: 1)} с', '${n(B.perf.zeroTo100, d: 1)} с', higherIsBetter: false),
      DiffRow('Макс. скорость', '${n(A.perf.topSpeedKmh)} км/ч', '${n(B.perf.topSpeedKmh)} км/ч'),
      DiffRow('Мощность', '${n(A.perf.hp)} hp', '${n(B.perf.hp)} hp'),
      DiffRow('Крутящий момент', '${n(A.perf.torqueNm)} Н·м', '${n(B.perf.torqueNm)} Н·м'),
      DiffRow('Привод', A.perf.drive, B.perf.drive, compareAsText: true),
      DiffRow('КПП', A.perf.gearbox, B.perf.gearbox, compareAsText: true),
    ],
  );

  final battery = (A.battery != null || B.battery != null)
      ? DiffSection(
    title: 'Батарея и запас хода',
    hideEquals: hideEquals,
    rows: [
      DiffRow(
        'Ёмкость (брутто)',
        A.battery != null ? '${n(A.battery!.capacityKwh)} кВт·ч' : '—',
        B.battery != null ? '${n(B.battery!.capacityKwh)} кВт·ч' : '—',
      ),
      if (A.battery?.usableKwh != null || B.battery?.usableKwh != null)
        DiffRow(
          'Ёмкость (нетто)',
          A.battery?.usableKwh != null ? '${n(A.battery!.usableKwh!, d: 1)} кВт·ч' : '—',
          B.battery?.usableKwh != null ? '${n(B.battery!.usableKwh!, d: 1)} кВт·ч' : '—',
        ),
      if (A.battery?.rangeWltpKm != null || B.battery?.rangeWltpKm != null)
        DiffRow(
          'WLTP запас',
          A.battery?.rangeWltpKm != null ? '${n(A.battery!.rangeWltpKm!)} км' : '—',
          B.battery?.rangeWltpKm != null ? '${n(B.battery!.rangeWltpKm!)} км' : '—',
        ),
      if (A.battery?.rangeCltcKm != null || B.battery?.rangeCltcKm != null)
        DiffRow(
          'CLTC запас',
          A.battery?.rangeCltcKm != null ? '${n(A.battery!.rangeCltcKm!)} км' : '—',
          B.battery?.rangeCltcKm != null ? '${n(B.battery!.rangeCltcKm!)} км' : '—',
        ),
    ],
  )
      : const SizedBox.shrink();

  final charging = (A.charging != null || B.charging != null)
      ? DiffSection(
    title: 'Зарядка',
    hideEquals: hideEquals,
    rows: [
      DiffRow(
        'AC бортовое ЗУ',
        A.charging != null ? '${n(A.charging!.acKw, d: 1)} кВт' : '—',
        B.charging != null ? '${n(B.charging!.acKw, d: 1)} кВт' : '—',
      ),
      DiffRow(
        'DC пик',
        A.charging != null ? '${n(A.charging!.dcKwPeak, d: 0)} кВт' : '—',
        B.charging != null ? '${n(B.charging!.dcKwPeak, d: 0)} кВт' : '—',
      ),
      DiffRow(
        '10–80%',
        A.charging != null ? '${n(A.charging!.dc10to80Min)} мин' : '—',
        B.charging != null ? '${n(B.charging!.dc10to80Min)} мин' : '—',
        higherIsBetter: false,
      ),
    ],
  )
      : const SizedBox.shrink();

  final dims = DiffSection(
    title: 'Размеры и практичность',
    hideEquals: hideEquals,
    rows: [
      DiffRow(
        'Д×Ш×В',
        '${n(A.dim.lengthMm)}×${n(A.dim.widthMm)}×${n(A.dim.heightMm)} мм',
        '${n(B.dim.lengthMm)}×${n(B.dim.widthMm)}×${n(B.dim.heightMm)} мм',
        compareAsText: true,
      ),
      DiffRow('Колёсная база', '${n(A.dim.wheelbaseMm)} мм', '${n(B.dim.wheelbaseMm)} мм'),
      if (A.dim.trunkL != 0 || B.dim.trunkL != 0)
        DiffRow('Багажник', '${n(A.dim.trunkL)} л', '${n(B.dim.trunkL)} л'),
    ],
  );

  final interior = DiffSection(
    title: 'Интерьер и комфорт',
    hideEquals: hideEquals,
    rows: [
      DiffRow('Мест', n(A.interior.seats), n(B.interior.seats)),
      DiffRow('Динамиков', n(A.interior.speakers), n(B.interior.speakers)),
      DiffRow('Массаж', yes(A.interior.massage), yes(B.interior.massage), compareAsText: true),
      DiffRow('Вентиляция', yes(A.interior.ventilation), yes(B.interior.ventilation), compareAsText: true),
      DiffRow('Холодильник', yes(A.interior.fridge), yes(B.interior.fridge), compareAsText: true),
    ],
  );

  final adas = DiffSection(
    title: 'ADAS и сенсоры',
    hideEquals: hideEquals,
    rows: [
      DiffRow('Уровень', A.adas.level, B.adas.level, compareAsText: true),
      DiffRow('Лидар', yes(A.adas.lidar), yes(B.adas.lidar), compareAsText: true),
      DiffRow('Камер', n(A.adas.cameras), n(B.adas.cameras)),
      DiffRow('Радаров', n(A.adas.radars), n(B.adas.radars)),
      DiffRow('Платформа', A.adas.stack, B.adas.stack, compareAsText: true),
    ],
  );

  final warranty = DiffSection(
    title: 'Гарантии',
    hideEquals: hideEquals,
    rows: [
      DiffRow('Базовая', '${n(A.warranty.baseYears)} лет', '${n(B.warranty.baseYears)} лет'),
      DiffRow('Расширенная', '${n(A.warranty.extYears)} лет', '${n(B.warranty.extYears)} лет'),
    ],
  );

  final pricing = DiffSection(
    title: 'Цена (CN)',
    hideEquals: hideEquals,
    rows: [
      DiffRow('MSRP мин', '${n(A.pricing.msrpCnyMin)} ¥', '${n(B.pricing.msrpCnyMin)} ¥', higherIsBetter: false),
      if (A.pricing.msrpCnyMax != null || B.pricing.msrpCnyMax != null)
        DiffRow(
          'MSRP макс',
          A.pricing.msrpCnyMax != null ? '${n(A.pricing.msrpCnyMax!)} ¥' : '—',
          B.pricing.msrpCnyMax != null ? '${n(B.pricing.msrpCnyMax!)} ¥' : '—',
          higherIsBetter: false,
        ),
    ],
  );

  return [
    perf,
    if (battery is! SizedBox) battery,
    if (charging is! SizedBox) charging,
    dims,
    interior,
    adas,
    warranty,
    pricing,
  ];
}
