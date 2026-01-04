import 'package:flutter/material.dart';
import '../../core/theme/text_styles.dart';
import '../../gen/colors.gen.dart';
import '../bouncing/bouncing_widget.dart';

class ButtonSharedWidget extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color? textColor;
  final bool enabled;
  final IconData? icon;

  const ButtonSharedWidget({
    super.key,
    this.enabled = true,
    required this.text,
    required this.onTap,
    this.textColor,
    this.backgroundColor = ColorName.backgroundPrimary,
    this.icon,
  });

  const ButtonSharedWidget.auth({
    super.key,
    required this.text,
    required this.onTap,
    this.icon,
    this.enabled = true,
  })  : backgroundColor = enabled
      ? ColorName.accentBrandNamePrimary
      : ColorName.backgroundMuted,
        textColor =
        enabled ? ColorName.contentInverse : ColorName.contentTeritary;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: !enabled,
      child: Bouncing(
        onTap: onTap,
        child: SizedBox(
          width: double.infinity,
          child: Material(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(32),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon,
                        size: 20, color: textColor ?? ColorName.contentPrimary),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Text(

                      textAlign:  TextAlign.center,
                      maxLines: 1,
                      text,
                      overflow:  TextOverflow.ellipsis,
                      style: AppTextStyles.titleSemiboldSecondary
                          .copyWith(color: textColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
