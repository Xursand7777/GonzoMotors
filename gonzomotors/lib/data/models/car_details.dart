import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '../../core/enums/car.dart';
import 'performance.dart';
import 'battery.dart';
import 'charging.dart';
import 'dimensions.dart';
import 'driver_assist.dart';
import 'interior.dart';
import 'warranty.dart';
import 'pricing.dart';
import 'car_info.dart';
import 'car_specs.dart';

class CarDetails extends Equatable {
  final String id;
  final String name;
  final int year;

  final String bodyType;     // Sedan / SUV / Liftback...
  final String powertrain;   // Electric / Hybrid / EREV / ICE

  final String imageCard;
  final List<String> gallery;

  final Performance perf;
  final Battery? battery;
  final Charging? charging;
  final Dimensions dim;
  final DriverAssist adas;
  final Interior interior;
  final Warranty warranty;
  final Pricing pricing;

  final Map<Car, double> norm;
  final List<String> pros;
  final List<String> cons;
  final List<String> tags;

  const CarDetails({
    required this.id,
    required this.name,
    required this.year,
    required this.bodyType,
    required this.powertrain,
    required this.imageCard,
    this.gallery = const [],
    required this.perf,
    this.battery,
    this.charging,
    required this.dim,
    required this.adas,
    required this.interior,
    required this.warranty,
    required this.pricing,
    required this.norm,
    this.pros = const [],
    this.cons = const [],
    this.tags = const [],
  });

  // Преобразования для твоих экранов
  CarInfo toCard() => CarInfo(
    id: id,
    name: name,
    year: year,
    bodyType: bodyType,
    powertrain: powertrain,
    topSpeedKmh: perf.topSpeedKmh.round(),
    horsepower: perf.hp.round(),
    points: pricing.points,
    imageUrl: imageCard,
    norm: norm,
    seats: interior.seats,
    speakers: interior.speakers,
    baseWarrantyYears: warranty.baseYears,
    extWarrantyYears: warranty.extYears,
  );

  CarSpecs toCompare() => CarSpecs(
    name: '$name ($year)',
    norm: norm,
    seats: interior.seats,
    speakers: interior.speakers,
    baseWarrantyYears: warranty.baseYears,
    extWarrantyYears: warranty.extYears,
  );

  // Для sqflite/JSON: сохраняем вложенные как map и список строк
  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'year': year,
    'bodyType': bodyType,
    'powertrain': powertrain,
    'imageCard': imageCard,
    'gallery': gallery,
    'perf': perf.toMap(),
    'battery': battery?.toMap(),
    'charging': charging?.toMap(),
    'dim': dim.toMap(),
    'adas': adas.toMap(),
    'interior': interior.toMap(),
    'warranty': warranty.toMap(),
    'pricing': pricing.toMap(),
    'norm': norm.map((k, v) => MapEntry(k.name, v)),
    'pros': pros,
    'cons': cons,
    'tags': tags,
  };

  factory CarDetails.fromMap(Map<String, dynamic> m) => CarDetails(
    id: m['id'] as String,
    name: m['name'] as String,
    year: m['year'] as int,
    bodyType: m['bodyType'] as String,
    powertrain: m['powertrain'] as String,
    imageCard: m['imageCard'] as String,
    gallery: (m['gallery'] as List?)?.cast<String>() ?? const [],
    perf: Performance.fromMap(Map<String, dynamic>.from(m['perf'] as Map)),
    battery: m['battery'] == null ? null : Battery.fromMap(Map<String, dynamic>.from(m['battery'] as Map)),
    charging: m['charging'] == null ? null : Charging.fromMap(Map<String, dynamic>.from(m['charging'] as Map)),
    dim: Dimensions.fromMap(Map<String, dynamic>.from(m['dim'] as Map)),
    adas: DriverAssist.fromMap(Map<String, dynamic>.from(m['adas'] as Map)),
    interior: Interior.fromMap(Map<String, dynamic>.from(m['interior'] as Map)),
    warranty: Warranty.fromMap(Map<String, dynamic>.from(m['warranty'] as Map)),
    pricing: Pricing.fromMap(Map<String, dynamic>.from(m['pricing'] as Map)),
    norm: (m['norm'] as Map).map((k, v) => MapEntry(
      Car.values.firstWhere((e) => describeEnum(e) == k),
      (v as num).toDouble(),
    )),
    pros: (m['pros'] as List?)?.cast<String>() ?? const [],
    cons: (m['cons'] as List?)?.cast<String>() ?? const [],
    tags: (m['tags'] as List?)?.cast<String>() ?? const [],
  );

  @override
  List<Object?> get props => [
    id, name, year, bodyType, powertrain, imageCard, gallery, perf, battery,
    charging, dim, adas, interior, warranty, pricing, norm, pros, cons, tags
  ];
}
