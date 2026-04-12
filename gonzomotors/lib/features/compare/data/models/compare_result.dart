class CompareResult {
  final ComparedCar car1;
  final ComparedCar car2;
  final PriceComparison? price;
  final GeneralInfoComparison? generalInfo;
  final PerformanceComparison? performance;
  final DimensionsComparison? dimensions;
  final VolumeMassComparison? volumeMass;
  final BatteryComparison? battery;
  final EngineComparison? engine;
  final TransmissionComparison? transmission;
  final MultimediaComparison? multimedia;

  CompareResult({
    required this.car1,
    required this.car2,
    this.price,
    this.generalInfo,
    this.performance,
    this.dimensions,
    this.volumeMass,
    this.battery,
    this.engine,
    this.transmission,
    this.multimedia,
  });

  factory CompareResult.fromJson(Map<String, dynamic> json) {
    return CompareResult(
      car1: ComparedCar.fromJson(json['car1']),
      car2: ComparedCar.fromJson(json['car2']),
      price: json['price'] != null ? PriceComparison.fromJson(json['price']) : null,
      generalInfo: json['generalInfo'] != null ? GeneralInfoComparison.fromJson(json['generalInfo']) : null,
      performance: json['performance'] != null ? PerformanceComparison.fromJson(json['performance']) : null,
      dimensions: json['dimensions'] != null ? DimensionsComparison.fromJson(json['dimensions']) : null,
      volumeMass: json['volumeMass'] != null ? VolumeMassComparison.fromJson(json['volumeMass']) : null,
      battery: json['battery'] != null ? BatteryComparison.fromJson(json['battery']) : null,
      engine: json['engine'] != null ? EngineComparison.fromJson(json['engine']) : null,
      transmission: json['transmission'] != null ? TransmissionComparison.fromJson(json['transmission']) : null,
      multimedia: json['multimedia'] != null ? MultimediaComparison.fromJson(json['multimedia']) : null,
    );
  }
}

class ComparedCar {
  final int id;
  final String carName;

  ComparedCar({required this.id, required this.carName});

  factory ComparedCar.fromJson(Map<String, dynamic> json) {
    return ComparedCar(
      id: json['id'] as int,
      carName: json['carName'] as String,
    );
  }
}

enum ComparisonWinner {
  none(0),
  car1(1),
  car2(2);

  final int value;
  const ComparisonWinner(this.value);

  factory ComparisonWinner.fromInt(int val) {
    return ComparisonWinner.values.firstWhere((e) => e.value == val, orElse: () => ComparisonWinner.none);
  }
}

class ComparisonValue<T> {
  final T? value1;
  final T? value2;
  final bool isDifferent;
  final String? difference;
  final ComparisonWinner winner;

  ComparisonValue({
    this.value1,
    this.value2,
    this.isDifferent = false,
    this.difference,
    this.winner = ComparisonWinner.none,
  });

  factory ComparisonValue.fromJson(Map<String, dynamic> json, T Function(dynamic) parser) {
    return ComparisonValue(
      value1: json['value1'] != null ? parser(json['value1']) : null,
      value2: json['value2'] != null ? parser(json['value2']) : null,
      isDifferent: json['isDifferent'] ?? false,
      difference: json['difference'] as String?,
      winner: ComparisonWinner.fromInt(json['winner'] ?? 0),
    );
  }
}

// Data sections (simplified for demonstration, will parse recursively)
class PriceComparison {
  final ComparisonValue<num> price;
  PriceComparison({required this.price});
  factory PriceComparison.fromJson(Map<String, dynamic> json) => PriceComparison(
    price: ComparisonValue.fromJson(json['price'] ?? {}, (v) => v as num),
  );
}

class GeneralInfoComparison {
  final ComparisonValue<num> doorCount;
  final ComparisonValue<num> seatCount;
  final ComparisonValue<String> steeringPosition;
  GeneralInfoComparison({required this.doorCount, required this.seatCount, required this.steeringPosition});
  factory GeneralInfoComparison.fromJson(Map<String, dynamic> json) => GeneralInfoComparison(
    doorCount: ComparisonValue.fromJson(json['doorCount'] ?? {}, (v) => v as num),
    seatCount: ComparisonValue.fromJson(json['seatCount'] ?? {}, (v) => v as num),
    steeringPosition: ComparisonValue.fromJson(json['steeringPosition'] ?? {}, (v) => v as String),
  );
}

