// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsCarsGen {
  const $AssetsCarsGen();

  /// File path: assets/cars/bmw-5-series-m5.jpg
  AssetGenImage get bmw5SeriesM5 =>
      const AssetGenImage('assets/cars/bmw-5-series-m5.jpg');

  /// File path: assets/cars/lucid-air-sapphire.webp
  AssetGenImage get lucidAirSapphire =>
      const AssetGenImage('assets/cars/lucid-air-sapphire.webp');

  /// File path: assets/cars/mercedes-maybach-eqs.jpg
  AssetGenImage get mercedesMaybachEqs =>
      const AssetGenImage('assets/cars/mercedes-maybach-eqs.jpg');

  /// File path: assets/cars/zeekr-001.jpg
  AssetGenImage get zeekr001 =>
      const AssetGenImage('assets/cars/zeekr-001.jpg');

  /// List of all assets
  List<AssetGenImage> get values => [
    bmw5SeriesM5,
    lucidAirSapphire,
    mercedesMaybachEqs,
    zeekr001,
  ];
}

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/available.png
  AssetGenImage get available =>
      const AssetGenImage('assets/icons/available.png');

  /// File path: assets/icons/calendar.png
  AssetGenImage get calendar =>
      const AssetGenImage('assets/icons/calendar.png');

  /// File path: assets/icons/close_circle.png
  AssetGenImage get closeCircle =>
      const AssetGenImage('assets/icons/close_circle.png');

  /// File path: assets/icons/connect_no.png
  AssetGenImage get connectNo =>
      const AssetGenImage('assets/icons/connect_no.png');

  /// File path: assets/icons/electro.png
  AssetGenImage get electro => const AssetGenImage('assets/icons/electro.png');

  /// File path: assets/icons/hybrid.png
  AssetGenImage get hybrid => const AssetGenImage('assets/icons/hybrid.png');

  /// File path: assets/icons/language.png
  AssetGenImage get language =>
      const AssetGenImage('assets/icons/language.png');

  /// File path: assets/icons/log_out.png
  AssetGenImage get logOut => const AssetGenImage('assets/icons/log_out.png');

  /// File path: assets/icons/logo.png
  AssetGenImage get logo => const AssetGenImage('assets/icons/logo.png');

  /// File path: assets/icons/logo_new.png
  AssetGenImage get logoNew => const AssetGenImage('assets/icons/logo_new.png');

  /// File path: assets/icons/magazine.png
  AssetGenImage get magazine =>
      const AssetGenImage('assets/icons/magazine.png');

  /// File path: assets/icons/md_catalog.png
  AssetGenImage get mdCatalog =>
      const AssetGenImage('assets/icons/md_catalog.png');

  /// File path: assets/icons/md_menu.png
  AssetGenImage get mdMenu => const AssetGenImage('assets/icons/md_menu.png');

  /// File path: assets/icons/navigation_logo2.png
  AssetGenImage get navigationLogo2 =>
      const AssetGenImage('assets/icons/navigation_logo2.png');

  /// File path: assets/icons/notification.png
  AssetGenImage get notification =>
      const AssetGenImage('assets/icons/notification.png');

  /// File path: assets/icons/onboarding1.png
  AssetGenImage get onboarding1 =>
      const AssetGenImage('assets/icons/onboarding1.png');

  /// File path: assets/icons/onboarding2.png
  AssetGenImage get onboarding2 =>
      const AssetGenImage('assets/icons/onboarding2.png');

  /// File path: assets/icons/popular.png
  AssetGenImage get popular => const AssetGenImage('assets/icons/popular.png');

  /// File path: assets/icons/premium.png
  AssetGenImage get premium => const AssetGenImage('assets/icons/premium.png');

  /// File path: assets/icons/profile.png
  AssetGenImage get profile => const AssetGenImage('assets/icons/profile.png');

  /// File path: assets/icons/search.png
  AssetGenImage get search => const AssetGenImage('assets/icons/search.png');

  /// File path: assets/icons/settings.png
  AssetGenImage get settings =>
      const AssetGenImage('assets/icons/settings.png');

  /// File path: assets/icons/splash.png
  AssetGenImage get splash => const AssetGenImage('assets/icons/splash.png');

  /// File path: assets/icons/stroke-arrow-left.png
  AssetGenImage get strokeArrowLeft =>
      const AssetGenImage('assets/icons/stroke-arrow-left.png');

  /// File path: assets/icons/trash.png
  AssetGenImage get trash => const AssetGenImage('assets/icons/trash.png');

  /// File path: assets/icons/user.png
  AssetGenImage get user => const AssetGenImage('assets/icons/user.png');

  /// File path: assets/icons/xiamo.png
  AssetGenImage get xiamo => const AssetGenImage('assets/icons/xiamo.png');

  /// File path: assets/icons/xiamoyu7.png
  AssetGenImage get xiamoyu7 =>
      const AssetGenImage('assets/icons/xiamoyu7.png');

  /// File path: assets/icons/zeekr001.png
  AssetGenImage get zeekr001 =>
      const AssetGenImage('assets/icons/zeekr001.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    available,
    calendar,
    closeCircle,
    connectNo,
    electro,
    hybrid,
    language,
    logOut,
    logo,
    logoNew,
    magazine,
    mdCatalog,
    mdMenu,
    navigationLogo2,
    notification,
    onboarding1,
    onboarding2,
    popular,
    premium,
    profile,
    search,
    settings,
    splash,
    strokeArrowLeft,
    trash,
    user,
    xiamo,
    xiamoyu7,
    zeekr001,
  ];
}

class Assets {
  const Assets._();

  static const $AssetsCarsGen cars = $AssetsCarsGen();
  static const $AssetsIconsGen icons = $AssetsIconsGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
