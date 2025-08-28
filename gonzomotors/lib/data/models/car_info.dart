import 'package:equatable/equatable.dart';
import 'package:collection/collection.dart';
import '../../core/enums/car.dart';

class CarInfo extends Equatable {
  final String id;
  final String name;
  final int year;
  final String bodyType;
  final String powertrain;
  final int topSpeedKmh;
  final int horsepower;
  final int points;
  final String imageUrl;
  final Map<Car, double> norm;
  final int seats, speakers, baseWarrantyYears, extWarrantyYears;

  const CarInfo({
    required this.id,
    required this.name,
    required this.year,
    required this.bodyType,
    required this.powertrain,
    required this.topSpeedKmh,
    required this.horsepower,
    required this.points,
    required this.imageUrl,
    required this.norm,
    this.seats = 5,
    this.speakers = 15,
    this.baseWarrantyYears = 3,
    this.extWarrantyYears = 5,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'year': year,
    'bodyType': bodyType,
    'powertrain': powertrain,
    'topSpeedKmh': topSpeedKmh,
    'horsepower': horsepower,
    'points': points,
    'imageUrl': imageUrl,
    'norm': norm.map((k, v) => MapEntry(k.name, v)),
    'seats': seats,
    'speakers': speakers,
    'baseWarrantyYears': baseWarrantyYears,
    'extWarrantyYears': extWarrantyYears,
  };

  factory CarInfo.fromMap(Map<String, dynamic> m) => CarInfo(
    id: m['id'] as String,
    name: m['name'] as String,
    year: m['year'] as int,
    bodyType: m['bodyType'] as String,
    powertrain: m['powertrain'] as String,
    topSpeedKmh: m['topSpeedKmh'] as int,
    horsepower: m['horsepower'] as int,
    points: m['points'] as int,
    imageUrl: m['imageUrl'] as String,
    norm: (m['norm'] as Map).map((k, v) => MapEntry(
      Car.values.firstWhere((e) => e.name == k),
      (v as num).toDouble(),
    )),
    seats: m['seats'] as int? ?? 5,
    speakers: m['speakers'] as int? ?? 15,
    baseWarrantyYears: m['baseWarrantyYears'] as int? ?? 3,
    extWarrantyYears: m['extWarrantyYears'] as int? ?? 5,
  );

  @override
  List<Object?> get props => [
    id, name, year, bodyType, powertrain, topSpeedKmh, horsepower, points,
    imageUrl, const DeepCollectionEquality().hash(norm),
    seats, speakers, baseWarrantyYears, extWarrantyYears
  ];
}
