import 'package:equatable/equatable.dart';

class Pricing extends Equatable {
  final int points;
  final int msrpCnyMin;
  final int? msrpCnyMax;

  const Pricing({
    required this.points,
    required this.msrpCnyMin,
    this.msrpCnyMax,
  });

  Map<String, dynamic> toMap() => {
    'points': points,
    'msrpCnyMin': msrpCnyMin,
    'msrpCnyMax': msrpCnyMax,
  };

  factory Pricing.fromMap(Map<String, dynamic> m) => Pricing(
    points: m['points'] as int,
    msrpCnyMin: m['msrpCnyMin'] as int,
    msrpCnyMax: m['msrpCnyMax'] as int?,
  );

  @override
  List<Object?> get props => [points, msrpCnyMin, msrpCnyMax];
}
