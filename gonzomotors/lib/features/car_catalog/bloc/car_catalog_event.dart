part of 'car_catalog_bloc.dart';


sealed class CarCatalogEvent extends Equatable {
    const CarCatalogEvent();
    @override
    List<Object?> get props => [];
}

class GetCarsEvent extends CarCatalogEvent {
    final CarQueryOptions? queryOptions;
    const GetCarsEvent({this.queryOptions});
    
    @override
    List<Object?> get props => [queryOptions];
}