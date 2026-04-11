class FilterOptions {
  final List<FilterItem> brands;
  final List<FilterItem> bodyTypes;
  final List<FilterItem> driveTypes;
  final List<FilterItem> engineTypes;
  final List<String> powertrains;
  final num minPrice;
  final num maxPrice;

  const FilterOptions({
    this.brands = const [],
    this.bodyTypes = const [],
    this.driveTypes = const [],
    this.engineTypes = const [],
    this.powertrains = const [],
    this.minPrice = 0,
    this.maxPrice = 0,
  });

  factory FilterOptions.fromJson(Map<String, dynamic> json) {
    return FilterOptions(
      brands: (json['brands'] as List<dynamic>?)
              ?.map((e) => FilterItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      bodyTypes: (json['bodyTypes'] as List<dynamic>?)
              ?.map((e) => FilterItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      driveTypes: (json['driveTypes'] as List<dynamic>?)
              ?.map((e) => FilterItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      engineTypes: (json['engineTypes'] as List<dynamic>?)
              ?.map((e) => FilterItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      powertrains: (json['powertrains'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      minPrice: json['minPrice'] as num? ?? 0,
      maxPrice: json['maxPrice'] as num? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'brands': brands.map((x) => x.toJson()).toList(),
      'bodyTypes': bodyTypes.map((x) => x.toJson()).toList(),
      'driveTypes': driveTypes.map((x) => x.toJson()).toList(),
      'engineTypes': engineTypes.map((x) => x.toJson()).toList(),
      'powertrains': powertrains,
      'minPrice': minPrice,
      'maxPrice': maxPrice,
    };
  }
}

class FilterItem {
  final int id;
  final String name;

  const FilterItem({required this.id, required this.name});

  factory FilterItem.fromJson(Map<String, dynamic> json) {
    return FilterItem(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
