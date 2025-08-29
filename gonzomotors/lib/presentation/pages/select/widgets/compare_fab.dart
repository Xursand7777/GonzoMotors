import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/car_specs.dart';
import '../../../bloc/select/car_select_bloc.dart';

class CompareFab extends StatelessWidget {
  const CompareFab({super.key, required this.onCompare});
  final void Function(CarSpecs a, CarSpecs b) onCompare;

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;

    return BlocConsumer<CarSelectBloc, CarSelectState>(
      listenWhen: (p, n) =>
      n is CarSelectLoaded && n.compareA != null && n.compareB != null,
      listener: (context, state) {
        final s = state as CarSelectLoaded;
        onCompare(s.compareA!, s.compareB!);
      },
      builder: (context, state) {
        final enabled = (state is CarSelectLoaded) && state.canCompare;
        final count = state is CarSelectLoaded ? state.selected.length : 0;

        void onPressed() {
          Feedback.forTap(context); // нативная хаптика
          context.read<CarSelectBloc>().add(CarSelectCompare());
        }

        if (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS) {
          // iOS-стиль: заполненная купертино-кнопка
          return SafeArea(
            minimum: const EdgeInsets.only(bottom: 12, right: 12),
            child: CupertinoButton.filled(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              borderRadius: BorderRadius.circular(22),
              onPressed: enabled ? onPressed : null,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(CupertinoIcons.arrow_right_arrow_left, size: 18),
                  const SizedBox(width: 8),
                  Text('Compare ($count/2)'),
                ],
              ),
            ),
          );
        }

        // Android/Material: стандартный FAB extended
        return FloatingActionButton.extended(
          onPressed: enabled ? onPressed : null,
          icon: const Icon(Icons.compare_arrows),
          label: Text('Compare ($count/2)'),
        );
      },
    );
  }
}
