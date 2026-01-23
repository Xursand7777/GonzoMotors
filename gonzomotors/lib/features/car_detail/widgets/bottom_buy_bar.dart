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
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.black.withOpacity(0.06))),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text(
                    _formatPrice(price),
                    style: const TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${_formatPrice(cipPrice)} CIP Tashkent',
                    style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              height: 44,
              width: 140,
              child: ElevatedButton(
                onPressed: onBuy,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: const Text('Купить', style: TextStyle(fontWeight: FontWeight.w900)),
              ),
            ),
          ],
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
