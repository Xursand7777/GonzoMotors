import 'package:equatable/equatable.dart';

class CarModel extends Equatable {
  final int id;
  final String name;
  final int year;
  final String bodyType;
  final String powertrain;
  final String imageUrl;
  final int? cipPrice;
  final int? price;

  const CarModel({
    required this.id,
    required this.name,
    required this.year,
    required this.bodyType,
    required this.imageUrl,
    required this.powertrain,
    required this.cipPrice,
    required this.price,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      year: json['year'] ?? 0,
      bodyType: json['bodyType'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      powertrain: json['powertrain'] ?? '',
      cipPrice: json['cipPrice'] ?? 0,
      price: json['price'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'year': year,
      'bodyType': bodyType,
      'imageUrl': imageUrl,
      'powertrain': powertrain,
      'cipPrice': cipPrice,
      'price': price,
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    year,
    bodyType,
    imageUrl,
    powertrain,
    cipPrice,
    price,
  ];
}
