import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/car_detail/bloc/car_detail_bloc.dart';
import '../../features/car_detail/bloc/car_detail_event.dart';
import '../../features/car_detail/bloc/car_detail_state.dart';
import '../../features/car_detail/data/repository/car_detail_repository.dart';
import '../../features/car_detail/widgets/bottom_buy_bar.dart';
import '../../features/car_detail/widgets/car_detail_app_bar.dart';
import '../../features/car_detail/widgets/car_image_gallery.dart';
import '../../features/car_detail/widgets/color_dots.dart';
import '../../features/car_detail/widgets/feature_cards.dart';
import '../../features/car_detail/widgets/modifications_grid.dart';
import '../../features/car_detail/widgets/pdf_button.dart';
import '../../features/car_detail/widgets/specs_table.dart';
import '../../core/di/app_injection.dart';

class CarDetailPage extends StatelessWidget {
  final int? modelId;
  final int? initialCarId;
  final CarDetailRepository? repository;

  const CarDetailPage({
    super.key,
    this.modelId,
    this.repository,
    this.initialCarId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CarDetailBloc(repository: sl.get())
        ..add(CarDetailOpened(modelId: modelId, preferredCarId: initialCarId)),
      child: const _CarDetailView(),
    );
  }
}

class _CarDetailView extends StatelessWidget {
  const _CarDetailView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CarDetailBloc, CarDetailState>(
      builder: (context, state) {
        final selected = state.selected;
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () async =>
                      context.read<CarDetailBloc>().add(const CarDetailRefresh()),
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: CarDetailAppBar(
                          title: selected?.carName ?? 'Car',
                          isFavorite: state!.isFavorite,
                          onBack: () => Navigator.of(context).maybePop(),
                          onFavorite: () => context.read<CarDetailBloc>().add(const CarDetailToggleFavorite()),
                          onShare: () {
                            // TODO share
                          },
                        ),
                      ),

                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              const SizedBox(height: 8),

                              // Фото/карусель
                              CarImageGallery(
                                images: selected?.images.map((e) => e.url ?? '').where((u) => u.isNotEmpty).toList() ?? const [],
                                placeholderAsset: null, // можешь поставить asset
                              ),

                              const SizedBox(height: 10),

                              // Цвета (пока заглушка, т.к. в модели нет цветов)
                              ColorDots(
                                selectedIndex: state.selectedColorIndex,
                                colors: const [
                                  Color(0xFFE5E5E5),
                                  Color(0xFFFF5A5A),
                                  Color(0xFFFFD54F),
                                  Color(0xFF42A5F5),
                                  Color(0xFFAB47BC),
                                  Color(0xFF1E88E5),
                                ],
                                onSelect: (i) => context.read<CarDetailBloc>().add(CarDetailSelectColor(i)),
                              ),

                              const SizedBox(height: 18),

                              // Модификации
                              ModificationsGrid(
                                title: 'Модификации',
                                modifications: state!.modifications,
                                selectedCarId: selected?.id,
                                onSelect: (carId) => context.read<CarDetailBloc>().add(CarDetailSelectModification(carId)),
                              ),

                              const SizedBox(height: 14),

                              // Таблица характеристик
                              SpecsTable(detail: selected),

                              const SizedBox(height: 14),

                              // PDF кнопка
                              PdfButton(
                                title: 'Подробно о модификации (PDF)',
                                onPressed: state.pdfUrl == null
                                    ? null
                                    : () {
                                  // TODO: открыть pdfUrl
                                },
                              ),
                              const SizedBox(height: 14),
                              // Cards (интеллектуальная кабина и т.п.)
                              FeatureCardsList(cards: state.featureCards),
                              const SizedBox(height: 110), // место под bottom bar
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // “Записывается на тест-драйв” (оверлей)
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 88,
                  child: _TestDriveStatusPill(
                    text: 'Записывается на тест-драйв',
                    onClose: () {},
                  ),
                ),
              ],
            ),
          ),

          // Bottom buy bar
          bottomNavigationBar: BottomBuyBar(
            title: selected?.model ?? '—',
            price: selected?.price,
            cipPrice: selected?.cipPrice,
            onBuy: () => context.read<CarDetailBloc>().add(const CarDetailBuyPressed()),
          ),
        );
      },
    );
  }
}

class _TestDriveStatusPill extends StatelessWidget {
  final String text;
  final VoidCallback onClose;

  const _TestDriveStatusPill({
    required this.text,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(999),
      color: const Color(0xFF2B2B2B),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            const Icon(Icons.directions_car, color: Colors.redAccent, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
            InkWell(
              onTap: onClose,
              child: Container(
                width: 26,
                height: 26,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFD54F),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(Icons.close, size: 16, color: Colors.black),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
