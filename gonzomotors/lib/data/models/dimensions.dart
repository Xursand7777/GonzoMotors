import 'package:equatable/equatable.dart';

class Dimensions extends Equatable {
  final int lengthMm, widthMm, heightMm, wheelbaseMm;
  final int trunkL;

  const Dimensions({
    required this.lengthMm,
    required this.widthMm,
    required this.heightMm,
    required this.wheelbaseMm,
    this.trunkL = 0,
  });

  Map<String, dynamic> toMap() => {
    'lengthMm': lengthMm, 'widthMm': widthMm, 'heightMm': heightMm,
    'wheelbaseMm': wheelbaseMm, 'trunkL': trunkL,
  };

  factory Dimensions.fromMap(Map<String, dynamic> m) => Dimensions(
    lengthMm: m['lengthMm'] as int,
    widthMm: m['widthMm'] as int,
    heightMm: m['heightMm'] as int,
    wheelbaseMm: m['wheelbaseMm'] as int,
    trunkL: m['trunkL'] as int? ?? 0,
  );

  @override
  List<Object?> get props => [lengthMm, widthMm, heightMm, wheelbaseMm, trunkL];
}
