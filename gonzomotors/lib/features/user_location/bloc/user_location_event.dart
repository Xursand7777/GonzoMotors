
part of 'user_location_bloc.dart';

abstract class UserLocationEvent extends Equatable {
  const UserLocationEvent();
}


class UserLocationLoadEvent extends UserLocationEvent {
  const UserLocationLoadEvent();

  @override
  List<Object?> get props => [];
}
class UserLocationSecondEvent extends UserLocationEvent {

  const UserLocationSecondEvent();

  @override
  List<Object?> get props => [];
}

class UserLocationCancelEvent extends UserLocationEvent {
  const UserLocationCancelEvent();

  @override
  List<Object?> get props => [];
}