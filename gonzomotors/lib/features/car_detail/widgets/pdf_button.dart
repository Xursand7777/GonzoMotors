import 'package:flutter/material.dart';

class PdfButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Widget? icon;

  const PdfButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.backgroundColor = const Color(0xFFE81E0E),
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 53,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor: backgroundColor.withOpacity(0.5),
          disabledForegroundColor: Colors.white.withOpacity(0.7),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
          padding: EdgeInsets.zero,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: 8),
            ],
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

