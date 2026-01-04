
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_statics.dart';
import '../../core/theme/text_styles.dart';
import '../../gen/colors.gen.dart';



/// Umumiy TextField widget - barcha input'lar uchun
class CustomTextField extends StatelessWidget {
  /// TextField controller
  final TextEditingController? controller;

  /// O'zgarganda chaqiriladigan callback
  final Function(String)? onChanged;

  /// Submit bo'lganda chaqiriladigan callback
  final Function(String)? onSubmitted;

  /// Hint text
  final String? hintText;

  /// Label text (yuqoridagi matn)
  final String? labelText;

  /// Prefix text (masalan: "+998 ")
  final String? prefixText;

  /// Prefix icon
  final Widget? prefixIcon;

  /// Suffix icon
  final Widget? suffixIcon;

  /// Keyboard type
  final TextInputType? keyboardType;

  /// Input formatters
  final List<TextInputFormatter>? inputFormatters;

  /// Enabled/Disabled
  final bool enabled;

  /// Loading holati
  final bool isLoading;

  /// Read only
  final bool readOnly;

  /// Obscure text (password uchun)
  final bool obscureText;

  /// Max length
  final int? maxLength;

  /// Max lines
  final int? maxLines;

  /// Min lines
  final int? minLines;

  /// Autofocus
  final bool autofocus;

  /// Focus node
  final FocusNode? focusNode;

  /// Text style
  final TextStyle? textStyle;

  /// Hint style
  final TextStyle? hintStyle;

  /// Prefix text style
  final TextStyle? prefixStyle;

  /// Background color
  final Color? backgroundColor;

  /// Border radius
  final double? borderRadius;

  /// Padding
  final EdgeInsetsGeometry? padding;

  /// Content padding (ichki padding)
  final EdgeInsetsGeometry? contentPadding;

  /// Error text
  final String? errorText;

  /// Validator
  final String? Function(String?)? validator;

  /// onTap callback
  final VoidCallback? onTap;

  /// Text align
  final TextAlign textAlign;

  /// Text capitalization
  final TextCapitalization textCapitalization;



  const CustomTextField({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.hintText,
    this.labelText,
    this.prefixText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.inputFormatters,
    this.enabled = true,
    this.isLoading = false,
    this.readOnly = false,
    this.obscureText = false,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.autofocus = false,
    this.focusNode,
    this.textStyle,
    this.hintStyle,
    this.prefixStyle,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.contentPadding,
    this.errorText,
    this.validator,
    this.onTap,
    this.textAlign = TextAlign.start,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label text (agar berilgan bo'lsa)
        if (labelText != null) ...[
          Text(
            labelText!,
            style: AppTextStyles.bodyMediumPrimary.copyWith(
              color: ColorName.contentSecondary,
            ),
          ),
          const SizedBox(height: 8),
        ],

        // TextField container
        AbsorbPointer(
          absorbing: isLoading || !enabled,
          child: InkWell(
            onTap: readOnly ? onTap : null,
            borderRadius: BorderRadius.circular(
              borderRadius ?? AppStatics.radiusMedium,
            ),
            child: Container(
              padding: padding ??
                  const EdgeInsets.only(
                    left: 16,
                    right: 8,
                    top: 8,
                    bottom: 8,
                  ),
              decoration: BoxDecoration(
                color: backgroundColor ?? ColorName.backgroundPrimary,
                borderRadius: BorderRadius.circular(
                  borderRadius ?? AppStatics.radiusMedium,
                ),
                border: errorText != null
                    ? Border.all(
                  color: ColorName.accentRedPrimary,
                  width: 1,
                )
                    : null,
              ),
              child: Row(
                children: [
                  // Prefix icon
                  if (prefixIcon != null) ...[
                    prefixIcon!,
                    const SizedBox(width: 8),
                  ],

                  // Prefix text
                  if (prefixText != null)
                    Text(
                      prefixText!,
                      style: prefixStyle ??
                          AppTextStyles.bodyMediumPrimary.copyWith(
                            color: ColorName.contentPrimary,
                          ),
                    ),

                  // TextField
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onChanged: onChanged,
                      onSubmitted: onSubmitted,
                      onTap: onTap,
                      focusNode: focusNode,
                      enabled: enabled && !isLoading,
                      readOnly: readOnly,
                      obscureText: obscureText,
                      autofocus: autofocus,
                      maxLength: maxLength,
                      maxLines: maxLines,
                      minLines: minLines,
                      keyboardType: keyboardType,
                      inputFormatters: inputFormatters,
                      textAlign: textAlign,
                      textCapitalization: textCapitalization,
                      style: textStyle ?? AppTextStyles.bodyMediumPrimary,
                      decoration: InputDecoration(
                        hintText: hintText,
                        hintStyle: hintStyle ??
                            AppTextStyles.bodyMediumPrimary.copyWith(
                              color: ColorName.contentTeritary,
                            ),
                        suffixIcon: suffixIcon,
                        contentPadding: contentPadding ?? const EdgeInsets.all(0),
                        filled: true,
                        fillColor: Colors.transparent,
                        counterText: '',
                        border: const UnderlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide.none,
                        ),
                        errorBorder: const UnderlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Error text
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: AppTextStyles.bodyRegularSecondary.copyWith(
              color: ColorName.accentRedPrimary,
            ),
          ),
        ],
      ],
    );
  }
}

// Telefon raqam uchun wrapper
class PhoneNumberTextField extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Widget? suffixIcon;
  final bool isLoading;
  final List<TextInputFormatter>? additionalFormatters;
  final String? errorText;

  const PhoneNumberTextField({
    super.key,
    this.controller,
    this.onChanged,
    this.suffixIcon,
    this.isLoading = false,
    this.additionalFormatters,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      onChanged: onChanged,
      hintText: "Telefon raqamingiz",
      prefixText: "+998 ",
      suffixIcon: suffixIcon,
      isLoading: isLoading,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        if (additionalFormatters != null) ...additionalFormatters!,
      ],
      errorText: errorText,
    );
  }
}

// Password uchun wrapper
class PasswordTextField extends StatefulWidget {
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final String? hintText;
  final String? labelText;
  final bool isLoading;
  final String? errorText;

  const PasswordTextField({
    super.key,
    this.controller,
    this.onChanged,
    this.hintText,
    this.labelText,
    this.isLoading = false,
    this.errorText,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      hintText: widget.hintText ?? "Parol",
      labelText: widget.labelText,
      isLoading: widget.isLoading,
      obscureText: _obscureText,
      errorText: widget.errorText,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: ColorName.contentSecondary,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      ),
    );
  }
}