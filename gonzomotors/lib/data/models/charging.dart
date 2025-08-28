import 'package:equatable/equatable.dart';

class Charging extends Equatable {
  final double acKw;
  final double dcKwPeak;
  final int dc10to80Min;

  const Charging({
    required this.acKw,
    required this.dcKwPeak,
    required this.dc10to80Min,
  });

  Map<String, dynamic> toMap() => {
    'acKw': acKw, 'dcKwPeak': dcKwPeak, 'dc10to80Min': dc10to80Min,
  };

  factory Charging.fromMap(Map<String, dynamic> m) => Charging(
    acKw: (m['acKw'] as num).toDouble(),
    dcKwPeak: (m['dcKwPeak'] as num).toDouble(),
    dc10to80Min: m['dc10to80Min'] as int,
  );

  @override
  List<Object?> get props => [acKw, dcKwPeak, dc10to80Min];
}
