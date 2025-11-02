part of 'car_catalog_bloc.dart';


sealed class CarCatalogEvent extends Equatable {
    const CarCatalogEvent();
    @override
    List<Object?> get props => [];
}

class GetCarsEvent extends CarCatalogEvent {
    const GetCarsEvent();
    @override
    List<Object?> get props => [];
}