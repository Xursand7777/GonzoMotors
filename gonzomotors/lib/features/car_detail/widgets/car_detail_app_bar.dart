import 'package:flutter/material.dart';

class CarDetailAppBar extends StatelessWidget {
  final String title;
  final bool isFavorite;
  final VoidCallback onBack;
  final VoidCallback onFavorite;
  final VoidCallback onShare;

  const CarDetailAppBar({
    super.key,
    required this.title,
    required this.isFavorite,
    required this.onBack,
    required this.onFavorite,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 6, 6, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            onPressed: onFavorite,
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
          ),
          IconButton(
            onPressed: onShare,
            icon: const Icon(Icons.ios_share),
          ),
        ],
      ),
    );
  }
}
