//
// import '../core/enums/car.dart';
// import 'models/compare_models.dart';
//
// /// Полные данные автомобиля
// class CarDetails {
//   final String id;
//   final String name;
//   final int year;
//
//   // Карточка/категории
//   final String bodyType;     // Sedan / SUV / Liftback...
//   final String powertrain;   // Electric / Hybrid / EREV / ICE
//
//   // Медиа
//   final String imageCard;    // картинка для списка
//   final List<String> gallery;
//
//   // Перфоманс / техника
//   final Performance perf;
//   final Battery? battery;
//   final Charging? charging;
//   final Dimensions dim;
//   final DriverAssist adas;
//   final Interior interior;
//   final Warranty warranty;
//   final Pricing pricing;
//
//   // Радар-нормализация (0..100) по категориям
//   final Map<Car, double> norm;
//
//   // «Маркеры» для плюсов/минусов, поиска
//   final List<String> pros;
//   final List<String> cons;
//   final List<String> tags;
//
//   const CarDetails({
//     required this.id,
//     required this.name,
//     required this.year,
//     required this.bodyType,
//     required this.powertrain,
//     required this.imageCard,
//     this.gallery = const [],
//     required this.perf,
//     this.battery,
//     this.charging,
//     required this.dim,
//     required this.adas,
//     required this.interior,
//     required this.warranty,
//     required this.pricing,
//     required this.norm,
//     this.pros = const [],
//     this.cons = const [],
//     this.tags = const [],
//   });
//
//   /// Лёгкая карточка для экрана выбора
//   CarInfo toCard() => CarInfo(
//     id: id,
//     name: name,
//     year: year,
//     bodyType: bodyType,
//     powertrain: powertrain,
//     topSpeedKmh: perf.topSpeedKmh.round(),
//     horsepower: perf.hp.round(),
//     points: pricing.points,
//     imageUrl: imageCard,
//     norm: norm,
//     seats: interior.seats,
//     speakers: interior.speakers,
//     baseWarrantyYears: warranty.baseYears,
//     extWarrantyYears: warranty.extYears,
//   );
//
//   /// Данные для ComparePage (радар + «почему лучше»)
//   CarSpecs toCompare() => CarSpecs(
//     name: '$name ($year)',
//     norm: norm,
//     seats: interior.seats,
//     speakers: interior.speakers,
//     baseWarrantyYears: warranty.baseYears,
//     extWarrantyYears: warranty.extYears,
//   );
// }
//
// /// Лёгкая модель для списка выбора (как у тебя)
// class CarInfo {
//   final String id;
//   final String name;
//   final int year;
//   final String bodyType;
//   final String powertrain;
//   final int topSpeedKmh;
//   final int horsepower;
//   final int points;
//   final String imageUrl;
//   final Map<Car, double> norm;
//   final int seats, speakers, baseWarrantyYears, extWarrantyYears;
//
//   const CarInfo({
//     required this.id,
//     required this.name,
//     required this.year,
//     required this.bodyType,
//     required this.powertrain,
//     required this.topSpeedKmh,
//     required this.horsepower,
//     required this.points,
//     required this.imageUrl,
//     required this.norm,
//     this.seats = 5,
//     this.speakers = 15,
//     this.baseWarrantyYears = 3,
//     this.extWarrantyYears = 5,
//   });
// }
//
// // ====== Подмодели ======
//
// class Performance {
//   final double hp; // л.с.
//   final double kw; // кВт
//   final double torqueNm;
//   final double zeroTo100; // сек
//   final double topSpeedKmh;
//   final String drive; // AWD/RWD/FWD
//   final String gearbox; // 1-speed / AT / DHT...
//   const Performance({
//     required this.hp,
//     required this.kw,
//     required this.torqueNm,
//     required this.zeroTo100,
//     required this.topSpeedKmh,
//     required this.drive,
//     required this.gearbox,
//   });
// }
//
// class Battery {
//   final double capacityKwh;
//   final double? usableKwh;
//   final double? rangeWltpKm;
//   final double? rangeCltcKm;
//   const Battery({
//     required this.capacityKwh,
//     this.usableKwh,
//     this.rangeWltpKm,
//     this.rangeCltcKm,
//   });
// }
//
// class Charging {
//   final double acKw;       // бортовое ЗУ
//   final double dcKwPeak;   // пиковая быстрая
//   final int dc10to80Min;   // мин до 80%
//   const Charging({
//     required this.acKw,
//     required this.dcKwPeak,
//     required this.dc10to80Min,
//   });
// }
//
// class Dimensions {
//   final int lengthMm, widthMm, heightMm, wheelbaseMm;
//   final int trunkL; // при поднятых спинках
//   const Dimensions({
//     required this.lengthMm,
//     required this.widthMm,
//     required this.heightMm,
//     required this.wheelbaseMm,
//     this.trunkL = 0,
//   });
// }
//
// class DriverAssist {
//   final String stack;       // Orin / Thor / собственный
//   final bool lidar;
//   final int cameras;
//   final int radars;
//   final String level;       // L2/L2+...
//   const DriverAssist({
//     required this.stack,
//     required this.lidar,
//     required this.cameras,
//     required this.radars,
//     required this.level,
//   });
// }
//
// class Interior {
//   final int seats;
//   final int speakers;
//   final bool massage;
//   final bool ventilation;
//   final bool fridge;
//   const Interior({
//     required this.seats,
//     required this.speakers,
//     this.massage = false,
//     this.ventilation = false,
//     this.fridge = false,
//   });
// }
//
// class Warranty {
//   final int baseYears;
//   final int extYears;
//   const Warranty({required this.baseYears, required this.extYears});
// }
//
// class Pricing {
//   final int points;      // для бейджа
//   final int msrpCnyMin;  // для рынка CN (пример)
//   final int? msrpCnyMax;
//   const Pricing({required this.points, required this.msrpCnyMin, this.msrpCnyMax});
// }
//
// // ====== База данных (демо) ======
//
// final List<CarDetails> carDb = [
//   CarDetails(
//     id: 'bmw_m5_2025',
//     name: 'BMW 5 Series M5',
//     year: 2025,
//     bodyType: 'Sedan',
//     powertrain: 'Hybrid',
//     imageCard: 'assets/cars/bmw-5-series-m5.jpg',
//     gallery: ['assets/cars/bmw-5-series-m5.jpg'],
//     perf: const Performance(
//       hp: 717, kw: 534, torqueNm: 1000, zeroTo100: 3.5, topSpeedKmh: 305, drive: 'AWD', gearbox: 'AT 8',
//     ),
//     battery: const Battery(capacityKwh: 18.6, usableKwh: 18.0, rangeWltpKm: 60),
//     charging: const Charging(acKw: 7.4, dcKwPeak: 50, dc10to80Min: 25),
//     dim: const Dimensions(lengthMm: 5096, widthMm: 1900, heightMm: 1510, wheelbaseMm: 2995, trunkL: 466),
//     adas: const DriverAssist(stack: 'BMW Pro', lidar: false, cameras: 8, radars: 5, level: 'L2'),
//     interior: const Interior(seats: 5, speakers: 16, massage: true, ventilation: true),
//     warranty: const Warranty(baseYears: 3, extYears: 5),
//     pricing: const Pricing(points: 93, msrpCnyMin: 1200000),
//     norm: const {
//       Car.info: 88, Car.size: 70, Car.engine: 92, Car.range: 65, Car.safety: 80, Car.features: 85,
//     },
//     pros: ['Очень быстрый', 'Салон премиум', 'Классическая управляемость'],
//     cons: ['Небольшой EV-запас хода', 'Высокая цена'],
//     tags: ['sport', 'luxury', 'hybrid'],
//   ),
//
//   CarDetails(
//     id: 'lucid_air_sapphire_2025',
//     name: 'Lucid Air Sapphire',
//     year: 2025,
//     bodyType: 'Sedan',
//     powertrain: 'Electric',
//     imageCard: 'assets/cars/lucid-air-sapphire.webp',
//     gallery: ['assets/cars/lucid-air-sapphire.webp'],
//     perf: const Performance(
//       hp: 1200, kw: 895, torqueNm: 1390, zeroTo100: 1.9, topSpeedKmh: 330, drive: 'AWD (3-motor)', gearbox: '1-speed',
//     ),
//     battery: const Battery(capacityKwh: 118, usableKwh: 113, rangeWltpKm: 720),
//     charging: const Charging(acKw: 22, dcKwPeak: 300, dc10to80Min: 20),
//     dim: const Dimensions(lengthMm: 4975, widthMm: 1939, heightMm: 1410, wheelbaseMm: 2960, trunkL: 456),
//     adas: const DriverAssist(stack: 'DreamDrive Pro', lidar: true, cameras: 14, radars: 5, level: 'L2+'),
//     interior: const Interior(seats: 5, speakers: 21, massage: true, ventilation: true, fridge: false),
//     warranty: const Warranty(baseYears: 4, extYears: 8),
//     pricing: const Pricing(points: 99, msrpCnyMin: 1500000),
//     norm: const {
//       Car.info: 95, Car.size: 78, Car.engine: 100, Car.range: 96, Car.safety: 85, Car.features: 92,
//     },
//     pros: ['Лидер по динамике', 'Большой EV-запас', 'Сильные ассистенты'],
//     cons: ['Высокая стоимость владения'],
//     tags: ['ev', 'performance', 'luxury'],
//   ),
//
//   CarDetails(
//     id: 'mm_eqs_2025',
//     name: 'Mercedes-Maybach EQS',
//     year: 2025,
//     bodyType: 'SUV',
//     powertrain: 'Electric',
//     imageCard: 'assets/cars/mercedes-maybach-eqs.jpg',
//     gallery: ['assets/cars/mercedes-maybach-eqs.jpg'],
//     perf: const Performance(
//       hp: 658, kw: 490, torqueNm: 950, zeroTo100: 4.4, topSpeedKmh: 210, drive: 'AWD', gearbox: '1-speed',
//     ),
//     battery: const Battery(capacityKwh: 118, usableKwh: 108, rangeWltpKm: 600),
//     charging: const Charging(acKw: 11, dcKwPeak: 200, dc10to80Min: 31),
//     dim: const Dimensions(lengthMm: 5223, widthMm: 1926, heightMm: 1725, wheelbaseMm: 3210, trunkL: 440),
//     adas: const DriverAssist(stack: 'MBUX Drive Pilot', lidar: true, cameras: 15, radars: 6, level: 'L2+'),
//     interior: const Interior(seats: 4, speakers: 15, massage: true, ventilation: true, fridge: true),
//     warranty: const Warranty(baseYears: 2, extYears: 2),
//     pricing: const Pricing(points: 91, msrpCnyMin: 1600000),
//     norm: const {
//       Car.info: 75, Car.size: 95, Cat.engine: 82, Cat.range: 70, Cat.safety: 90, Cat.features: 88,
//     },
//     pros: ['Максимум роскоши', 'Тишина/комфорт', 'Сильные ADAS'],
//     cons: ['Цена', 'Сдержанная динамика для класса'],
//     tags: ['ev', 'luxury', 'suv'],
//   ),
//
//   CarDetails(
//     id: 'zeekr_001_2025',
//     name: 'Zeekr 001',
//     year: 2025,
//     bodyType: 'Liftback',
//     powertrain: 'Electric',
//     imageCard: 'assets/cars/zeekr-001.jpg',
//     gallery: ['assets/cars/zeekr-001.jpg'],
//     perf: const Performance(
//       hp: 789, kw: 588, torqueNm: 1000, zeroTo100: 3.2, topSpeedKmh: 240, drive: 'AWD', gearbox: '1-speed',
//     ),
//     battery: const Battery(capacityKwh: 100, usableKwh: 95, rangeWltpKm: 700),
//     charging: const Charging(acKw: 22, dcKwPeak: 360, dc10to80Min: 15),
//     dim: const Dimensions(lengthMm: 4970, widthMm: 1999, heightMm: 1548, wheelbaseMm: 3005, trunkL: 594),
//     adas: const DriverAssist(stack: 'Mobileye/Ngp', lidar: false, cameras: 12, radars: 5, level: 'L2'),
//     interior: const Interior(seats: 5, speakers: 14, massage: true, ventilation: true),
//     warranty: const Warranty(baseYears: 4, extYears: 8),
//     pricing: const Pricing(points: 92, msrpCnyMin: 300000),
//     norm: const {
//       Cat.info: 85, Cat.size: 82, Cat.engine: 88, Cat.range: 92, Cat.safety: 78, Cat.features: 87,
//     },
//     pros: ['Отличный баланс цены/EV-запаса', 'Много технологий'],
//     cons: ['Жёстковатая подвеска в спорт-комплектациях'],
//     tags: ['ev', 'liftback', 'value'],
//   ),
// ];
//
// /// Удобные списки для экранов:
// final List<CarInfo> carCards = carDb.map((c) => c.toCard()).toList();
//
// /// Преобразование по id → CarSpecs (для сравнения)
// CarSpecs specsById(String id) => carDb.firstWhere((c) => c.id == id).toCompare();






