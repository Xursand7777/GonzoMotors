part of 'connection_checker_bloc.dart';
class ConnectionCheckerState extends Equatable {
  final bool isConnected;

  const ConnectionCheckerState({this.isConnected = true});


  ConnectionCheckerState copyWith({
    bool? isConnected,
  }) {
    return ConnectionCheckerState(isConnected: isConnected ?? this.isConnected);
  }

  @override
  List<Object?> get props => [isConnected];
}
