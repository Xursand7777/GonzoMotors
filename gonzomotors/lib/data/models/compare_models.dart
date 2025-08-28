import '../../core/enums/car.dart';

String carLabel(Car c) {
  switch (c) {
    case Car.info:   return 'Общая';
    case Car.size:   return 'Размеры';
    case Car.engine: return 'Двигатель';
    case Car.range:  return 'Автономия';
    case Car.safety: return 'Безопасность';
    case Car.features: return 'Функции';
  }
}
