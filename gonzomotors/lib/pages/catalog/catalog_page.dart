import 'package:flutter/material.dart';
import 'package:gonzo_motors/pages/car_catalog/car_catalog_page.dart';
import '../../features/car_catalog/widgets/car_list.dart';
import '../../shared/search_text_field_shared/search_text_field_shared.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF6F7F9),
      appBar: _CatalogAppBar(),
      body: CatalogPageView(),
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
    return CustomScrollView(
      slivers: [
        // Верхняя часть страницы как обычные виджеты, но внутри SliverList
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                const SearchTextFieldShared(),
                const SizedBox(height: 16),

                _SectionTitle(title: 'Тип автомобиля'),
                const SizedBox(height: 10),
                SizedBox(
                  height: 96,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: carTypes.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, i) {
                      final item = carTypes[i];
                      return _SelectableCard(
                        width: 104,
                        height: 96,
                        selected: selectedCarType == i,
                        onTap: () => setState(() => selectedCarType = i),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(item.icon, size: 34, color: const Color(0xFF2E7D32)),
                            const SizedBox(height: 8),
                            Text(
                              item.title,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF111827),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 18),
                _SectionTitle(title: 'Тип кузова'),
                const SizedBox(height: 10),
                SizedBox(
                  height: 74,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: bodyTypes.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, i) {
                      return _SoftCard(
                        width: 112,
                        height: 74,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              bodyTypes[i],
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF111827),
                              ),
                            ),
                          ),
                        ),
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
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFFF3B30),
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(Icons.chevron_right,
                                size: 18, color: Color(0xFFFF3B30)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 110,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: brands.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, i) {
                      final b = brands[i];
                      return _SelectableCard(
                        width: 120,
                        height: 110,
                        selected: selectedBrand == i,
                        onTap: () => setState(() => selectedBrand = i),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color(0xFF111827),
                                  width: 2,
                                ),
                              ),
                              child: const Icon(Icons.crop_square,
                                  size: 18, color: Color(0xFF111827)),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              b.name,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${b.modelsCount} моделей',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF9CA3AF),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
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
                            builder: (_) => const FilterBottomSheet(),
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
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xFF111827),
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
    final borderColor = selected ? const Color(0xFFFF3B30) : const Color(0xFFE5E7EB);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: selected ? 1.6 : 1),
          boxShadow: const [
            BoxShadow(
              blurRadius: 10,
              offset: Offset(0, 4),
              color: Color(0x0F111827),
            )
          ],
        ),
        child: child,
      ),
    );
  }
}

class _SoftCard extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;

  const _SoftCard({
    required this.width,
    required this.height,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
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
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionTitleFilter(text: 'Тип кузова',),
                        const SizedBox(height: 10),
                        _RadioGrid(items: const [
                          'Внедорожник', 'Кроссовер',
                          'Лифтбек', 'Хечбек',
                          'Седан', 'Спорт',
                        ]),
                        const SizedBox(height: 18),

                        _SectionTitleFilter(text:'Тип автомобиля'),
                        const SizedBox(height: 10),
                        _RadioGrid(items: const ['Гибрид', 'Электро', 'Бензин']),
                        const SizedBox(height: 18),

                        _SectionTitleFilter(text:'Тип привода'),
                        const SizedBox(height: 10),
                        _RadioGrid(items: const [
                          'FWD', 'RWD', '4WD', 'FWD / 4WD', 'RWD / 4WD', 'XWD', 'AWD'
                        ]),
                        const SizedBox(height: 18),

                        _SectionTitleFilter(text:'Бренды'),
                        const SizedBox(height: 10),
                        _BrandGrid(brands: List.generate(10, (_) => 'Zeekr')),
                        const SizedBox(height: 18),

                        _SectionTitleFilter(text:'Тип двигателя'),
                        const SizedBox(height: 10),
                        _RadioGrid(items: List.generate(10, (_) => '1.5 Turbo')),
                        const SizedBox(height: 18),

                        _SectionTitleFilter(text:'Цена'),
                        const SizedBox(height: 10),
                        _PriceStub(),
                        const SizedBox(height: 90),
                      ],
                    ),
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
                            // TODO reset
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
                            // TODO apply + close
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


class _RadioGrid extends StatefulWidget {
  final List<String> items;
  const _RadioGrid({required this.items});

  @override
  State<_RadioGrid> createState() => _RadioGridState();
}

class _RadioGridState extends State<_RadioGrid> {
  String? selected;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 4.2,
      ),
      itemBuilder: (_, i) {
        final t = widget.items[i];
        final isOn = selected == t;

        return InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => setState(() => selected = t),
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
                  t,
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

class _BrandGrid extends StatefulWidget {
  final List<String> brands;
  const _BrandGrid({required this.brands});

  @override
  State<_BrandGrid> createState() => _BrandGridState();
}

class _BrandGridState extends State<_BrandGrid> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.brands.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 3.4,
      ),
      itemBuilder: (_, i) {
        final isOn = selectedIndex == i;
        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => setState(() => selectedIndex = i),
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
                Expanded(child: Text(widget.brands[i])),
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
