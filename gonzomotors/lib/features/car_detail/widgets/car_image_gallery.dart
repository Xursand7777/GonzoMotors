import 'package:flutter/material.dart';

class CarImageGallery extends StatefulWidget {
  final List<String> images;
  final String? placeholderAsset;

  const CarImageGallery({
    super.key,
    required this.images,
    this.placeholderAsset,
  });

  @override
  State<CarImageGallery> createState() => _CarImageGalleryState();
}

class _CarImageGalleryState extends State<CarImageGallery> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasImages = widget.images.isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 210,
        color: const Color(0xFFF6F6F6),
        child: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: hasImages ? widget.images.length : 1,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (context, i) {
                if (!hasImages) {
                  if (widget.placeholderAsset != null) {
                    return Image.asset(widget.placeholderAsset!, fit: BoxFit.contain);
                  }
                  return const Center(child: Icon(Icons.directions_car, size: 64, color: Colors.black26));
                }
                final url = widget.images[i];
                return Image.network(url, fit: BoxFit.contain);
              },
            ),

            // dots indicator
            Positioned(
              left: 0,
              right: 0,
              bottom: 10,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      hasImages ? widget.images.length : 1,
                          (i) => Container(
                        width: 7,
                        height: 7,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i == _index ? Colors.black : Colors.black.withOpacity(0.25),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
