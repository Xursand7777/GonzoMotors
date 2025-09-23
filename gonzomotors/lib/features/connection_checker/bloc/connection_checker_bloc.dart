

import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../../core/log/talker_logger.dart';

part 'connection_checker_event.dart';
part 'connection_checker_state.dart';

class ConnectionCheckerBloc
    extends Bloc<ConnectionCheckerEvent, ConnectionCheckerState> {
  final InternetConnectionChecker connectionChecker;
  final Connectivity connectivity;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  ConnectionCheckerBloc(this.connectionChecker, this.connectivity)
      : super(const ConnectionCheckerState()) {
    on<CheckConnectionEvent>(_checkConnection);
    on<StartMonitoringEvent>(_startMonitoring);
    add(const StartMonitoringEvent());
  }

  void _checkConnection(
      CheckConnectionEvent event, Emitter<ConnectionCheckerState> emit) async {
    final isConnected = await connectionChecker.hasConnection;
    logger.debug("Connection status: $isConnected");
    emit(state.copyWith(isConnected: isConnected));
  }

  void _startMonitoring(
      StartMonitoringEvent event, Emitter<ConnectionCheckerState> emit) async {
    await _connectivitySubscription?.cancel();

    logger.debug("Starting connectivity monitoring");
    _connectivitySubscription =
        connectivity.onConnectivityChanged.listen((result) async {
          logger.debug("Connectivity changed: $result");
          add(const CheckConnectionEvent());
        });
  }

  @override
  Future<void> close() async {
    await _connectivitySubscription?.cancel();
    return super.close();
  }
}
