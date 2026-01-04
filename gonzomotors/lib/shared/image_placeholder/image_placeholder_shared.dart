import 'package:flutter/cupertino.dart';
import '../../gen/assets.gen.dart';
import '../../gen/colors.gen.dart';


class ImagePlaceholderShared extends StatelessWidget {
  final double height;
  final double width;

  const ImagePlaceholderShared._({
    super.key,
    required this.height,
    required this.width,
  });

  /// Фабричные конструкторы
  factory ImagePlaceholderShared.small({Key? key}) =>
      ImagePlaceholderShared._(key: key, height: 28, width: 36);

  factory ImagePlaceholderShared.medium({Key? key}) =>
      ImagePlaceholderShared._(key: key, height: 56, width: 72);

  factory ImagePlaceholderShared.large({Key? key}) =>
      ImagePlaceholderShared._(key: key, height: 150, width: 350);

  factory ImagePlaceholderShared.error({
    Key? key,
    double? height,
    double? width,
  }) =>
      ImagePlaceholderShared._(
        key: key,
        height: height ?? 56,
        width: width ?? 56,
      );

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: ColorName.backgroundPrimary,
      child: Center(
        child: Assets.icons.logo.image(
          height: height,
          width: width,
        ),
      ),
    );
  }
}
