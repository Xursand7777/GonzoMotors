import 'package:equatable/equatable.dart';

class Performance extends Equatable {
  final double hp;        // л.с.
  final double kw;        // кВт
  final double torqueNm;
  final double zeroTo100; // сек
  final double topSpeedKmh;
  final String drive;     // AWD/RWD/FWD
  final String gearbox;   // 1-speed / AT / DHT...

  const Performance({
    required this.hp,
    required this.kw,
    required this.torqueNm,
    required this.zeroTo100,
    required this.topSpeedKmh,
    required this.drive,
    required this.gearbox,
  });

  Map<String, dynamic> toMap() => {
    'hp': hp,
    'kw': kw,
    'torqueNm': torqueNm,
    'zeroTo100': zeroTo100,
    'topSpeedKmh': topSpeedKmh,
    'drive': drive,
    'gearbox': gearbox,
  };

  factory Performance.fromMap(Map<String, dynamic> m) => Performance(
    hp: (m['hp'] as num).toDouble(),
    kw: (m['kw'] as num).toDouble(),
    torqueNm: (m['torqueNm'] as num).toDouble(),
    zeroTo100: (m['zeroTo100'] as num).toDouble(),
    topSpeedKmh: (m['topSpeedKmh'] as num).toDouble(),
    drive: m['drive'] as String,
    gearbox: m['gearbox'] as String,
  );

  @override
  List<Object?> get props =>
      [hp, kw, torqueNm, zeroTo100, topSpeedKmh, drive, gearbox];
}
