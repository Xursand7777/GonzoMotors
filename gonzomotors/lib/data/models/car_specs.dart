import 'package:equatable/equatable.dart';
import '../../core/enums/car.dart';

class CarSpecs extends Equatable {
  final String name;             // 'Lucid Air (2025)'
  final Map<Car, double> norm;   // для радара
  final int seats;
  final int speakers;
  final int baseWarrantyYears;
  final int extWarrantyYears;

  const CarSpecs({
    required this.name,
    required this.norm,
    required this.seats,
    required this.speakers,
    required this.baseWarrantyYears,
    required this.extWarrantyYears,
  });

  /// Сохранение в Map (например, для JSON / sqflite)
  Map<String, dynamic> toMap() => {
    'name': name,
    'norm': norm.map((k, v) => MapEntry(k.name, v)),
    'seats': seats,
    'speakers': speakers,
    'baseWarrantyYears': baseWarrantyYears,
    'extWarrantyYears': extWarrantyYears,
  };

  /// Восстановление из Map
  factory CarSpecs.fromMap(Map<String, dynamic> map) => CarSpecs(
    name: map['name'] as String,
    norm: (map['norm'] as Map).map((k, v) => MapEntry(
      Car.values.firstWhere((e) => e.name == k),
      (v as num).toDouble(),
    )),
    seats: map['seats'] as int,
    speakers: map['speakers'] as int,
    baseWarrantyYears: map['baseWarrantyYears'] as int,
    extWarrantyYears: map['extWarrantyYears'] as int,
  );

  @override
  List<Object?> get props =>
      [name, norm, seats, speakers, baseWarrantyYears, extWarrantyYears];
}
