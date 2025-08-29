import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gonzomotors/presentation/pages/compare/widgets/radar_card.dart';
import 'package:gonzomotors/presentation/pages/compare/widgets/reasons_card.dart';
import 'package:gonzomotors/presentation/pages/compare/widgets/sections_from_details.dart';
import '../../../core/app_injection.dart';
import '../../../core/enums/car.dart';
import '../../../data/models/car_specs.dart';
import '../../../data/models/compare_models.dart';
import '../../../domain/usecases/find_details_by_specs.dart';
import '../../bloc/compare/compare_bloc.dart';

class ComparePage extends StatelessWidget {
  const ComparePage({super.key, this.a, this.b});
  const ComparePage.prefilled({super.key, required this.a, required this.b});

  final CarSpecs? a;
  final CarSpecs? b;

  @override
  Widget build(BuildContext context) {
    assert(a != null && b != null, 'Use ComparePage.prefilled(a:..., b:...)');
    return BlocProvider(
      create: (_) => CompareBloc(sl<FindDetailsBySpecs>())
        ..add(CompareInit(a: a!, b: b!)),
      child: const _CompareView(),
    );
  }
}

class _CompareView extends StatelessWidget {
  const _CompareView();

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
    final physics = (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS)
        ? const BouncingScrollPhysics()
        : const ClampingScrollPhysics();

    return BlocBuilder<CompareBloc, CompareState>(
      builder: (context, state) {
        if (state is CompareLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (state is CompareError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Сравнение')),
            body: Center(child: Text('Ошибка: ${state.message}')),
          );
        }

        final s = state as CompareLoaded;
        final cats = Car.values;
        final titles = cats.map(carLabel).toList();

        final chart = RadarCard(a: s.a, b: s.b, cats: cats, titles: titles);
        final reasons = ReasonsCard(a: s.a, reasons: s.reasons);

        // ⬇️ Если ты добавил локализацию чисел в buildSectionsFromDetails — пробрось context
        final sections = buildSectionsFromDetails(
          context,
          s.detA,
          s.detB,
          hideEquals: s.hideEquals,
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text('Сравнение'),
            actions: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Text(
                      'Скрывать одинаковые',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                  Switch.adaptive(
                    value: s.hideEquals,
                    onChanged: (v) => context.read<CompareBloc>().add(CompareToggleHide(v)),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ],
          ),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (_, c) {
                final isWide = c.maxWidth > 680;
                return Padding(
                  padding: const EdgeInsets.all(12),
                  child: isWide
                      ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 6,
                        child: ListView(
                          physics: physics,          // ✅ адаптивная прокрутка
                          children: [
                            chart,
                            const SizedBox(height: 12),
                            reasons,
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 7,
                        child: ListView.separated(
                          physics: physics,          // ✅ адаптивная прокрутка
                          itemCount: sections.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (_, i) => sections[i],
                        ),
                      ),
                    ],
                  )
                      : ListView(
                    physics: physics,              // ✅ адаптивная прокрутка
                    children: [
                      chart,
                      const SizedBox(height: 12),
                      reasons,
                      const SizedBox(height: 12),
                      ...sections
                          .expand((w) => [w, const SizedBox(height: 12)])
                          .toList()
                        ..removeLast(),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
