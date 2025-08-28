import 'package:equatable/equatable.dart';

class Interior extends Equatable {
  final int seats;
  final int speakers;
  final bool massage;
  final bool ventilation;
  final bool fridge;

  const Interior({
    required this.seats,
    required this.speakers,
    this.massage = false,
    this.ventilation = false,
    this.fridge = false,
  });

  Map<String, dynamic> toMap() => {
    'seats': seats,
    'speakers': speakers,
    'massage': massage ? 1 : 0,
    'ventilation': ventilation ? 1 : 0,
    'fridge': fridge ? 1 : 0,
  };

  factory Interior.fromMap(Map<String, dynamic> m) => Interior(
    seats: m['seats'] as int,
    speakers: m['speakers'] as int,
    massage: (m['massage'] as int? ?? 0) == 1,
    ventilation: (m['ventilation'] as int? ?? 0) == 1,
    fridge: (m['fridge'] as int? ?? 0) == 1,
  );

  @override
  List<Object?> get props => [seats, speakers, massage, ventilation, fridge];
}
