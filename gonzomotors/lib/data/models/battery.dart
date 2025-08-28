import 'package:equatable/equatable.dart';

class Battery extends Equatable {
  final double capacityKwh;
  final double? usableKwh;
  final double? rangeWltpKm;
  final double? rangeCltcKm;

  const Battery({
    required this.capacityKwh,
    this.usableKwh,
    this.rangeWltpKm,
    this.rangeCltcKm,
  });

  Map<String, dynamic> toMap() => {
    'capacityKwh': capacityKwh,
    'usableKwh': usableKwh,
    'rangeWltpKm': rangeWltpKm,
    'rangeCltcKm': rangeCltcKm,
  };

  factory Battery.fromMap(Map<String, dynamic> m) => Battery(
    capacityKwh: (m['capacityKwh'] as num).toDouble(),
    usableKwh: (m['usableKwh'] as num?)?.toDouble(),
    rangeWltpKm: (m['rangeWltpKm'] as num?)?.toDouble(),
    rangeCltcKm: (m['rangeCltcKm'] as num?)?.toDouble(),
  );

  @override
  List<Object?> get props => [capacityKwh, usableKwh, rangeWltpKm, rangeCltcKm];
}
