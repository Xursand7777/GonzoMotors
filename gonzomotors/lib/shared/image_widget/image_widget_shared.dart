import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';
import '../image_placeholder/image_placeholder_shared.dart';

enum ImageType {
  networkImage,
  networkSvg,
  assetImage,
  assetSvg,
  invalid,
}

class ImageWidgetShared extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Color? color;

  const ImageWidgetShared({
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    super.key,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final imageType = _getImageType(imageUrl);


    switch (imageType) {
      case ImageType.networkImage:
        return _buildNetworkImage();
      case ImageType.networkSvg:
        return _buildNetworkSvg();
      case ImageType.assetImage:
        return _buildAssetImage();
      case ImageType.assetSvg:
        return _buildAssetSvg();
      case ImageType.invalid:
        return _buildErrorPlaceholder();
    }
  }

  ImageType _getImageType(String? path) {
    if ( path == null || path.isEmpty || path == 'null') {
      return ImageType.invalid;
    }

    final lowerPath = path.toLowerCase();
    final isSvg = lowerPath.endsWith('.svg');
    final isNetwork = lowerPath.startsWith('http://') ||
        lowerPath.startsWith('https://');

    if (isNetwork) {
      return isSvg ? ImageType.networkSvg : ImageType.networkImage;
    } else {
      return isSvg ? ImageType.assetSvg : ImageType.assetImage;
    }
  }

  Widget _buildNetworkImage() {
    return CachedNetworkImage(
      imageUrl: imageUrl ?? '',
      width: width,
      height: height,
      fit: fit,
      errorWidget: (context, url, error) => _buildErrorPlaceholder(
        width: width,
        height: height,
      ),
      placeholder: (context, url) => _buildLoadingPlaceholder(
        width: width,
        height: height,
      ),
    );
  }

  Widget _buildNetworkSvg() {
    return SvgPicture.network(
      imageUrl ?? '',
      width: width,
      height: height,
      colorFilter:  color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
      fit: fit ?? BoxFit.contain,
      errorBuilder:  (context, error, stackTrace) =>  _buildErrorPlaceholder(),
      placeholderBuilder: (context) => _buildLoadingPlaceholder(),
    );
  }

  Widget _buildAssetImage() {
    return Image.asset(
      imageUrl ?? '',
      width: width,
      height: height,
      color:  color,
      fit: fit,

      errorBuilder: (context, error, stackTrace) => _buildErrorPlaceholder(),
    );
  }

  Widget _buildAssetSvg() {
    return SvgPicture.asset(
      imageUrl ?? '',
      width: width,
      height: height,
      colorFilter:  color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
      fit: fit ?? BoxFit.contain,
      errorBuilder:  (context, error, stackTrace) =>  _buildErrorPlaceholder(),
      placeholderBuilder: (context) => _buildLoadingPlaceholder(
        width:  width ?? 56,
        height: height?? 56,
      ),
    );
  }

  Widget _buildErrorPlaceholder({
    double? height,
    double? width,
  }) {
    return ImagePlaceholderShared.error(
      height:  height,
      width: width,
    );
  }

  Widget _buildLoadingPlaceholder({
    double? height,
    double? width ,
  }) {
    return ImagePlaceholderShared.error(
      height: height,
      width: width,
    );
  }
}