import 'models/models.dart';

/// Мок-база автомобилей
final List<CarDetails> carDb = [
  CarDetails(
    id: 'bmw_m5_2025',
    name: 'BMW 5 Series M5',
    year: 2025,
    bodyType: 'Sedan',
    powertrain: 'Hybrid',
    imageCard: 'assets/cars/bmw-5-series-m5.jpg',
    gallery: ['assets/cars/bmw-5-series-m5.jpg'],
    perf: const Performance(
      hp: 717,
      kw: 534,
      torqueNm: 1000,
      zeroTo100: 3.5,
      topSpeedKmh: 305,
      drive: 'AWD',
      gearbox: 'AT 8',
    ),
    battery: const Battery(capacityKwh: 18.6, usableKwh: 18.0, rangeWltpKm: 60),
    charging: const Charging(acKw: 7.4, dcKwPeak: 50, dc10to80Min: 25),
    dim: const Dimensions(
      lengthMm: 5096,
      widthMm: 1900,
      heightMm: 1510,
      wheelbaseMm: 2995,
      trunkL: 466,
    ),
    adas: const DriverAssist(
      stack: 'BMW Pro',
      lidar: false,
      cameras: 8,
      radars: 5,
      level: 'L2',
    ),
    interior: const Interior(
      seats: 5,
      speakers: 16,
      massage: true,
      ventilation: true,
    ),
    warranty: const Warranty(baseYears: 3, extYears: 5),
    pricing: const Pricing(points: 93, msrpCnyMin: 1200000),
    norm: const {
      Car.info: 88,
      Car.size: 70,
      Car.engine: 92,
      Car.range: 65,
      Car.safety: 80,
      Car.features: 85,
    },
    pros: ['Очень быстрый', 'Салон премиум', 'Классическая управляемость'],
    cons: ['Небольшой EV-запас хода', 'Высокая цена'],
    tags: ['sport', 'luxury', 'hybrid'],
  ),

  CarDetails(
    id: 'lucid_air_sapphire_2025',
    name: 'Lucid Air Sapphire',
    year: 2025,
    bodyType: 'Sedan',
    powertrain: 'Electric',
    imageCard: 'assets/cars/lucid-air-sapphire.webp',
    gallery: ['assets/cars/lucid-air-sapphire.webp'],
    perf: const Performance(
      hp: 1200,
      kw: 895,
      torqueNm: 1390,
      zeroTo100: 1.9,
      topSpeedKmh: 330,
      drive: 'AWD (3-motor)',
      gearbox: '1-speed',
    ),
    battery: const Battery(capacityKwh: 118, usableKwh: 113, rangeWltpKm: 720),
    charging: const Charging(acKw: 22, dcKwPeak: 300, dc10to80Min: 20),
    dim: const Dimensions(
      lengthMm: 4975,
      widthMm: 1939,
      heightMm: 1410,
      wheelbaseMm: 2960,
      trunkL: 456,
    ),
    adas: const DriverAssist(
      stack: 'DreamDrive Pro',
      lidar: true,
      cameras: 14,
      radars: 5,
      level: 'L2+',
    ),
    interior: const Interior(
      seats: 5,
      speakers: 21,
      massage: true,
      ventilation: true,
      fridge: false,
    ),
    warranty: const Warranty(baseYears: 4, extYears: 8),
    pricing: const Pricing(points: 99, msrpCnyMin: 1500000),
    norm: const {
      Car.info: 95,
      Car.size: 78,
      Car.engine: 100,
      Car.range: 96,
      Car.safety: 85,
      Car.features: 92,
    },
    pros: ['Лидер по динамике', 'Большой EV-запас', 'Сильные ассистенты'],
    cons: ['Высокая стоимость владения'],
    tags: ['ev', 'performance', 'luxury'],
  ),

  CarDetails(
    id: 'mm_eqs_2025',
    name: 'Mercedes-Maybach EQS',
    year: 2025,
    bodyType: 'SUV',
    powertrain: 'Electric',
    imageCard: 'assets/cars/mercedes-maybach-eqs.jpg',
    gallery: ['assets/cars/mercedes-maybach-eqs.jpg'],
    perf: const Performance(
      hp: 658,
      kw: 490,
      torqueNm: 950,
      zeroTo100: 4.4,
      topSpeedKmh: 210,
      drive: 'AWD',
      gearbox: '1-speed',
    ),
    battery: const Battery(capacityKwh: 118, usableKwh: 108, rangeWltpKm: 600),
    charging: const Charging(acKw: 11, dcKwPeak: 200, dc10to80Min: 31),
    dim: const Dimensions(
      lengthMm: 5223,
      widthMm: 1926,
      heightMm: 1725,
      wheelbaseMm: 3210,
      trunkL: 440,
    ),
    adas: const DriverAssist(
      stack: 'MBUX Drive Pilot',
      lidar: true,
      cameras: 15,
      radars: 6,
      level: 'L2+',
    ),
    interior: const Interior(
      seats: 4,
      speakers: 15,
      massage: true,
      ventilation: true,
      fridge: true,
    ),
    warranty: const Warranty(baseYears: 2, extYears: 2),
    pricing: const Pricing(points: 91, msrpCnyMin: 1600000),
    norm: const {
      Car.info: 75,
      Car.size: 95,
      Car.engine: 82,
      Car.range: 70,
      Car.safety: 90,
      Car.features: 88,
    },
    pros: ['Максимум роскоши', 'Тишина/комфорт', 'Сильные ADAS'],
    cons: ['Цена', 'Сдержанная динамика для класса'],
    tags: ['ev', 'luxury', 'suv'],
  ),

  CarDetails(
    id: 'zeekr_001_2025',
    name: 'Zeekr 001',
    year: 2025,
    bodyType: 'Liftback',
    powertrain: 'Electric',
    imageCard: 'assets/cars/zeekr-001.jpg',
    gallery: ['assets/cars/zeekr-001.jpg'],
    perf: const Performance(
      hp: 789,
      kw: 588,
      torqueNm: 1000,
      zeroTo100: 3.2,
      topSpeedKmh: 240,
      drive: 'AWD',
      gearbox: '1-speed',
    ),
    battery: const Battery(capacityKwh: 100, usableKwh: 95, rangeWltpKm: 700),
    charging: const Charging(acKw: 22, dcKwPeak: 360, dc10to80Min: 15),
    dim: const Dimensions(
      lengthMm: 4970,
      widthMm: 1999,
      heightMm: 1548,
      wheelbaseMm: 3005,
      trunkL: 594,
    ),
    adas: const DriverAssist(
      stack: 'Mobileye/Ngp',
      lidar: false,
      cameras: 12,
      radars: 5,
      level: 'L2',
    ),
    interior: const Interior(
      seats: 5,
      speakers: 14,
      massage: true,
      ventilation: true,
    ),
    warranty: const Warranty(baseYears: 4, extYears: 8),
    pricing: const Pricing(points: 92, msrpCnyMin: 300000),
    norm: const {
      Car.info: 85,
      Car.size: 82,
      Car.engine: 88,
      Car.range: 92,
      Car.safety: 78,
      Car.features: 87,
    },
    pros: ['Отличный баланс цены/EV-запаса', 'Много технологий'],
    cons: ['Жёстковатая подвеска в спорт-комплектациях'],
    tags: ['ev', 'liftback', 'value'],
  ),
];

/// Карточки для списка
final List<CarInfo> carCards = carDb.map((c) => c.toCard()).toList();

/// Получить спецификации по id для страницы сравнения
CarSpecs specsById(String id) => carDb.firstWhere((c) => c.id == id).toCompare();
