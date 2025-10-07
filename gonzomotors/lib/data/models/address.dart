class Address {
  final int? id;
  final String? name;
  final String? region;
  final String? street;
  final String? city;
  final String? home;
  final double? lat;
  final double? lng;
  final List<WorkingHour>? workingHours;

  const Address(
      {this.id,
        this.name,
        this.region,
        this.street,
        this.city,
        this.home,
        this.lat,
        this.lng,
        this.workingHours});

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json['id'],
    name: json['name'],
    region: json['region'],
    street: json['street'],
    city: json['city'],
    home: json['home'],
    lat: (json['lat'] as num?)?.toDouble(),
    lng: (json['lng'] as num?)?.toDouble(),
    workingHours: (json['working_hours'] as List?)
        ?.map((e) => WorkingHour.fromJson(e))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'region': region,
    'street': street,
    'city': city,
    'home': home,
    'lat': lat,
    'lng': lng,
    'working_hours': workingHours?.map((e) => e.toJson()).toList(),
  };

  Address copyWith(
      {int? id,
        String? name,
        String? region,
        String? street,
        String? city,
        String? home,
        double? lat,
        double? lng,
        List<WorkingHour>? workingHours}) =>
      Address(
        id: id ?? this.id,
        name: name ?? this.name,
        region: region ?? this.region,
        street: street ?? this.street,
        city: city ?? this.city,
        home: home ?? this.home,
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
        workingHours: workingHours ?? this.workingHours,
      );

  @override
  String toString() => 'Address(id: $id, name: $name)';
}


class WorkingHour {
  final int? dayOfWeek;
  final String? timeFrom;
  final String? timeTo;

  const WorkingHour({this.dayOfWeek, this.timeFrom, this.timeTo});

  factory WorkingHour.fromJson(Map<String, dynamic> json) => WorkingHour(
    dayOfWeek: json['day_of_week'],
    timeFrom: json['time_from'],
    timeTo: json['time_to'],
  );

  Map<String, dynamic> toJson() => {
    'day_of_week': dayOfWeek,
    'time_from': timeFrom,
    'time_to': timeTo,
  };

  WorkingHour copyWith({int? dayOfWeek, String? timeFrom, String? timeTo}) =>
      WorkingHour(
        dayOfWeek: dayOfWeek ?? this.dayOfWeek,
        timeFrom: timeFrom ?? this.timeFrom,
        timeTo: timeTo ?? this.timeTo,
      );

  @override
  String toString() =>
      'WorkingHour(day: $dayOfWeek, from: $timeFrom, to: $timeTo)';
}