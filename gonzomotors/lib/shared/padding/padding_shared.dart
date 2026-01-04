import 'package:flutter/material.dart';

class PaddingShared extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry padding;

  const PaddingShared._(this.child, this.padding, {super.key});

  factory PaddingShared.top(BuildContext context, Widget child, {double additional = 0.0, Key? key}) {
    final top = MediaQuery.of(context).padding.top + additional;
    return PaddingShared._(child, EdgeInsets.only(top: top), key: key);
  }

  factory PaddingShared.bottom(BuildContext context,  {Widget? child,double additional = 0.0, Key? key}) {
    final bottom = MediaQuery.of(context).padding.bottom + additional;
    return PaddingShared._(child, EdgeInsets.only(bottom: bottom), key: key);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: child ?? const SizedBox.shrink(),
    );
  }
}
