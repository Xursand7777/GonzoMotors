import 'package:flutter/material.dart';
import '../../features/car_catalog/widgets/car_list.dart';
import '../../shared/search_text_field_shared/search_text_field_shared.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di/app_injection.dart';
import '../../features/car_catalog/bloc/car_catalog_bloc.dart';
import '../../features/car_catalog/bloc/filter_cubit.dart';
import '../../features/car_catalog/bloc/filter_options_cubit.dart';
import '../../features/car_catalog/data/models/car_query_options.dart';
import '../../features/car_catalog/data/models/filter_options.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => FilterOptionsCubit(repo: sl.get()),
        ),
        BlocProvider(
          create: (_) => FilterCubit(),
        ),
      ],
      child: const Scaffold(
        backgroundColor: Colors.white,
        appBar: _CatalogAppBar(),
        body: CatalogPageView(),
      ),
    );
  }
}

class _CatalogAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _CatalogAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Catalog'),
      centerTitle: false,
      elevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
    );
  }
}

class CatalogPageView extends StatefulWidget {
  const CatalogPageView({super.key});

  @override
  State<CatalogPageView> createState() => _CatalogPageViewState();
}

class _CatalogPageViewState extends State<CatalogPageView> {
  int selectedCarType = 2; // бензин по умолчанию как на скрине
  int selectedBrand = 1;

  String _getPowertrainImage(String pt) {
    final cleanPt = pt.trim().toLowerCase();
    if (cleanPt.contains('гибрид') || cleanPt.contains('hybrid')) {
      return 'assets/images/gibrid.png';
    } else if (cleanPt.contains('электр') || cleanPt.contains('electric') || cleanPt.contains('ev')) {
      return 'assets/images/electro.png';
    } else {
      return 'assets/images/benzin.png';
    }
  }

  String _getBrandLogo(String brandName) {
    final name = brandName.trim().toLowerCase();
    if (name.contains('zeekr')) {
      return 'assets/icons/zeekr_logo.png';
    } else if (name.contains('xiaomi')) {
      return 'assets/icons/xiamo.png';
    }
    return 'assets/icons/zeekr_logo.png';
  }

  final carTypes = const <_CarTypeItem>[
    _CarTypeItem(title: 'Гибрид', icon: Icons.electric_bolt),
    _CarTypeItem(title: 'Электр', icon: Icons.ev_station),
    _CarTypeItem(title: 'Бензин', icon: Icons.local_gas_station),
  ];

  final bodyTypes = const <String>[
    'Внедорожник',
    'Кроссовер',
    'Седан',
  ];

