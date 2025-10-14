import 'package:flutter/material.dart';
import '../../core/theme/app_statics.dart';
import '../../core/theme/text_styles.dart';
import '../../gen/assets.gen.dart';
import '../../gen/colors.gen.dart';

class SearchTextFieldShared extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final bool autoFocus;
  final void Function(String? value)? onChanged;
  const SearchTextFieldShared({
    this.hintText,
    this.controller,
    super.key,
    this.suffixIcon,
    this.onChanged,
    this.autoFocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: autoFocus,
      cursorColor: ColorName.accentPrimary,
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.bodyRegularSecondary.copyWith(
            color: ColorName.contentSecondary,
          ),
          contentPadding: const EdgeInsets.only(
            left: 12,
            right: 16,
            top: 12,
            bottom: 12,
          ),
          suffixIcon: suffixIcon,
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left:8),
            child: Assets.icons.search.image(width: 24, height: 24),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppStatics.radiusXXLarge),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppStatics.radiusXXLarge),
              borderSide: BorderSide.none),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppStatics.radiusXXLarge),
              borderSide: BorderSide.none)),
    );
  }
}
