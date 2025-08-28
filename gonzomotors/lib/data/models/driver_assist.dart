import 'package:equatable/equatable.dart';

class DriverAssist extends Equatable {
  final String stack;
  final bool lidar;
  final int cameras;
  final int radars;
  final String level;

  const DriverAssist({
    required this.stack,
    required this.lidar,
    required this.cameras,
    required this.radars,
    required this.level,
  });

  Map<String, dynamic> toMap() => {
    'stack': stack, 'lidar': lidar ? 1 : 0, 'cameras': cameras,
    'radars': radars, 'level': level,
  };

  factory DriverAssist.fromMap(Map<String, dynamic> m) => DriverAssist(
    stack: m['stack'] as String,
    lidar: (m['lidar'] as int) == 1,
    cameras: m['cameras'] as int,
    radars: m['radars'] as int,
    level: m['level'] as String,
  );

  @override
  List<Object?> get props => [stack, lidar, cameras, radars, level];
}
