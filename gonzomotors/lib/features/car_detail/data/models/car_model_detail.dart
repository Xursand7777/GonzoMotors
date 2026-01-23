class CarModelDetail {
  final int id;
  final String carName;
  final int modelYear;
  final String powertrain;
  final int modelId;
  final int bodyTypeId;
  final String carBodyType;

  final CarCharacteristics? characteristics;
  final List<CarOption> options;

  final String model;
  final List<CarImage> images;

  final num price;
  final num cipPrice;

  CarModelDetail({
    required this.id,
    required this.carName,
    required this.modelYear,
    required this.powertrain,
    required this.modelId,
    required this.bodyTypeId,
    required this.carBodyType,
    required this.characteristics,
    required this.options,
    required this.model,
    required this.images,
    required this.price,
    required this.cipPrice,
  });

  factory CarModelDetail.fromJson(Map<String, dynamic> json) {
    return CarModelDetail(
      id: (json['id'] ?? 0) as int,
      carName: (json['carName'] ?? '') as String,
      modelYear: (json['modelYear'] ?? 0) as int,
      powertrain: (json['powertrain'] ?? '') as String,
      modelId: (json['modelId'] ?? 0) as int,
      bodyTypeId: (json['bodyTypeId'] ?? 0) as int,
      carBodyType: (json['carBodyType'] ?? '') as String,
      characteristics: json['characteristics'] == null
          ? null
          : CarCharacteristics.fromJson(
        json['characteristics'] as Map<String, dynamic>,
      ),
      options: (json['options'] as List? ?? [])
          .map((e) => CarOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      model: (json['model'] ?? '') as String,
      images: (json['images'] as List? ?? [])
          .map((e) => CarImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      price: (json['price'] ?? 0) as num,
      cipPrice: (json['cipPrice'] ?? 0) as num,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'carName': carName,
    'modelYear': modelYear,
    'powertrain': powertrain,
    'modelId': modelId,
    'bodyTypeId': bodyTypeId,
    'carBodyType': carBodyType,
    'characteristics': characteristics?.toJson(),
    'options': options.map((e) => e.toJson()).toList(),
    'model': model,
    'images': images.map((e) => e.toJson()).toList(),
    'price': price,
    'cipPrice': cipPrice,
  };
}

class CarCharacteristics {
  final int carId;
  final CarGeneralInfo? generalInfo;
  final CarPerformance? performance;
  final CarDimensions? dimensions;
  final CarVolumeMass? volumeMass;
  final CarBattery? battery;
  final CarEngine? engine;
  final CarTransmission? transmission;
  final CarMultimedia? multimedia;

  CarCharacteristics({
    required this.carId,
    required this.generalInfo,
    required this.performance,
    required this.dimensions,
    required this.volumeMass,
    required this.battery,
    required this.engine,
    required this.transmission,
    required this.multimedia,
  });

  factory CarCharacteristics.fromJson(Map<String, dynamic> json) {
    return CarCharacteristics(
      carId: (json['carId'] ?? 0) as int,
      generalInfo: json['generalInfo'] == null
          ? null
          : CarGeneralInfo.fromJson(json['generalInfo'] as Map<String, dynamic>),
      performance: json['performance'] == null
          ? null
          : CarPerformance.fromJson(json['performance'] as Map<String, dynamic>),
      dimensions: json['dimensions'] == null
          ? null
          : CarDimensions.fromJson(json['dimensions'] as Map<String, dynamic>),
      volumeMass: json['volumeMass'] == null
          ? null
          : CarVolumeMass.fromJson(json['volumeMass'] as Map<String, dynamic>),
      battery: json['battery'] == null
          ? null
          : CarBattery.fromJson(json['battery'] as Map<String, dynamic>),
      engine: json['engine'] == null
          ? null
          : CarEngine.fromJson(json['engine'] as Map<String, dynamic>),
      transmission: json['transmission'] == null
          ? null
          : CarTransmission.fromJson(
        json['transmission'] as Map<String, dynamic>,
      ),
      multimedia: json['multimedia'] == null
          ? null
          : CarMultimedia.fromJson(json['multimedia'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'carId': carId,
    'generalInfo': generalInfo?.toJson(),
    'performance': performance?.toJson(),
    'dimensions': dimensions?.toJson(),
    'volumeMass': volumeMass?.toJson(),
    'battery': battery?.toJson(),
    'engine': engine?.toJson(),
    'transmission': transmission?.toJson(),
    'multimedia': multimedia?.toJson(),
  };
}

class CarGeneralInfo {
  final int? steeringPositionType;

  CarGeneralInfo({required this.steeringPositionType});

  factory CarGeneralInfo.fromJson(Map<String, dynamic> json) {
    return CarGeneralInfo(
      steeringPositionType: json['steeringPositionType'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'steeringPositionType': steeringPositionType,
  };
}

class CarPerformance {
  final int carId;
  final num? zeroTo100;
  final num? maxSpeed;
  final String? fuelConsumption;
  final num? electricConsumption;

  CarPerformance({
    required this.carId,
    required this.zeroTo100,
    required this.maxSpeed,
    required this.fuelConsumption,
    required this.electricConsumption,
  });

  factory CarPerformance.fromJson(Map<String, dynamic> json) {
    return CarPerformance(
      carId: (json['carId'] ?? 0) as int,
      zeroTo100: json['zeroTo100'] as num?,
      maxSpeed: json['maxSpeed'] as num?,
      fuelConsumption: json['fuelConsumption'] as String?,
      electricConsumption: json['electricConsumption'] as num?,
    );
  }

  Map<String, dynamic> toJson() => {
    'carId': carId,
    'zeroTo100': zeroTo100,
    'maxSpeed': maxSpeed,
    'fuelConsumption': fuelConsumption,
    'electricConsumption': electricConsumption,
  };
}

class CarDimensions {
  final int carId;
  final num? lengthMm;
  final num? widthMm;
  final num? heightMm;

  final int? wheelDiskMaterialTypeId;

  final num? frontWidthMm;
  final num? frontAspectRatio;
  final num? frontRimDiameterInch;

  final num? rearWidthMm;
  final num? rearAspectRatio;
  final num? rearRimDiameterInch;

  final String? wheelDiskMaterialType;

  CarDimensions({
    required this.carId,
    required this.lengthMm,
    required this.widthMm,
    required this.heightMm,
    required this.wheelDiskMaterialTypeId,
    required this.frontWidthMm,
    required this.frontAspectRatio,
    required this.frontRimDiameterInch,
    required this.rearWidthMm,
    required this.rearAspectRatio,
    required this.rearRimDiameterInch,
    required this.wheelDiskMaterialType,
  });

  factory CarDimensions.fromJson(Map<String, dynamic> json) {
    return CarDimensions(
      carId: (json['carId'] ?? 0) as int,
      lengthMm: json['lengthMm'] as num?,
      widthMm: json['widthMm'] as num?,
      heightMm: json['heightMm'] as num?,
      wheelDiskMaterialTypeId: json['wheelDiskMaterialTypeId'] as int?,
      frontWidthMm: json['frontWidthMm'] as num?,
      frontAspectRatio: json['frontAspectRatio'] as num?,
      frontRimDiameterInch: json['frontRimDiameterInch'] as num?,
      rearWidthMm: json['rearWidthMm'] as num?,
      rearAspectRatio: json['rearAspectRatio'] as num?,
      rearRimDiameterInch: json['rearRimDiameterInch'] as num?,
      wheelDiskMaterialType: json['wheelDiskMaterialType'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'carId': carId,
    'lengthMm': lengthMm,
    'widthMm': widthMm,
    'heightMm': heightMm,
    'wheelDiskMaterialTypeId': wheelDiskMaterialTypeId,
    'frontWidthMm': frontWidthMm,
    'frontAspectRatio': frontAspectRatio,
    'frontRimDiameterInch': frontRimDiameterInch,
    'rearWidthMm': rearWidthMm,
    'rearAspectRatio': rearAspectRatio,
    'rearRimDiameterInch': rearRimDiameterInch,
    'wheelDiskMaterialType': wheelDiskMaterialType,
  };
}

class CarVolumeMass {
  final int carId;
  final num? trunkVolumeMin;
  final num? trunkVolumeMax;
  final num? curbWeight;
  final num? grossWeight;

  CarVolumeMass({
    required this.carId,
    required this.trunkVolumeMin,
    required this.trunkVolumeMax,
    required this.curbWeight,
    required this.grossWeight,
  });

  factory CarVolumeMass.fromJson(Map<String, dynamic> json) {
    return CarVolumeMass(
      carId: (json['carId'] ?? 0) as int,
      trunkVolumeMin: json['trunkVolumeMin'] as num?,
      trunkVolumeMax: json['trunkVolumeMax'] as num?,
      curbWeight: json['curbWeight'] as num?,
      grossWeight: json['grossWeight'] as num?,
    );
  }

  Map<String, dynamic> toJson() => {
    'carId': carId,
    'trunkVolumeMin': trunkVolumeMin,
    'trunkVolumeMax': trunkVolumeMax,
    'curbWeight': curbWeight,
    'grossWeight': grossWeight,
  };
}

class CarBattery {
  final int carId;
  final num? capacityKwh;
  final num? fastChargingHours;
  final num? slowChargingHours;

  final int? coolingTypeId;
  final int? batteryTypeId;

  final bool? hasPreHeating;

  final String? coolingType;
  final String? batteryType;

  CarBattery({
    required this.carId,
    required this.capacityKwh,
    required this.fastChargingHours,
    required this.slowChargingHours,
    required this.coolingTypeId,
    required this.batteryTypeId,
    required this.hasPreHeating,
    required this.coolingType,
    required this.batteryType,
  });

  factory CarBattery.fromJson(Map<String, dynamic> json) {
    return CarBattery(
      carId: (json['carId'] ?? 0) as int,
      capacityKwh: json['capacityKwh'] as num?,
      fastChargingHours: json['fastChargingHours'] as num?,
      slowChargingHours: json['slowChargingHours'] as num?,
      coolingTypeId: json['coolingTypeId'] as int?,
      batteryTypeId: json['batteryTypeId'] as int?,
      hasPreHeating: json['hasPreHeating'] as bool?,
      coolingType: json['coolingType'] as String?,
      batteryType: json['batteryType'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'carId': carId,
    'capacityKwh': capacityKwh,
    'fastChargingHours': fastChargingHours,
    'slowChargingHours': slowChargingHours,
    'coolingTypeId': coolingTypeId,
    'batteryTypeId': batteryTypeId,
    'hasPreHeating': hasPreHeating,
    'coolingType': coolingType,
    'batteryType': batteryType,
  };
}

class CarEngine {
  final int carId;

  final num? maxElectricPowerHp;
  final num? frontMotorPowerKw;
  final num? rearMotorPowerKw;
  final num? totalPowerKw;
  final num? totalPowerHp;
  final num? torqueNm;
  final num? motorCount;

  final int? electricMotorTypeId;

  final num? cylinderCount;
  final num? hp;

  final int? fuelTypeId;
  final String? fuelType;

  final String? engineModel;
  final num? icePowerKw;
  final num? engineVolumeCc;

  final String? intakeSystem;

  final int? fuelInjectionTypeId;
  final int? engineTypeId;

  final String? fuelInjectionType;
  final String? engineType;
  final String? electricMotorType;

  CarEngine({
    required this.carId,
    required this.maxElectricPowerHp,
    required this.frontMotorPowerKw,
    required this.rearMotorPowerKw,
    required this.totalPowerKw,
    required this.totalPowerHp,
    required this.torqueNm,
    required this.motorCount,
    required this.electricMotorTypeId,
    required this.cylinderCount,
    required this.hp,
    required this.fuelTypeId,
    required this.fuelType,
    required this.engineModel,
    required this.icePowerKw,
    required this.engineVolumeCc,
    required this.intakeSystem,
    required this.fuelInjectionTypeId,
    required this.engineTypeId,
    required this.fuelInjectionType,
    required this.engineType,
    required this.electricMotorType,
  });

  factory CarEngine.fromJson(Map<String, dynamic> json) {
    return CarEngine(
      carId: (json['carId'] ?? 0) as int,
      maxElectricPowerHp: json['maxElectricPowerHp'] as num?,
      frontMotorPowerKw: json['frontMotorPowerKw'] as num?,
      rearMotorPowerKw: json['rearMotorPowerKw'] as num?,
      totalPowerKw: json['totalPowerKw'] as num?,
      totalPowerHp: json['totalPowerHp'] as num?,
      torqueNm: json['torqueNm'] as num?,
      motorCount: json['motorCount'] as num?,
      electricMotorTypeId: json['electricMotorTypeId'] as int?,
      cylinderCount: json['cylinderCount'] as num?,
      hp: json['hp'] as num?,
      fuelTypeId: json['fuelTypeId'] as int?,
      fuelType: json['fuelType'] as String?,
      engineModel: json['engineModel'] as String?,
      icePowerKw: json['icePowerKw'] as num?,
      engineVolumeCc: json['engineVolumeCc'] as num?,
      intakeSystem: json['intakeSystem'] as String?,
      fuelInjectionTypeId: json['fuelInjectionTypeId'] as int?,
      engineTypeId: json['engineTypeId'] as int?,
      fuelInjectionType: json['fuelInjectionType'] as String?,
      engineType: json['engineType'] as String?,
      electricMotorType: json['electricMotorType'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'carId': carId,
    'maxElectricPowerHp': maxElectricPowerHp,
    'frontMotorPowerKw': frontMotorPowerKw,
    'rearMotorPowerKw': rearMotorPowerKw,
    'totalPowerKw': totalPowerKw,
    'totalPowerHp': totalPowerHp,
    'torqueNm': torqueNm,
    'motorCount': motorCount,
    'electricMotorTypeId': electricMotorTypeId,
    'cylinderCount': cylinderCount,
    'hp': hp,
    'fuelTypeId': fuelTypeId,
    'fuelType': fuelType,
    'engineModel': engineModel,
    'icePowerKw': icePowerKw,
    'engineVolumeCc': engineVolumeCc,
    'intakeSystem': intakeSystem,
    'fuelInjectionTypeId': fuelInjectionTypeId,
    'engineTypeId': engineTypeId,
    'fuelInjectionType': fuelInjectionType,
    'engineType': engineType,
    'electricMotorType': electricMotorType,
  };
}

class CarTransmission {
  final int carId;
  final int? gearCount;

  final int? transmissionTypeId;
  final int? driveTypeId;

  final String? driveType;
  final String? transmissionType;

  CarTransmission({
    required this.carId,
    required this.gearCount,
    required this.transmissionTypeId,
    required this.driveTypeId,
    required this.driveType,
    required this.transmissionType,
  });

  factory CarTransmission.fromJson(Map<String, dynamic> json) {
    return CarTransmission(
      carId: (json['carId'] ?? 0) as int,
      gearCount: json['gearCount'] as int?,
      transmissionTypeId: json['transmissionTypeId'] as int?,
      driveTypeId: json['driveTypeId'] as int?,
      driveType: json['driveType'] as String?,
      transmissionType: json['transmissionType'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'carId': carId,
    'gearCount': gearCount,
    'transmissionTypeId': transmissionTypeId,
    'driveTypeId': driveTypeId,
    'driveType': driveType,
    'transmissionType': transmissionType,
  };
}

class CarMultimedia {
  // Сейчас в JSON это null.
  // Добавишь поля — расширим модель.
  CarMultimedia();

  factory CarMultimedia.fromJson(Map<String, dynamic> json) => CarMultimedia();

  Map<String, dynamic> toJson() => {};
}

class CarOption {
  final int carId;
  final int optionId;
  final int optionCategoryId;
  final String optionCategory;
  final String option;

  CarOption({
    required this.carId,
    required this.optionId,
    required this.optionCategoryId,
    required this.optionCategory,
    required this.option,
  });

  factory CarOption.fromJson(Map<String, dynamic> json) {
    return CarOption(
      carId: (json['carId'] ?? 0) as int,
      optionId: (json['optionId'] ?? 0) as int,
      optionCategoryId: (json['optionCategoryId'] ?? 0) as int,
      optionCategory: (json['optionCategory'] ?? '') as String,
      option: (json['option'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'carId': carId,
    'optionId': optionId,
    'optionCategoryId': optionCategoryId,
    'optionCategory': optionCategory,
    'option': option,
  };
}

class CarImage {
  // Сейчас images: [] пустой.
  // Оставил "универсально": id + url, подстроишь под свой API.
  final int? id;
  final String? url;

  CarImage({this.id, this.url});

  factory CarImage.fromJson(Map<String, dynamic> json) {
    return CarImage(
      id: json['id'] as int?,
      url: json['url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'url': url,
  };
}
