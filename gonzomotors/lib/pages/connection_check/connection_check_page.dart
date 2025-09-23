

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/connection_checker/bloc/connection_checker_bloc.dart';
import '../../shared/no_connection/no_connection_shared.dart';

class OfflinePage extends StatelessWidget {
  const OfflinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: NoConnectionShared(
          onRetry: () => context
              .read<ConnectionCheckerBloc>()
              .add(const CheckConnectionEvent()),
        ),
      ),
    );
  }
}
