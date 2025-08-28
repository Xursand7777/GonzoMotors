import 'package:equatable/equatable.dart';

class Warranty extends Equatable {
  final int baseYears;
  final int extYears;

  const Warranty({required this.baseYears, required this.extYears});

  Map<String, dynamic> toMap() => {
    'baseYears': baseYears, 'extYears': extYears,
  };

  factory Warranty.fromMap(Map<String, dynamic> m) => Warranty(
    baseYears: m['baseYears'] as int,
    extYears: m['extYears'] as int,
  );

  @override
  List<Object?> get props => [baseYears, extYears];
}
