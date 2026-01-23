import 'package:flutter/material.dart';

class PdfButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;

  const PdfButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
