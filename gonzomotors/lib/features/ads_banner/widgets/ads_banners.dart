import 'dart:async';

import 'package:flutter/material.dart' ;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/theme/app_statics.dart';
import '../../../gen/colors.gen.dart';
import '../../../shared/image_widget/image_widget_shared.dart';
import '../../../shared/page_dot_Indicator/page_dot_indicator_shared.dart';
import '../bloc/ads_banner_bloc.dart';
import '../data/models/ads_banner_model.dart';


class AdsBannerWidget extends StatefulWidget {
  final Function(AdsBannerModel banner)? onBannerTap;
  const AdsBannerWidget({super.key, this.onBannerTap});

  @override
  State<AdsBannerWidget> createState() => _AdsBannerWidgetState();
}

class _AdsBannerWidgetState extends State<AdsBannerWidget> {
  late PageController _pageController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    context.read<AdsBannerBloc>().add(const GetBannersEvent());
    _pageController = PageController();
    _page3SecondsAutoScroll();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _page3SecondsAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted || !_pageController.hasClients) return;
      final state = context.read<AdsBannerBloc>().state;
      final len = state.banners.length;
      if (len < 2) return;

      final curr = _pageController.page?.round() ?? 0;
      final next = (curr + 1) % len;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width - 32;
    final h = w * (150 / 350);

    return BlocBuilder<AdsBannerBloc, AdsBannerState>(
      builder: (context, state) {
        final success = state.status.isSuccess();
        final len = success ? state.banners.length : 0;
       // final showShimmer = !success || len == 0;
        final showShimmer = true;
        return SizedBox(
          height: h + 10,
          child: Column(
            children: [
              SizedBox(
                width: w,
                height: h,
                child: showShimmer
                    ? const _SearchAdsBannerShimmer()
                    : PageView.builder(
                  controller: _pageController,
                  itemCount: len,
                  itemBuilder: (_, i) => _BannerView(
                    banner: state.banners[i],
                    onTap: (b) {
                      widget.onBannerTap?.call(b);
                      context.read<AdsBannerBloc>().add(ClickedBannerEvent(b.id));
                    },
                  ),
                ),
              ),
              const SizedBox(height: 5),
              PageDotIndicatorShared(
                controller: _pageController,
                itemCount: showShimmer ? 1 : len,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BannerView extends StatelessWidget {
  final AdsBannerModel banner;
  final Function(AdsBannerModel)? onTap;
  const _BannerView({required this.banner, this.onTap});

  @override
  Widget build(BuildContext context) {
    // фиксированный размер (как и у контейнера наверху)
    final  double bannerW = MediaQuery.sizeOf(context).width - 32;
    final  double bannerH = bannerW * (150 / 350);

    // отмечаем просмотр
    context.read<AdsBannerBloc>().add(SeenBannerEvent(banner.id));

    return GestureDetector(
      onTap: () => onTap?.call(banner),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppStatics.radiusXLarge),
        child: SizedBox(
          width: bannerW,
          height: bannerH,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // картинка
              ImageWidgetShared(
                imageUrl: banner.imageUrl ?? "",
                fit: BoxFit.cover,
              ),

              // лёгкий градиент снизу (для читаемости текста)
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color.fromARGB(110, 0, 0, 0),
                      Color.fromARGB(30, 0, 0, 0),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

              // контент поверх
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // заголовок (верх-лево)
                    Text(
                      banner.title ?? 'Zeekr 9x',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // описание (2 строки)
                    Expanded(
                      child: Text(
                        banner.title ??
                            'Электрический кроссовер с салоном SUV+ и умными ассистентами. Смотреть характеристики и офферы',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          height: 1.25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // кнопка справа-низу
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: const Color(0xFF3B6BFF), // синий как на макете
                          foregroundColor: Colors.white,
                          elevation: 0,
                        ),
                        onPressed: () => onTap?.call(banner),
                        child: const Text(
                          'Подробнее',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchAdsBannerShimmer extends StatelessWidget {
  const _SearchAdsBannerShimmer();

  @override
  Widget build(BuildContext context) {
    final  double bannerW = MediaQuery.sizeOf(context).width - 32;
    final  double bannerH = bannerW * (150 / 350);

    return SizedBox(
      width: bannerW,
      height: bannerH,
      child: Shimmer.fromColors(
        baseColor: ColorName.contentMuted,
        highlightColor: ColorName.contentSecondary,
        child: Container(
          decoration: BoxDecoration(
            color: ColorName.backgroundPrimary,
            borderRadius: BorderRadius.circular(AppStatics.radiusXLarge),
          ),
        ),
      ),
    );
  }
}
