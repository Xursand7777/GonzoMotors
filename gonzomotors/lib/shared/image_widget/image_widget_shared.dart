import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../image_placeholder/image_placeholder_shared.dart';

class ImageWidgetShared extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  const ImageWidgetShared(
      {required this.imageUrl, this.width, this.height, this.fit, super.key});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      errorWidget: (context, url, error) => ImagePlaceholderShared.large(),
      placeholder: (context, url) => ImagePlaceholderShared.large(),
    );
  }
}
