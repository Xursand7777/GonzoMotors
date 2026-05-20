import 'package:flutter/material.dart';

class BottomBuyBar extends StatelessWidget {
  final String title;
  final num? price;
  final num? cipPrice;
  final VoidCallback onBuy;

  const BottomBuyBar({
    super.key,
    required this.title,
    required this.price,
    required this.cipPrice,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(25, 16, 25, 16),
          decoration: const BoxDecoration(
            color: Color(0xFFF7F7F7),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatPrice(price),
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            color: Color(0xFFE81E0E),
                            fontSize: 23.3,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'цена с\nрастаможкой',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: Color(0xFFE81E0E),
                            fontSize: 10.2,
                            fontWeight: FontWeight.w400,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          _formatPrice(cipPrice),
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            color: Color(0xFF797979),
                            fontSize: 14.6,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          'СIP Tashkent',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: Color(0xFF797979),
                            fontSize: 14.6,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 49,
                width: 150,
                child: ElevatedButton(
                  onPressed: onBuy,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE81E0E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                    padding: EdgeInsets.zero,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.phone, size: 20, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Позвонить',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatPrice(num? value) {
    final v = (value ?? 0).round();
    final s = v.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final left = s.length - i;
      buf.write(s[i]);
      if (left > 1 && left % 3 == 1) buf.write(' ');
    }
    return '\$${buf.toString()}';
  }
}