  final brands = const <_BrandItem>[
    _BrandItem(name: 'Zeekr', modelsCount: 10),
    _BrandItem(name: 'Zeekr', modelsCount: 10),
    _BrandItem(name: 'Zeekr', modelsCount: 10),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterOptionsCubit, FilterOptionsState>(
      builder: (context, filterOptionsState) {
        final options = filterOptionsState.options;

        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const SearchTextFieldShared(
                      hintText: 'Поиск автомобилей',
                    ),
                    const SizedBox(height: 16),

                    _SectionTitle(title: 'Тип автомобиля'),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 110,
                      child: BlocBuilder<FilterCubit, CarQueryOptions>(
                        builder: (context, filterState) {
                          return ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: options.powertrains.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 12),
                            itemBuilder: (context, i) {
                              final pt = options.powertrains[i];
                              final selected = (filterState.powertrains ?? []).contains(pt);
                              return _SelectableCard(
                                width: 110,
                                height: 110,
                                selected: selected,
                                onTap: () {
                                  context.read<FilterCubit>().togglePowertrain(pt);
                                  context.read<CarCatalogBloc>().add(GetCarsEvent(queryOptions: context.read<FilterCubit>().state));
                                },
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Positioned(
                                      top: -6,
                                      left: 5,
                                      right: 5,
                                      child: Image.asset(
                                        _getPowertrainImage(pt),
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => const Icon(
                                          Icons.directions_car,
                                          size: 34,
                                          color: Color(0xFF2E7D32),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 12,
                                      left: 0,
                                      right: 0,
                                      child: Text(
                                        pt,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF202938),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 18),
                    _SectionTitle(title: 'Тип кузова'),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 74,
                      child: BlocBuilder<FilterCubit, CarQueryOptions>(
                        builder: (context, filterState) {
                          return ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: options.bodyTypes.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 12),
                            itemBuilder: (context, i) {
                              final bodyType = options.bodyTypes[i];
                              final selected = (filterState.bodyTypeIds ?? []).contains(bodyType.id);
                              return _SelectableCard(
                                width: 112,
                                height: 74,
                                selected: selected,
                                onTap: () {
                                  context.read<FilterCubit>().toggleBodyType(bodyType.id);
                                  context.read<CarCatalogBloc>().add(GetCarsEvent(queryOptions: context.read<FilterCubit>().state));
                                },
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Text(
                                      bodyType.name,
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF202938),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 18),
                    Row(
                      children: [
                        const Expanded(child: _SectionTitle(title: 'Бренды')),
                        InkWell(
                          onTap: () {
                            // TODO: открыть список всех брендов
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                            child: Row(
                              children: [
                                Text(
                                  'Все',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFFFF594C),
                                  ),
                                ),
                                SizedBox(width: 6),
                                Icon(Icons.chevron_right,
                                    size: 18, color: Color(0xFFFF594C)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 110,
                      child: BlocBuilder<FilterCubit, CarQueryOptions>(
                        builder: (context, filterState) {
                          return ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: options.brands.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 12),
                            itemBuilder: (context, i) {
                              final b = options.brands[i];
                              final selected = (filterState.brandIds ?? []).contains(b.id);
                              return _SelectableCard(
                                width: 120,
                                height: 110,
                                selected: selected,
                                onTap: () {
                                  context.read<FilterCubit>().toggleBrand(b.id);
                                  context.read<CarCatalogBloc>().add(GetCarsEvent(queryOptions: context.read<FilterCubit>().state));
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(6),
                                      child: Image.asset(
                                        _getBrandLogo(b.name),
                                        fit: BoxFit.contain,
                                        errorBuilder: (_, __, ___) => const Icon(
                                          Icons.directions_car,
                                          size: 24,
                                          color: Color(0xFF202938),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      b.name,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF202938),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _CircleActionButton(
                          icon: Icons.swap_vert,
                          onTap: () {
                            // TODO: сортировка
                          },
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _PillButton(
                            icon: Icons.tune,
                            text: 'Фильтр',
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (_) => MultiBlocProvider(
                                  providers: [
                                    BlocProvider.value(value: context.read<FilterOptionsCubit>()),
                                    BlocProvider.value(value: context.read<FilterCubit>()),
                                    BlocProvider.value(value: context.read<CarCatalogBloc>()),
                                  ],
                                  child: const FilterBottomSheet(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
              ],
            ),
          ),
        ),

        // ✅ Список машин (Sliver)
        const CarsListSliver(),

        // ✅ Отступ под нижнюю навигацию/кнопки
        const SliverToBoxAdapter(
          child: SizedBox(height: 110),
        ),
          ],
        );
      },
    );
  }

}

/* ---------------- UI blocks ---------------- */

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xFF202938),
      ),
    );
  }
}

class _SelectableCard extends StatelessWidget {
  final double width;
  final double height;
  final bool selected;
  final VoidCallback onTap;
  final Widget child;

  const _SelectableCard({
    required this.width,
    required this.height,
    required this.selected,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = selected ? const Color(0xFFFF594C) : Colors.transparent;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: child,
      ),
    );
  }
}

class _CircleActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleActionButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
          boxShadow: const [
            BoxShadow(
              blurRadius: 14,
              offset: Offset(0, 6),
              color: Color(0x14111827),
            )
          ],
        ),
        child: Icon(icon, size: 22, color: const Color(0xFF111827)),
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _PillButton({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
          boxShadow: const [
            BoxShadow(
              blurRadius: 14,
              offset: Offset(0, 6),
              color: Color(0x14111827),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: const Color(0xFF111827)),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ---------------- Models ---------------- */

class _CarTypeItem {
  final String title;
  final IconData icon;
  const _CarTypeItem({required this.title, required this.icon});
}

class _BrandItem {
  final String name;
  final int modelsCount;
  const _BrandItem({required this.name, required this.modelsCount});
}


class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.only(bottom: bottom),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                // “ручка” сверху
                const SizedBox(height: 10),
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const SizedBox(height: 12),

                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Фильтр',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      )
                    ],
                  ),
                ),

                // Content (scroll)
                Expanded(
                  child: BlocBuilder<FilterOptionsCubit, FilterOptionsState>(
                    builder: (context, filterOptionsState) {
                      final options = filterOptionsState.options;
                      return BlocBuilder<FilterCubit, CarQueryOptions>(
                        builder: (context, filterState) {
                          return SingleChildScrollView(
                            controller: scrollController,
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _SectionTitleFilter(text: 'Тип кузова'),
                                const SizedBox(height: 10),
                                _RadioGrid(
                                  items: options.bodyTypes,
                                  selectedIds: filterState.bodyTypeIds ?? [],
                                  onToggle: (id) => context.read<FilterCubit>().toggleBodyType(id),
                                ),
                                const SizedBox(height: 18),

                                _SectionTitleFilter(text: 'Тип автомобиля'),
                                const SizedBox(height: 10),
                                _RadioGrid(
                                  // Map pt string to pseudo-FilterItem
                                  items: options.powertrains.map((e) => FilterItem(id: e.hashCode, name: e)).toList(),
                                  selectedIds: (filterState.powertrains ?? []).map((e) => e.hashCode).toList(),
                                  onToggle: (id) {
                                    final pt = options.powertrains.firstWhere((e) => e.hashCode == id);
                                    context.read<FilterCubit>().togglePowertrain(pt);
                                  },
                                ),
                                const SizedBox(height: 18),

                                _SectionTitleFilter(text: 'Тип привода'),
                                const SizedBox(height: 10),
                                _RadioGrid(
                                  items: options.driveTypes,
                                  selectedIds: filterState.driveTypeIds ?? [],
                                  onToggle: (id) {
                                    final list = List<int>.from(filterState.driveTypeIds ?? []);
                                    if (list.contains(id)) list.remove(id); else list.add(id);
                                    context.read<FilterCubit>().updateQuery((q) => q.copyWith(driveTypeIds: list));
                                  },
                                ),
                                const SizedBox(height: 18),

                                _SectionTitleFilter(text: 'Бренды'),
                                const SizedBox(height: 10),
                                _BrandGrid(
                                  brands: options.brands,
                                  selectedIds: filterState.brandIds ?? [],
                                  onToggle: (id) => context.read<FilterCubit>().toggleBrand(id),
                                ),
                                const SizedBox(height: 18),

                                _SectionTitleFilter(text: 'Тип двигателя'),
                                const SizedBox(height: 10),
                                _RadioGrid(
                                  items: options.engineTypes,
                                  selectedIds: filterState.engineTypeIds ?? [],
                                  onToggle: (id) {
                                    final list = List<int>.from(filterState.engineTypeIds ?? []);
                                    if (list.contains(id)) list.remove(id); else list.add(id);
                                    context.read<FilterCubit>().updateQuery((q) => q.copyWith(engineTypeIds: list));
                                  },
                                ),
                                const SizedBox(height: 18),

                                _SectionTitleFilter(text: 'Цена'),
                                const SizedBox(height: 10),
                                //TODO PriceStub will need arguments, let's keep it unmodified for now
                                _PriceStub(),
                                const SizedBox(height: 90),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                // Bottom actions
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: Color(0x11000000))),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            context.read<FilterCubit>().reset();
                            context.read<CarCatalogBloc>().add(const GetCarsEvent());
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: const Text('Очистить'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<CarCatalogBloc>().add(GetCarsEvent(queryOptions: context.read<FilterCubit>().state));
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: const Color(0xFFE10600),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: const Text('Применить', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


class _SectionTitleFilter extends StatelessWidget {
  final String text;

  /// оформление
  final bool withBackground;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final BorderRadius borderRadius;

  /// текст
  final TextStyle? textStyle;
  final TextAlign textAlign;

  const _SectionTitleFilter({
    required this.text,
    this.withBackground = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    this.backgroundColor = const Color(0xFFF4F4F4),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.textStyle,
    this.textAlign = TextAlign.start,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final child = Text(
      text,
      textAlign: textAlign,
      style: textStyle ??
          const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
    );

    if (!withBackground) {
      return child;
    }

    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}


class _RadioGrid extends StatelessWidget {
  final List<FilterItem> items;
  final List<int> selectedIds;
  final Function(int) onToggle;

  const _RadioGrid({
    required this.items,
    required this.selectedIds,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 4.2,
      ),
      itemBuilder: (_, i) {
        final t = items[i];
        final isOn = selectedIds.contains(t.id);

        return InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => onToggle(t.id),
          child: Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isOn ? const Color(0xFFE10600) : const Color(0xFFD0D5DD),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isOn ? const Color(0xFFE10600) : Colors.transparent,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  t.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isOn ? Colors.black : Colors.black54,
                    fontWeight: isOn ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BrandGrid extends StatelessWidget {
  final List<FilterItem> brands;
  final List<int> selectedIds;
  final Function(int) onToggle;

  const _BrandGrid({
    required this.brands,
    required this.selectedIds,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: brands.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 3.4,
      ),
      itemBuilder: (_, i) {
        final b = brands[i];
        final isOn = selectedIds.contains(b.id);
        
        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => onToggle(b.id),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F4F4),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isOn ? const Color(0xFFE10600) : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.directions_car, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(b.name, overflow: TextOverflow.ellipsis)),
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isOn ? const Color(0xFFE10600) : const Color(0xFFD0D5DD),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isOn ? const Color(0xFFE10600) : Colors.transparent,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PriceStub extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'с 35 000.0 \$',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'до 75 000.0 \$',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        RangeSlider(
          values: const RangeValues(35000, 75000),
          min: 0,
          max: 150000,
          onChanged: (_) {},
        )
      ],
    );
  }
}
