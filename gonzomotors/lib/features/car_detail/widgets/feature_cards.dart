import 'package:flutter/material.dart';
import '../data/repository/car_detail_repository.dart';

class FeatureCardsList extends StatelessWidget {
  final List<CarFeatureCard> cards;

  const FeatureCardsList({super.key, required this.cards});

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 240,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: cards.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final c = cards[i];
          return SizedBox(
            width: 260,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // image top
                    Container(
                      height: 110,
                      color: const Color(0xFFF6F6F6),
                      child: c.imageUrl.isEmpty
                          ? const Center(child: Icon(Icons.image, color: Colors.black26))
                          : Image.network(c.imageUrl, fit: BoxFit.cover, width: double.infinity),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.title,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            c.description,
                            style: TextStyle(color: Colors.black.withOpacity(0.65), height: 1.3),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
