part of 'user_location_bloc.dart';

class UserLocationState extends Equatable {
  final Position? userPosition;
  final BaseStatus status;
  final bool showDialog;

  const UserLocationState({
    this.userPosition,
    this.status = const BaseStatus(type: StatusType.initial),
    this.showDialog = false,
  });

  UserLocationState copyWith({
    Position? userPosition,
    BaseStatus? status,
    bool? showDialog,
  }) =>
      UserLocationState(
        userPosition: userPosition ?? this.userPosition,
        status: status ?? this.status,
        showDialog: showDialog ?? false,
      );

  @override
  List<Object?> get props => [userPosition, status, showDialog];
}
