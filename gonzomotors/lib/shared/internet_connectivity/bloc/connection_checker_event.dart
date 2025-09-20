part of 'connection_checker_bloc.dart';

abstract class ConnectionCheckerEvent extends Equatable {
  const ConnectionCheckerEvent();

  @override
  List<Object?> get props => [];
}

class CheckConnectionEvent extends ConnectionCheckerEvent {
  const CheckConnectionEvent();

  @override
  List<Object?> get props => [];
}


class StartMonitoringEvent extends ConnectionCheckerEvent {

  const StartMonitoringEvent();

  @override
  List<Object?> get props => [];
}