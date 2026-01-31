
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/connection_checker/bloc/connection_checker_bloc.dart';

mixin RefreshablePageMixin<T extends StatefulWidget> on State<T> {
  late StreamSubscription<ConnectionCheckerState> _connectionSubscription;
  bool _wasDisconnected = false;

  @override
  void initState() {
    super.initState();
    _setupConnectionListener();
  }

  void _setupConnectionListener() {
    _connectionSubscription =
        context.read<ConnectionCheckerBloc>().stream.listen(
              (state) {
            if (!state.isConnected) {
              _wasDisconnected = true;
            } else if (_wasDisconnected) {
              _wasDisconnected = false;
              // Internet qayta tiklanganda ma'lumotlarni qayta yuklash
              onConnectionRestored();
            }
          },
        );
  }

  // Bu methodni har bir sahifada override qiling
  void onConnectionRestored();

  @override
  void dispose() {
    _connectionSubscription.cancel();
    super.dispose();
  }
}
