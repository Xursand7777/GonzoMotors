// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:gonzomotors/core/enums/car.dart';
// import '../../data/card_db.dart' as db;
// import '../../data/models/car_details.dart' as db;
// import '../../data/models/compare_models.dart';
//
// class ComparePage extends StatefulWidget {
//   const ComparePage({super.key, this.a, this.b});
//
//   /// Удобный конструктор, если приходим со страницы выбора
//   const ComparePage.prefilled({super.key, required this.a, required this.b});
//
//   final CarSpecs? a;
//   final CarSpecs? b;
//
//   @override
//   State<ComparePage> createState() => _ComparePageState();
// }
//
// class _ComparePageState extends State<ComparePage> {
//   late CarSpecs a;
//   late CarSpecs b;
//
//   // 🔘 Новый тумблер: скрывать одинаковые значения
//   bool _hideEquals = false;
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.a != null && widget.b != null) {
//       a = widget.a!;
//       b = widget.b!;
//     } else {
//       // Демоданные по умолчанию (если пришли без параметров)
//
//     }
//   }
//
//   // --- Помощники для секций ---
//   db.CarDetails? _detailsFor(CarSpecs s) {
//     // Ожидаем формат 'Name (YYYY)' — такой же, как в CarDetails.toCompare()
//     final re = RegExp(r'^(.*)\s*\((\d{4})\)$');
//     final m = re.firstMatch(s.name);
//     String? base;
//     int? year;
//     if (m != null) {
//       base = m.group(1)!.trim();
//       year = int.tryParse(m.group(2)!);
//     }
//     // Ищем точное совпадение name+year
//     if (base != null && year != null) {
//       for (final d in db.carDb) {
//         if (d.name == base && d.year == year) return d;
//       }
//     }
//     // Фолбэк: по имени
//     if (base != null) {
//       for (final d in db.carDb) {
//         if (d.name.toLowerCase() == base.toLowerCase()) return d;
//       }
//       for (final d in db.carDb) {
//         if (d.name.toLowerCase().startsWith(base.toLowerCase())) return d;
//       }
//     }
//     return null;
//   }
//
//   // ⬇️ теперь секции принимают флаг hideEquals и прокидывают его в DiffSection
//   List<Widget> _sectionsFromCarDb(
//       db.CarDetails A,
//       db.CarDetails B, {
//         required bool hideEquals,
//       }) {
//     String n(num v, {int d = 1}) => v % 1 == 0 ? v.toStringAsFixed(0) : v.toStringAsFixed(d);
//     String yes(bool x) => x ? 'есть' : 'нет';
//
//     final perf = DiffSection(
//       title: 'Производительность',
//       hideEquals: hideEquals,
//       rows: [
//         DiffRow('0–100 км/ч', '${n(A.perf.zeroTo100, d:1)} с', '${n(B.perf.zeroTo100, d:1)} с', higherIsBetter: false),
//         DiffRow('Макс. скорость', '${n(A.perf.topSpeedKmh)} км/ч', '${n(B.perf.topSpeedKmh)} км/ч'),
//         DiffRow('Мощность', '${n(A.perf.hp)} hp', '${n(B.perf.hp)} hp'),
//         DiffRow('Крутящий момент', '${n(A.perf.torqueNm)} Н·м', '${n(B.perf.torqueNm)} Н·м'),
//         DiffRow('Привод', A.perf.drive, B.perf.drive, compareAsText: true),
//         DiffRow('КПП', A.perf.gearbox, B.perf.gearbox, compareAsText: true),
//       ],
//     );
//
//     final battery = (A.battery != null || B.battery != null)
//         ? DiffSection(
//       title: 'Батарея и запас хода',
//       hideEquals: hideEquals,
//       rows: [
//         DiffRow('Ёмкость (брутто)',
//             A.battery != null ? '${n(A.battery!.capacityKwh)} кВт·ч' : '—',
//             B.battery != null ? '${n(B.battery!.capacityKwh)} кВт·ч' : '—'),
//         if (A.battery?.usableKwh != null || B.battery?.usableKwh != null)
//           DiffRow('Ёмкость (нетто)',
//               A.battery?.usableKwh != null ? '${n(A.battery!.usableKwh!)} кВт·ч' : '—',
//               B.battery?.usableKwh != null ? '${n(B.battery!.usableKwh!)} кВт·ч' : '—'),
//         if (A.battery?.rangeWltpKm != null || B.battery?.rangeWltpKm != null)
//           DiffRow('WLTP запас',
//               A.battery?.rangeWltpKm != null ? '${n(A.battery!.rangeWltpKm!)} км' : '—',
//               B.battery?.rangeWltpKm != null ? '${n(B.battery!.rangeWltpKm!)} км' : '—'),
//         if (A.battery?.rangeCltcKm != null || B.battery?.rangeCltcKm != null)
//           DiffRow('CLTC запас',
//               A.battery?.rangeCltcKm != null ? '${n(A.battery!.rangeCltcKm!)} км' : '—',
//               B.battery?.rangeCltcKm != null ? '${n(B.battery!.rangeCltcKm!)} км' : '—'),
//       ],
//     )
//         : const SizedBox.shrink();
//
//     final charging = (A.charging != null || B.charging != null)
//         ? DiffSection(
//       title: 'Зарядка',
//       hideEquals: hideEquals,
//       rows: [
//         DiffRow('AC бортовое ЗУ',
//             A.charging != null ? '${n(A.charging!.acKw)} кВт' : '—',
//             B.charging != null ? '${n(B.charging!.acKw)} кВт' : '—'),
//         DiffRow('DC пик',
//             A.charging != null ? '${n(A.charging!.dcKwPeak)} кВт' : '—',
//             B.charging != null ? '${n(B.charging!.dcKwPeak)} кВт' : '—'),
//         DiffRow('10–80%',
//             A.charging != null ? '${A.charging!.dc10to80Min} мин' : '—',
//             B.charging != null ? '${B.charging!.dc10to80Min} мин' : '—',
//             higherIsBetter: false),
//       ],
//     )
//         : const SizedBox.shrink();
//
//     final dims = DiffSection(
//       title: 'Размеры и практичность',
//       hideEquals: hideEquals,
//       rows: [
//         DiffRow('Д×Ш×В',
//             '${A.dim.lengthMm}×${A.dim.widthMm}×${A.dim.heightMm} мм',
//             '${B.dim.lengthMm}×${B.dim.widthMm}×${B.dim.heightMm} мм',
//             compareAsText: true),
//         DiffRow('Колёсная база', '${A.dim.wheelbaseMm} мм', '${B.dim.wheelbaseMm} мм'),
//         if (A.dim.trunkL != 0 || B.dim.trunkL != 0)
//           DiffRow('Багажник', '${A.dim.trunkL} л', '${B.dim.trunkL} л'),
//       ],
//     );
//
//     final interior = DiffSection(
//       title: 'Интерьер и комфорт',
//       hideEquals: hideEquals,
//       rows: [
//         DiffRow('Мест', '${A.interior.seats}', '${B.interior.seats}'),
//         DiffRow('Динамиков', '${A.interior.speakers}', '${B.interior.speakers}'),
//         DiffRow('Массаж', yes(A.interior.massage), yes(B.interior.massage), compareAsText: true),
//         DiffRow('Вентиляция', yes(A.interior.ventilation), yes(B.interior.ventilation), compareAsText: true),
//         DiffRow('Холодильник', yes(A.interior.fridge), yes(B.interior.fridge), compareAsText: true),
//       ],
//     );
//
//     final adas = DiffSection(
//       title: 'ADAS и сенсоры',
//       hideEquals: hideEquals,
//       rows: [
//         DiffRow('Уровень', A.adas.level, B.adas.level, compareAsText: true),
//         DiffRow('Лидар', yes(A.adas.lidar), yes(B.adas.lidar), compareAsText: true),
//         DiffRow('Камер', '${A.adas.cameras}', '${B.adas.cameras}'),
//         DiffRow('Радаров', '${A.adas.radars}', '${B.adas.radars}'),
//         DiffRow('Платформа', A.adas.stack, B.adas.stack, compareAsText: true),
//       ],
//     );
//
//     final warranty = DiffSection(
//       title: 'Гарантии',
//       hideEquals: hideEquals,
//       rows: [
//         DiffRow('Базовая', '${A.warranty.baseYears} лет', '${B.warranty.baseYears} лет'),
//         DiffRow('Расширенная', '${A.warranty.extYears} лет', '${B.warranty.extYears} лет'),
//       ],
//     );
//
//     final pricing = DiffSection(
//       title: 'Цена (CN)',
//       hideEquals: hideEquals,
//       rows: [
//         DiffRow('MSRP мин', '${A.pricing.msrpCnyMin} ¥', '${B.pricing.msrpCnyMin} ¥', higherIsBetter: false),
//         if (A.pricing.msrpCnyMax != null || B.pricing.msrpCnyMax != null)
//           DiffRow('MSRP макс',
//               A.pricing.msrpCnyMax != null ? '${A.pricing.msrpCnyMax} ¥' : '—',
//               B.pricing.msrpCnyMax != null ? '${B.pricing.msrpCnyMax} ¥' : '—',
//               higherIsBetter: false),
//       ],
//     );
//
//     return [
//       perf,
//       if (battery is! SizedBox) battery,
//       if (charging is! SizedBox) charging,
//       dims,
//       interior,
//       adas,
//       warranty,
//       pricing,
//     ];
//   }
//
//   List<String> whyABetter(CarSpecs A, CarSpecs B) {
//     final out = <String>[];
//     if (A.seats > B.seats) out.add('1 больше пассажирских мест — ${A.seats} vs ${B.seats}');
//     if (A.speakers > B.speakers) out.add('Больше динамиков — ${A.speakers} vs ${B.speakers}');
//     if (A.baseWarrantyYears > B.baseWarrantyYears) {
//       out.add('${A.baseWarrantyYears - B.baseWarrantyYears} years больше базовая гарантия — ${A.baseWarrantyYears} vs ${B.baseWarrantyYears}');
//     }
//     if (A.extWarrantyYears > B.extWarrantyYears) {
//       out.add('${A.extWarrantyYears - B.extWarrantyYears} years дольше доп. гарантия — ${A.extWarrantyYears} vs ${B.extWarrantyYears}');
//     }
//     for (final c in Car.values) {
//       if ((A.norm[c] ?? 0) - (B.norm[c] ?? 0) >= 12) {
//         out.add('Лучше по категории «${carLabel(c)}»');
//       }
//     }
//     if (out.isEmpty) out.add('Модели сопоставимы — явных преимуществ нет.');
//     return out;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final reasons = whyABetter(a, b);
//     final cats = Car.values;
//     final titles = cats.map(carLabel).toList();
//
//     final chart = _RadarCard(a: a, b: b, cats: cats, titles: titles);
//     final reasonsList = _ReasonsCard(a: a, reasons: reasons);
//
//     // Пытаемся подтянуть CarDetails для секций
//     final detA = _detailsFor(a);
//     final detB = _detailsFor(b);
//
//     // Если нашлись обе записи в БД — строим секции из car_db, иначе — демо фолбэк.
//     final sections = (detA != null && detB != null)
//         ? _sectionsFromCarDb(detA, detB, hideEquals: _hideEquals)
//         : <Widget>[
//       DiffSection(
//         title: 'Производительность',
//         hideEquals: _hideEquals,
//         rows: const [
//           DiffRow('0–100 км/ч', '—', '—', higherIsBetter: false),
//           DiffRow('Макс. скорость', '—', '—'),
//           DiffRow('Мощность', '—', '—'),
//         ],
//       ),
//     ];
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Сравнение'),
//         actions: [
//           Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Padding(
//                 padding: EdgeInsets.only(right: 6),
//                 child: Text('Скрывать одинаковые', style: TextStyle(fontSize: 12)),
//               ),
//               Switch.adaptive(
//                 value: _hideEquals,
//                 onChanged: (v) => setState(() => _hideEquals = v),
//               ),
//               const SizedBox(width: 8),
//             ],
//           ),
//         ],
//       ),
//       body: LayoutBuilder(
//         builder: (ctx, c) {
//           final isWide = c.maxWidth > 680;
//           return Padding(
//             padding: const EdgeInsets.all(12),
//             child: isWide
//                 ? Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   flex: 6,
//                   child: ListView(
//                     children: [
//                       chart,
//                       const SizedBox(height: 12),
//                       reasonsList,
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   flex: 7,
//                   child: ListView.separated(
//                     itemCount: sections.length,
//                     separatorBuilder: (_, __) => const SizedBox(height: 12),
//                     itemBuilder: (_, i) => sections[i],
//                   ),
//                 ),
//               ],
//             )
//                 : ListView(
//               children: [
//                 chart,
//                 const SizedBox(height: 12),
//                 reasonsList,
//                 const SizedBox(height: 12),
//                 ...sections.expand((w) => [w, const SizedBox(height: 12)]).toList()
//                   ..removeLast(),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class _RadarCard extends StatelessWidget {
//   const _RadarCard({
//     required this.a,
//     required this.b,
//     required this.cats,
//     required this.titles,
//   });
//
//   final CarSpecs a;
//   final CarSpecs b;
//   final List<Car> cats;
//   final List<String> titles;
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Card(
//       elevation: 1,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           children: [
//             // "табы" с именами для стилистики
//             Container(
//               decoration: BoxDecoration(
//                 color: theme.colorScheme.surfaceContainerHighest,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               padding: const EdgeInsets.all(4),
//               child: Row(
//                 children: [
//                   Expanded(child: _TabPill(text: a.name, selected: true)),
//                   const SizedBox(width: 6),
//                   Expanded(child: _TabPill(text: b.name, selected: false)),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 12),
//             AspectRatio(
//               aspectRatio: 1.1,
//               child: RadarChart(
//                 RadarChartData(
//                   radarBackgroundColor: Colors.transparent,
//                   radarShape: RadarShape.polygon,
//                   tickCount: 4,
//                   ticksTextStyle: const TextStyle(fontSize: 10, color: Colors.grey),
//                   gridBorderData: BorderSide(color: Colors.grey.shade300, width: 1),
//                   titleTextStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
//                   getTitle: (index, angle) => RadarChartTitle(
//                     text: titles[index],
//                     angle: angle,
//                   ),
//                   dataSets: [
//                     RadarDataSet(
//                       fillColor: theme.colorScheme.primary.withOpacity(.45),
//                       borderColor: theme.colorScheme.primary,
//                       entryRadius: 2,
//                       dataEntries: cats
//                           .map((c) => RadarEntry(value: (a.norm[c] ?? 0).clamp(0, 100)))
//                           .toList(),
//                     ),
//                     RadarDataSet(
//                       fillColor: theme.colorScheme.secondary.withOpacity(.45),
//                       borderColor: theme.colorScheme.secondary,
//                       entryRadius: 2,
//                       dataEntries: cats
//                           .map((c) => RadarEntry(value: (b.norm[c] ?? 0).clamp(0, 100)))
//                           .toList(),
//                     ),
//                   ],
//                 ),
//                 swapAnimationDuration: const Duration(milliseconds: 300),
//               ),
//             ),
//             const SizedBox(height: 8),
//             // Легенда
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 _LegendDot(color: theme.colorScheme.primary, text: a.name),
//                 const SizedBox(width: 16),
//                 _LegendDot(color: theme.colorScheme.secondary, text: b.name),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _LegendDot extends StatelessWidget {
//   const _LegendDot({required this.color, required this.text});
//   final Color color;
//   final String text;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Container(
//           width: 12,
//           height: 12,
//           decoration: BoxDecoration(color: color.withOpacity(.7), shape: BoxShape.circle),
//         ),
//         const SizedBox(width: 6),
//         SizedBox(
//           width: 140,
//           child: Text(text, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
//         ),
//       ],
//     );
//   }
// }
//
// class _TabPill extends StatelessWidget {
//   const _TabPill({required this.text, required this.selected});
//   final String text;
//   final bool selected;
//
//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//       decoration: BoxDecoration(
//         color: selected ? cs.primary : cs.surface,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Text(
//         text,
//         maxLines: 1,
//         overflow: TextOverflow.ellipsis,
//         textAlign: TextAlign.center,
//         style: TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.w600,
//           color: selected ? cs.onPrimary : cs.onSurfaceVariant,
//         ),
//       ),
//     );
//   }
// }
//
// class _ReasonsCard extends StatelessWidget {
//   const _ReasonsCard({required this.a, required this.reasons});
//   final CarSpecs a;
//   final List<String> reasons;
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Card(
//       elevation: 1,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Почему ${a.name} лучше?', style: theme.textTheme.titleMedium),
//             const SizedBox(height: 8),
//             ...reasons.map(
//                   (r) => Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 6),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Icon(Icons.check, size: 18),
//                     const SizedBox(width: 8),
//                     Expanded(child: Text(r, style: const TextStyle(fontSize: 14))),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 6),
//             const Text(
//               'Прокрутите вниз для подробностей…',
//               style: TextStyle(fontSize: 12, color: Colors.grey),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// /* ========================= DIFF СЕКЦИИ ========================= */
//
// class DiffRow {
//   final String label;
//   final String aValue;
//   final String bValue;
//
//   /// Если false — меньше лучше (например, время разгона)
//   final bool higherIsBetter;
//
//   /// Сравнение как текст (AWD vs RWD), без числового ранжирования
//   final bool compareAsText;
//
//   const DiffRow(
//       this.label,
//       this.aValue,
//       this.bValue, {
//         this.higherIsBetter = true,
//         this.compareAsText = false,
//       });
// }
//
// class DiffSection extends StatelessWidget {
//   const DiffSection({
//     super.key,
//     required this.title,
//     required this.rows,
//     this.hideEquals = false, // 🔘 новый параметр
//   });
//
//   final String title;
//   final List<DiffRow> rows;
//   final bool hideEquals;
//
//   // для фильтра равенств — парсим числа из строк
//   double _num(String s) {
//     final t = s.replaceAll(RegExp(r'[^0-9\.,-]'), '').replaceAll(',', '.');
//     return double.tryParse(t) ?? double.nan;
//   }
//
//   bool _isEqual(DiffRow r) {
//     if (r.compareAsText) {
//       final a = r.aValue.trim().toLowerCase();
//       final b = r.bValue.trim().toLowerCase();
//       return a == b;
//     }
//     final aNum = _num(r.aValue);
//     final bNum = _num(r.bValue);
//     if (aNum.isFinite && bNum.isFinite) {
//       return (aNum - bNum).abs() < 1e-6;
//     }
//     // если не числа — сравним нормализованные строки (включая тире '—')
//     return r.aValue.trim() == r.bValue.trim();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//
//     final filtered = hideEquals ? rows.where((r) => !_isEqual(r)).toList() : rows;
//     if (filtered.isEmpty) return const SizedBox.shrink();
//
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       elevation: 1,
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(title, style: Theme.of(context).textTheme.titleMedium),
//             const SizedBox(height: 8),
//             ...filtered.map((r) => _DiffRowTile(row: r, cs: cs)).toList(),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _DiffRowTile extends StatelessWidget {
//   const _DiffRowTile({required this.row, required this.cs});
//   final DiffRow row;
//   final ColorScheme cs;
//
//   // Парсим число из строки (оставляем digits + '.'/','/минус)
//   double _num(String s) {
//     final t = s.replaceAll(RegExp(r'[^0-9\.,-]'), '').replaceAll(',', '.');
//     return double.tryParse(t) ?? double.nan;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     int win = 0; // 0 - ничья, 1 - A, 2 - B
//
//     if (!row.compareAsText) {
//       final aNum = _num(row.aValue);
//       final bNum = _num(row.bValue);
//       if (aNum.isFinite && bNum.isFinite && aNum != bNum) {
//         final aBetter = row.higherIsBetter ? aNum > bNum : aNum < bNum;
//         win = aBetter ? 1 : 2;
//       }
//     }
//
//     Color? shade(int who) {
//       if (win == who) return (who == 1 ? cs.primary : cs.secondary).withOpacity(.12);
//       return null;
//     }
//
//     Color? textColor(int who) {
//       if (win == who) return who == 1 ? cs.primary : cs.secondary;
//       return null;
//     }
//
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
//       child: Row(
//         children: [
//           Expanded(flex: 5, child: Text(row.label)),
//           Expanded(
//             flex: 4,
//             child: Container(
//               padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
//               decoration: BoxDecoration(color: shade(1), borderRadius: BorderRadius.circular(8)),
//               child: Row(
//                 children: [
//                   if (win == 1) const Icon(Icons.arrow_upward, size: 14),
//                   const SizedBox(width: 4),
//                   Flexible(child: Text(row.aValue, style: TextStyle(color: textColor(1)))),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             flex: 4,
//             child: Container(
//               padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
//               decoration: BoxDecoration(color: shade(2), borderRadius: BorderRadius.circular(8)),
//               child: Row(
//                 children: [
//                   if (win == 2) const Icon(Icons.arrow_upward, size: 14),
//                   const SizedBox(width: 4),
//                   Flexible(child: Text(row.bValue, style: TextStyle(color: textColor(2)))),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



// lib/presentation/compare/pages/compare_page.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/car.dart';
import '../../../../data/models/car_specs.dart';
import '../../../../data/models/car_details.dart' as db;

import '../../../../domain/usecases/find_details_by_specs.dart';
import '../../../core/app_injection.dart';
import '../../../data/models/compare_models.dart';
import '../../bloc/compare/compare_bloc.dart';


class ComparePage extends StatelessWidget {
  const ComparePage({super.key, this.a, this.b});

  /// Удобный конструктор, если приходим со страницы выбора
  const ComparePage.prefilled({super.key, required this.a, required this.b});

  final CarSpecs? a;
  final CarSpecs? b;

  @override
  Widget build(BuildContext context) {
    assert(a != null && b != null,
    'ComparePage требует два CarSpecs. Используй ComparePage.prefilled(a:..., b:...)');

    return BlocProvider(
      create: (_) => CompareBloc(sl<FindDetailsBySpecs>())
        ..add(CompareInit(a: a!, b: b!)),
      child: const _CompareView(),
    );
  }
}

class _CompareView extends StatelessWidget {
  const _CompareView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompareBloc, CompareState>(
      builder: (context, state) {
        if (state is CompareLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (state is CompareError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Сравнение')),
            body: Center(child: Text('Ошибка: ${state.message}')),
          );
        }

        final s = state as CompareLoaded;

        final cats = Car.values;
        final titles = cats.map(carLabel).toList();

        final chart = _RadarCard(a: s.a, b: s.b, cats: cats, titles: titles);
        final reasonsList = _ReasonsCard(a: s.a, reasons: s.reasons);

        // Секции строим, если нашлись обе записи в БД
        final sections = (s.detA != null && s.detB != null)
            ? _sectionsFromCarDb(s.detA!, s.detB!, hideEquals: s.hideEquals)
            : <Widget>[
          DiffSection(
            title: 'Производительность',
            hideEquals: s.hideEquals,
            rows: const [
              DiffRow('0–100 км/ч', '—', '—', higherIsBetter: false),
              DiffRow('Макс. скорость', '—', '—'),
              DiffRow('Мощность', '—', '—'),
            ],
          ),
        ];

        return Scaffold(
          appBar: AppBar(
            title: const Text('Сравнение'),
            actions: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 6),
                    child: Text('Скрывать одинаковые', style: TextStyle(fontSize: 12)),
                  ),
                  Switch.adaptive(
                    value: s.hideEquals,
                    onChanged: (v) =>
                        context.read<CompareBloc>().add(CompareToggleHide(v)),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ],
          ),
          body: LayoutBuilder(
            builder: (ctx, c) {
              final isWide = c.maxWidth > 680;
              return Padding(
                padding: const EdgeInsets.all(12),
                child: isWide
                    ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 6,
                      child: ListView(
                        children: [
                          chart,
                          const SizedBox(height: 12),
                          reasonsList,
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 7,
                      child: ListView.separated(
                        itemCount: sections.length,
                        separatorBuilder: (_, __) =>
                        const SizedBox(height: 12),
                        itemBuilder: (_, i) => sections[i],
                      ),
                    ),
                  ],
                )
                    : ListView(
                  children: [
                    chart,
                    const SizedBox(height: 12),
                    reasonsList,
                    const SizedBox(height: 12),
                    ...sections
                        .expand((w) => [w, const SizedBox(height: 12)])
                        .toList()
                      ..removeLast(),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

/* ============================ РАДАР ============================ */

class _RadarCard extends StatelessWidget {
  const _RadarCard({
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
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // "табы" с именами для стилистики
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
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
            AspectRatio(
              aspectRatio: 1.1,
              child: RadarChart(
                RadarChartData(
                  radarBackgroundColor: Colors.transparent,
                  radarShape: RadarShape.polygon,
                  tickCount: 4,
                  ticksTextStyle:
                  const TextStyle(fontSize: 10, color: Colors.grey),
                  gridBorderData:
                  BorderSide(color: Colors.grey.shade300, width: 1),
                  titleTextStyle: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w600),
                  getTitle: (index, angle) => RadarChartTitle(
                    text: titles[index],
                    angle: angle,
                  ),
                  dataSets: [
                    RadarDataSet(
                      fillColor:
                      theme.colorScheme.primary.withOpacity(.45),
                      borderColor: theme.colorScheme.primary,
                      entryRadius: 2,
                      dataEntries: cats
                          .map((c) => RadarEntry(
                          value: (a.norm[c] ?? 0).clamp(0, 100)))
                          .toList(),
                    ),
                    RadarDataSet(
                      fillColor:
                      theme.colorScheme.secondary.withOpacity(.45),
                      borderColor: theme.colorScheme.secondary,
                      entryRadius: 2,
                      dataEntries: cats
                          .map((c) => RadarEntry(
                          value: (b.norm[c] ?? 0).clamp(0, 100)))
                          .toList(),
                    ),
                  ],
                ),
                swapAnimationDuration: const Duration(milliseconds: 300),
              ),
            ),
            const SizedBox(height: 8),
            // Легенда
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _LegendDot(color: theme.colorScheme.primary, text: a.name),
                const SizedBox(width: 16),
                _LegendDot(color: theme.colorScheme.secondary, text: b.name),
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
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color.withOpacity(.7),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        SizedBox(
          width: 140,
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? cs.primary : cs.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: selected ? cs.onPrimary : cs.onSurfaceVariant,
        ),
      ),
    );
  }
}

/* ============================ ПРИЧИНЫ ============================ */

class _ReasonsCard extends StatelessWidget {
  const _ReasonsCard({required this.a, required this.reasons});
  final CarSpecs a;
  final List<String> reasons;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Почему ${a.name} лучше?', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            ...reasons.map(
                  (r) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(r, style: const TextStyle(fontSize: 14)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Прокрутите вниз для подробностей…',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

/* ========================= DIFF СЕКЦИИ ========================= */

class DiffRow {
  final String label;
  final String aValue;
  final String bValue;

  /// Если false — меньше лучше (например, время разгона)
  final bool higherIsBetter;

  /// Сравнение как текст (AWD vs RWD), без числового ранжирования
  final bool compareAsText;

  const DiffRow(
      this.label,
      this.aValue,
      this.bValue, {
        this.higherIsBetter = true,
        this.compareAsText = false,
      });
}

class DiffSection extends StatelessWidget {
  const DiffSection({
    super.key,
    required this.title,
    required this.rows,
    this.hideEquals = false,
  });

  final String title;
  final List<DiffRow> rows;
  final bool hideEquals;

  // для фильтра равенств — парсим числа из строк
  double _num(String s) {
    final t = s.replaceAll(RegExp(r'[^0-9\.,-]'), '').replaceAll(',', '.');
    return double.tryParse(t) ?? double.nan;
  }

  bool _isEqual(DiffRow r) {
    if (r.compareAsText) {
      final a = r.aValue.trim().toLowerCase();
      final b = r.bValue.trim().toLowerCase();
      return a == b;
    }
    final aNum = _num(r.aValue);
    final bNum = _num(r.bValue);
    if (aNum.isFinite && bNum.isFinite) {
      return (aNum - bNum).abs() < 1e-6;
    }
    // если не числа — сравним нормализованные строки (включая тире '—')
    return r.aValue.trim() == r.bValue.trim();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final filtered = hideEquals ? rows.where((r) => !_isEqual(r)).toList() : rows;
    if (filtered.isEmpty) return const SizedBox.shrink();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...filtered.map((r) => _DiffRowTile(row: r, cs: cs)).toList(),
          ],
        ),
      ),
    );
  }
}

class _DiffRowTile extends StatelessWidget {
  const _DiffRowTile({required this.row, required this.cs});
  final DiffRow row;
  final ColorScheme cs;

  // Парсим число из строки (оставляем digits + '.'/','/минус)
  double _num(String s) {
    final t = s.replaceAll(RegExp(r'[^0-9\.,-]'), '').replaceAll(',', '.');
    return double.tryParse(t) ?? double.nan;
  }

  @override
  Widget build(BuildContext context) {
    int win = 0; // 0 - ничья, 1 - A, 2 - B

    if (!row.compareAsText) {
      final aNum = _num(row.aValue);
      final bNum = _num(row.bValue);
      if (aNum.isFinite && bNum.isFinite && aNum != bNum) {
        final aBetter =
        row.higherIsBetter ? aNum > bNum : aNum < bNum;
        win = aBetter ? 1 : 2;
      }
    }

    Color? shade(int who) {
      if (win == who) {
        return (who == 1 ? cs.primary : cs.secondary).withOpacity(.12);
      }
      return null;
    }

    Color? textColor(int who) {
      if (win == who) return who == 1 ? cs.primary : cs.secondary;
      return null;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        children: [
          Expanded(flex: 5, child: Text(row.label)),
          Expanded(
            flex: 4,
            child: Container(
              padding:
              const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              decoration: BoxDecoration(
                color: shade(1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  if (win == 1) const Icon(Icons.arrow_upward, size: 14),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      row.aValue,
                      style: TextStyle(color: textColor(1)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 4,
            child: Container(
              padding:
              const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              decoration: BoxDecoration(
                color: shade(2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  if (win == 2) const Icon(Icons.arrow_upward, size: 14),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      row.bValue,
                      style: TextStyle(color: textColor(2)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ========== Хелпер: формирование секций на основе CarDetails ========== */

List<Widget> _sectionsFromCarDb(
    db.CarDetails A,
    db.CarDetails B, {
      required bool hideEquals,
    }) {
  String n(num v, {int d = 1}) =>
      v % 1 == 0 ? v.toStringAsFixed(0) : v.toStringAsFixed(d);
  String yes(bool x) => x ? 'есть' : 'нет';

  final perf = DiffSection(
    title: 'Производительность',
    hideEquals: hideEquals,
    rows: [
      DiffRow('0–100 км/ч', '${n(A.perf.zeroTo100, d: 1)} с',
          '${n(B.perf.zeroTo100, d: 1)} с',
          higherIsBetter: false),
      DiffRow('Макс. скорость', '${n(A.perf.topSpeedKmh)} км/ч',
          '${n(B.perf.topSpeedKmh)} км/ч'),
      DiffRow('Мощность', '${n(A.perf.hp)} hp', '${n(B.perf.hp)} hp'),
      DiffRow('Крутящий момент', '${n(A.perf.torqueNm)} Н·м',
          '${n(B.perf.torqueNm)} Н·м'),
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
          A.battery != null
              ? '${n(A.battery!.capacityKwh)} кВт·ч'
              : '—',
          B.battery != null
              ? '${n(B.battery!.capacityKwh)} кВт·ч'
              : '—'),
      if (A.battery?.usableKwh != null ||
          B.battery?.usableKwh != null)
        DiffRow(
            'Ёмкость (нетто)',
            A.battery?.usableKwh != null
                ? '${n(A.battery!.usableKwh!)} кВт·ч'
                : '—',
            B.battery?.usableKwh != null
                ? '${n(B.battery!.usableKwh!)} кВт·ч'
                : '—'),
      if (A.battery?.rangeWltpKm != null ||
          B.battery?.rangeWltpKm != null)
        DiffRow(
            'WLTP запас',
            A.battery?.rangeWltpKm != null
                ? '${n(A.battery!.rangeWltpKm!)} км'
                : '—',
            B.battery?.rangeWltpKm != null
                ? '${n(B.battery!.rangeWltpKm!)} км'
                : '—'),
      if (A.battery?.rangeCltcKm != null ||
          B.battery?.rangeCltcKm != null)
        DiffRow(
            'CLTC запас',
            A.battery?.rangeCltcKm != null
                ? '${n(A.battery!.rangeCltcKm!)} км'
                : '—',
            B.battery?.rangeCltcKm != null
                ? '${n(B.battery!.rangeCltcKm!)} км'
                : '—'),
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
          A.charging != null
              ? '${n(A.charging!.acKw)} кВт'
              : '—',
          B.charging != null
              ? '${n(B.charging!.acKw)} кВт'
              : '—'),
      DiffRow(
          'DC пик',
          A.charging != null
              ? '${n(A.charging!.dcKwPeak)} кВт'
              : '—',
          B.charging != null
              ? '${n(B.charging!.dcKwPeak)} кВт'
              : '—'),
      DiffRow(
          '10–80%',
          A.charging != null
              ? '${A.charging!.dc10to80Min} мин'
              : '—',
          B.charging != null
              ? '${B.charging!.dc10to80Min} мин'
              : '—',
          higherIsBetter: false),
    ],
  )
      : const SizedBox.shrink();

  final dims = DiffSection(
    title: 'Размеры и практичность',
    hideEquals: hideEquals,
    rows: [
      DiffRow(
          'Д×Ш×В',
          '${A.dim.lengthMm}×${A.dim.widthMm}×${A.dim.heightMm} мм',
          '${B.dim.lengthMm}×${B.dim.widthMm}×${B.dim.heightMm} мм',
          compareAsText: true),
      DiffRow('Колёсная база', '${A.dim.wheelbaseMm} мм',
          '${B.dim.wheelbaseMm} мм'),
      if (A.dim.trunkL != 0 || B.dim.trunkL != 0)
        DiffRow('Багажник', '${A.dim.trunkL} л', '${B.dim.trunkL} л'),
    ],
  );

  final interior = DiffSection(
    title: 'Интерьер и комфорт',
    hideEquals: hideEquals,
    rows: [
      DiffRow('Мест', '${A.interior.seats}', '${B.interior.seats}'),
      DiffRow('Динамиков', '${A.interior.speakers}', '${B.interior.speakers}'),
      DiffRow('Массаж', yes(A.interior.massage), yes(B.interior.massage),
          compareAsText: true),
      DiffRow('Вентиляция', yes(A.interior.ventilation),
          yes(B.interior.ventilation),
          compareAsText: true),
      DiffRow('Холодильник', yes(A.interior.fridge), yes(B.interior.fridge),
          compareAsText: true),
    ],
  );

  final adas = DiffSection(
    title: 'ADAS и сенсоры',
    hideEquals: hideEquals,
    rows: [
      DiffRow('Уровень', A.adas.level, B.adas.level, compareAsText: true),
      DiffRow('Лидар', yes(A.adas.lidar), yes(B.adas.lidar),
          compareAsText: true),
      DiffRow('Камер', '${A.adas.cameras}', '${B.adas.cameras}'),
      DiffRow('Радаров', '${A.adas.radars}', '${B.adas.radars}'),
      DiffRow('Платформа', A.adas.stack, B.adas.stack, compareAsText: true),
    ],
  );

  final warranty = DiffSection(
    title: 'Гарантии',
    hideEquals: hideEquals,
    rows: [
      DiffRow('Базовая', '${A.warranty.baseYears} лет',
          '${B.warranty.baseYears} лет'),
      DiffRow('Расширенная', '${A.warranty.extYears} лет',
          '${B.warranty.extYears} лет'),
    ],
  );

  final pricing = DiffSection(
    title: 'Цена (CN)',
    hideEquals: hideEquals,
    rows: [
      DiffRow('MSRP мин', '${A.pricing.msrpCnyMin} ¥',
          '${B.pricing.msrpCnyMin} ¥',
          higherIsBetter: false),
      if (A.pricing.msrpCnyMax != null || B.pricing.msrpCnyMax != null)
        DiffRow(
            'MSRP макс',
            A.pricing.msrpCnyMax != null
                ? '${A.pricing.msrpCnyMax} ¥'
                : '—',
            B.pricing.msrpCnyMax != null
                ? '${B.pricing.msrpCnyMax} ¥'
                : '—',
            higherIsBetter: false),
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

