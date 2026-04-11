import 'package:equatable/equatable.dart';

class CarQueryOptions extends Equatable {
  final int? year;
  final List<int>? bodyTypeIds;
  final List<int>? brandIds;
  final List<String>? powertrains;
  final List<int>? driveTypeIds;
  final List<int>? engineTypeIds;
  final num? priceMin;
  final num? priceMax;
  final int? pageIndex;
  final int? pageSize;

  const CarQueryOptions({
    this.year,
    this.bodyTypeIds,
    this.brandIds,
    this.powertrains,
    this.driveTypeIds,
    this.engineTypeIds,
    this.priceMin,
    this.priceMax,
    this.pageIndex,
    this.pageSize,
  });

  CarQueryOptions copyWith({
    int? year,
    List<int>? bodyTypeIds,
    List<int>? brandIds,
    List<String>? powertrains,
    List<int>? driveTypeIds,
    List<int>? engineTypeIds,
    num? priceMin,
    num? priceMax,
    int? pageIndex,
    int? pageSize,
  }) {
    return CarQueryOptions(
      year: year ?? this.year,
      bodyTypeIds: bodyTypeIds ?? this.bodyTypeIds,
      brandIds: brandIds ?? this.brandIds,
      powertrains: powertrains ?? this.powertrains,
      driveTypeIds: driveTypeIds ?? this.driveTypeIds,
      engineTypeIds: engineTypeIds ?? this.engineTypeIds,
      priceMin: priceMin ?? this.priceMin,
      priceMax: priceMax ?? this.priceMax,
      pageIndex: pageIndex ?? this.pageIndex,
      pageSize: pageSize ?? this.pageSize,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (year != null) data['Year'] = year;
    if (bodyTypeIds != null && bodyTypeIds!.isNotEmpty) {
      data['BodyTypeIds'] = bodyTypeIds;
    }
    if (brandIds != null && brandIds!.isNotEmpty) {
      data['BrandIds'] = brandIds;
    }
    if (powertrains != null && powertrains!.isNotEmpty) {
      data['Powertrains'] = powertrains;
    }
    if (driveTypeIds != null && driveTypeIds!.isNotEmpty) {
      data['DriveTypeIds'] = driveTypeIds;
    }
    if (engineTypeIds != null && engineTypeIds!.isNotEmpty) {
      data['EngineTypeIds'] = engineTypeIds;
    }
    if (priceMin != null) data['PriceMin'] = priceMin;
    if (priceMax != null) data['PriceMax'] = priceMax;
    if (pageIndex != null) data['PageIndex'] = pageIndex;
    if (pageSize != null) data['PageSize'] = pageSize;
    return data;
  }

  @override
  List<Object?> get props => [
        year,
        bodyTypeIds,
        brandIds,
        powertrains,
        driveTypeIds,
        engineTypeIds,
        priceMin,
        priceMax,
        pageIndex,
        pageSize,
      ];
}