class PerformanceComparison {
  final ComparisonValue<num> zeroTo100;
  final ComparisonValue<num> maxSpeed;
  final ComparisonValue<num> totalPowerHp;
  final ComparisonValue<String> driveType;
  PerformanceComparison({required this.zeroTo100, required this.maxSpeed, required this.totalPowerHp, required this.driveType});
  factory PerformanceComparison.fromJson(Map<String, dynamic> json) => PerformanceComparison(
    zeroTo100: ComparisonValue.fromJson(json['zeroTo100'] ?? {}, (v) => v as num),
    maxSpeed: ComparisonValue.fromJson(json['maxSpeed'] ?? {}, (v) => v as num),
    totalPowerHp: ComparisonValue.fromJson(json['totalPowerHp'] ?? {}, (v) => v as num),
    driveType: ComparisonValue.fromJson(json['driveType'] ?? {}, (v) => v as String), // Might be in transmission
  );
}

class BatteryComparison {
  final ComparisonValue<num> capacityKwh;
  final ComparisonValue<num> fastChargingHours;
  final ComparisonValue<num> slowChargingHours;
  final ComparisonValue<num> electricRangeKm;
  BatteryComparison({required this.capacityKwh, required this.fastChargingHours, required this.slowChargingHours, required this.electricRangeKm});
  
  factory BatteryComparison.fromJson(Map<String, dynamic> json) => BatteryComparison(
    capacityKwh: ComparisonValue.fromJson(json['capacityKwh'] ?? {}, (v) => v as num),
    fastChargingHours: ComparisonValue.fromJson(json['fastChargingHours'] ?? {}, (v) => v as num),
    slowChargingHours: ComparisonValue.fromJson(json['slowChargingHours'] ?? {}, (v) => v as num),
    electricRangeKm: ComparisonValue.fromJson(json['electricRangeKm'] ?? {}, (v) => v as num),
  );
}

class DimensionsComparison {
  final ComparisonValue<num> lengthMm;
  final ComparisonValue<num> widthMm;
  final ComparisonValue<num> heightMm;
  final ComparisonValue<num> wheelBase; // May need mapping based on specific names
  DimensionsComparison({required this.lengthMm, required this.widthMm, required this.heightMm, required this.wheelBase});
  factory DimensionsComparison.fromJson(Map<String, dynamic> json) => DimensionsComparison(
    lengthMm: ComparisonValue.fromJson(json['lengthMm'] ?? {}, (v) => v as num),
    widthMm: ComparisonValue.fromJson(json['widthMm'] ?? {}, (v) => v as num),
    heightMm: ComparisonValue.fromJson(json['heightMm'] ?? {}, (v) => v as num),
    wheelBase: ComparisonValue.fromJson(json['wheelBase'] ?? {}, (v) => v as num), // Example, double check property names
  );
}

class VolumeMassComparison {
  final ComparisonValue<num> trunkVolumeMax;
  VolumeMassComparison({required this.trunkVolumeMax});
  factory VolumeMassComparison.fromJson(Map<String, dynamic> json) => VolumeMassComparison(
    trunkVolumeMax: ComparisonValue.fromJson(json['trunkVolumeMax'] ?? {}, (v) => v as num),
  );
}

class EngineComparison {
  final ComparisonValue<num> maxElectricPowerHp;
  EngineComparison({required this.maxElectricPowerHp});
  factory EngineComparison.fromJson(Map<String, dynamic> json) => EngineComparison(
    maxElectricPowerHp: ComparisonValue.fromJson(json['maxElectricPowerHp'] ?? {}, (v) => v as num),
  );
}

class TransmissionComparison {
  final ComparisonValue<String> driveType;
  TransmissionComparison({required this.driveType});
  factory TransmissionComparison.fromJson(Map<String, dynamic> json) => TransmissionComparison(
    driveType: ComparisonValue.fromJson(json['driveType'] ?? {}, (v) => v as String),
  );
}

class MultimediaComparison {
  final ComparisonValue<num> speakers;
  final ComparisonValue<bool> hasMassage;
  final ComparisonValue<bool> hasVentilation;
  
  MultimediaComparison({required this.speakers, required this.hasMassage, required this.hasVentilation});
  factory MultimediaComparison.fromJson(Map<String, dynamic> json) => MultimediaComparison(
    speakers: ComparisonValue.fromJson(json['speakers'] ?? {}, (v) => v as num),
    hasMassage: ComparisonValue.fromJson(json['hasMassage'] ?? {}, (v) => v as bool),
    hasVentilation: ComparisonValue.fromJson(json['hasVentilation'] ?? {}, (v) => v as bool),
  );
}
