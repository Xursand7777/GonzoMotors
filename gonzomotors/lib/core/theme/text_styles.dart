import 'package:flutter/material.dart';

abstract class AppTextStyles {
  static const headlineBoldPrimary =
  TextStyle(fontSize: 28, fontWeight: FontWeight.bold, height: 32 / 28,);

  static const headlineBoldSecondary =
  TextStyle(fontSize: 28, fontWeight: FontWeight.bold, height: 32 / 28,);

  static const headlineSemiboldPrimary = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 32/28,
  );

  static const headlineSemiboldSecondary = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 28/24,
  );

  static const titleSemiboldPrimary = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 28/20,
  );
  static const titleSemiboldSecondary = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 24/18,
  );
  static const titleSemiboldTertiary = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 22/16,
  );

  static const titleBoldPrimary = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 14 / 10,
  );
  static const titleBoldSecondary = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 4 / 3,
  );
  static const titleBoldTertiary = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 5 / 4,
  );

  static const bodyRegularPrimary = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 22/16,
  );
  static const bodyRegularSecondary = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20/14,
  );
  static const bodyRegularTertiary = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16/12,
  );

  static const bodyMediumPrimary = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 22/16,
  );
  static const bodyMediumSecondary = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 20/14,
  );
  static const bodyMediumTertiary = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16/12,
  );

  static const bodySemiboldPrimary = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 22/16,
  );
  static const bodySemiboldSecondary = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 20/14,
  );
  static const bodySemiboldTertiary = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 16/12,
  );

  static const specialBodyRegularPrimary = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 20/15,
  );
  static const specialBodyRegularSecondary = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 18/13,
  );

  static const specialBodyMediumPrimary = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 20/15,
  );
  static const specialBodyMediumSecondary = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 18/13,
  );
  static const specialLabelDanced = TextStyle(
    fontSize: 14,
    height: 16/14,
    fontWeight: FontWeight.w500,
  );


  static const captionRegularPrimary = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 14/12,
  );
  static const captionRegularSecondary = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 12/11,
  );

  static const captionMediumPrimary = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 14/12,
  );
  static const captionMediumSecondary = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 12/11,
  );
}

extension TextStyleHeightExtension on TextStyle {
  double getHeight(final BuildContext context) {
    final size =  MediaQuery.textScalerOf(context).scale(fontSize ?? 14 )  * (height ?? 1);

    return size;
  }
}

extension Tone on TextStyle {
  TextStyle primary(BuildContext c)   => copyWith(color: Theme.of(c).colorScheme.onSurface);
  TextStyle secondary(BuildContext c) => copyWith(color: Theme.of(c).colorScheme.onSurfaceVariant);
  TextStyle disabled(BuildContext c)  => copyWith(color: Theme.of(c).disabledColor);
}