import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/route/route_names.dart';
import '../../gen/assets.gen.dart';

class AppBarShared extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget? customLeading;
  final bool showBack;

  const AppBarShared({
    super.key,
    this.title,
    this.customLeading,
    this.actions,
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showBack
          ? Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          shape: const CircleBorder(),
          color: const Color(0xFFB4C0CC).withValues(alpha: 0.22),
          child: InkWell(
            onTap: () => _back(context),
            borderRadius: BorderRadius.circular(100),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Assets.icons.strokeArrowLeft
                  .image(width: 24, height: 24),
            ),
          ),
        ),
      )
          : customLeading,
      title: title != null
          ? Text(
        title!,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
      )
          : null,
      centerTitle: title != null,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      shadowColor: Colors.transparent,
      elevation: 0,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void _back(BuildContext context) {
    if (GoRouter.of(context).canPop()) {
      GoRouter.of(context).pop();
    } else {
      GoRouter.of(context).goNamed(RouteNames.splash);
    }
  }


}
