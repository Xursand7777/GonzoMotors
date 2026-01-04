import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gonzo_motors/core/utils/common_utils.dart';

import '../../core/di/app_injection.dart';
import '../../core/route/route_names.dart';
import '../../core/theme/app_statics.dart';
import '../../core/theme/text_styles.dart';
import '../../features/profile/bloc/profile_bloc.dart';
import '../../features/profile/widgets/profile_title.dart';
import '../../gen/assets.gen.dart';
import '../../gen/colors.gen.dart';
import '../../shared/app_bar/app_bar_shared.dart';
import '../../shared/image_widget/image_widget_shared.dart';
import 'cubit/profile_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProfileCubit(sl.get()),
        ),
      ],
      child: _ProfileView()
    );
  }
}

class _ProfileView extends StatefulWidget {
  const _ProfileView();

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  const AppBarShared(),
      body: BlocListener<ProfileCubit, ProfilePageState>(
        listener: (context, state) {
          switch (state.navigation) {
            case ProfileNavigation.login:
              // context.pushNamed(RouteNames.bonus);
              break;
            case ProfileNavigation.register:
              context.pushNamed(RouteNames.auth);
              break;
            case ProfileNavigation.none:
              break;
            case null:
              break;
            case ProfileNavigation.promotion:
              // context.pushNamed(RouteNames.bonus);
              break;
          }
        },
        child: Stack(
          children: [
            RefreshIndicator.adaptive(
              key: _refreshIndicatorKey,
              onRefresh: () => _refreshProfile(context),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const ProfileTitleWidget(),
                    const SizedBox(
                      height: 24,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    const _SettingsWidget()
                  ],
                ),
              ),
            ),
            BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                log('Profile state status: ${state.status}');
                if (state.status.isLoading()) {
                  return const Center(child: CupertinoActivityIndicator());
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  _openPromotionPage(BuildContext context) {
    context.read<ProfileCubit>().navigateTo(ProfileNavigation.promotion);
  }

  _refreshProfile(BuildContext context) async {
    _refreshIndicatorKey.currentState?.show();
    context.read<ProfileBloc>().add(const GetProfileEvent());

    await Future.delayed(
      const Duration(seconds: 1),
          () => _refreshIndicatorKey.currentState?.deactivate(),
    );
  }
}

class _SettingsWidget extends StatelessWidget {
  const _SettingsWidget();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sozlamalar',
            style: AppTextStyles.bodyRegularSecondary.copyWith(
              color: ColorName.contentTeritary,
            ),
          ),
          const SizedBox(height: 16),
          BlocBuilder<ProfileBloc, ProfileState>(
            buildWhen: (previous, current) => previous.user != current.user,
            builder: (context, state) {
              if (state.user == null) {
                return const SizedBox.shrink();
              }
              return Column(
                children: [
                  _SettingsItem(
                    imagePath: Assets.icons.passportLine.path,
                    title: 'Shaxsiy ma’lumotlar',
                    trailingWidget: _trailingArrowWidget,
                    onTap: () {
                      context.pushNamed(RouteNames.editProfile);
                    },
                  ),
                  _SettingsItem(
                    imagePath: Assets.icons.security.path,
                    title: 'Xavfsizlik',
                    trailingWidget: _trailingArrowWidget,
                    onTap: () {
                      context.pushNamed(RouteNames.security);
                    },
                  ),
                ],
              );
            },
          ),
          _SettingsItem(
            imagePath: Assets.icons.language.path,
            title: 'Ilova tili',
            subtitle: 'O\'zbek',
            trailingWidget: _trailingMoreWidget,
            onTap: () => _onTapLanguage(context,
                message:
                'Tez kunlarda yangi mintaqalar uchun boshqa tillar ham qoʻshiladi 😊'),
          ),
          _SettingsItem(
            imagePath: Assets.icons.notification.path,
            title: 'Xabarnoma',
            onTap: () => _onTapLanguage(context),
            trailingWidget: _SwitchWidget(
              onChanged: (value) {},
              initialIsSwitched: true,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Qo\'llab-quvvatlash xizmati',
            style: AppTextStyles.bodyRegularSecondary.copyWith(
              color: ColorName.contentTeritary,
            ),
          ),
          const SizedBox(height: 16),
          _SettingsItem(
            imagePath: Assets.icons.phone.path,
            title: 'Qo\'ng\'iroq qilish',
            trailingWidget: _trailingMoreWidget,
            onTap: () => _onTapPhone(context),
          ),
          _SettingsItem(
            imagePath: Assets.icons.message.path,
            title: 'Mutaxassisga yozing',
            trailingWidget: _trailingMoreWidget,
            onTap: () => _onTapMessage(context),
          ),
          BlocBuilder<ProfileBloc, ProfileState>(
            buildWhen: (previous, current) => previous.user != current.user,
            builder: (context, state) {
              if (state.user == null) {
                return const SizedBox.shrink();
              }
              return _SettingsItem(
                imagePath: Assets.icons.logOut.path,
                title: 'Dasturdan chiqish',
                titleColor: ColorName.accentBrandNamePrimary,
                trailingWidget: _trailingMoreWidget,
                onTap: () => _exitApp(context),
              );
            },
          ),
          const SizedBox(height: 40),
          Center(
            child: Column(
              children: [
                Text(
                  'Moomkin',
                  style: AppTextStyles.bodyRegularSecondary.copyWith(
                    color: ColorName.contentTeritary,
                  ),
                ),
                BlocBuilder<ProfileCubit, ProfilePageState>(
                  buildWhen: (previous, current) =>
                  previous.appVersion != current.appVersion,
                  builder: (context, state) {
                    return Text(
                      'Talqin ${state.appVersion}',
                      style: AppTextStyles.bodyRegularSecondary.copyWith(
                        color: ColorName.contentTeritary,
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _exitApp(BuildContext context) async {
    final exit = await showDialog(
      context: context,
      builder: (context) => DialogShow(
        title: "Ilovadan chiqmoqchimisiz?",
        content:
        "Hisobingizdan chiqmoqchisiz? Keyingi safar qayta kirish uchun login va parol talab qilinadi.",
        onCancelText: "Bekor qilish",
        onConfirmText: "Ha, chiqish",
        onCancel: () {
          context.pop();
        },
        onConfirm: () {
          context.pop(true);
        },
      ),
    );
    if (exit == true) {
      context.mounted
          ? context.read<ProfileBloc>().add(const UserLoggedOutEvent())
          : null;
    }
  }

  void _onTapMessage(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => DialogShow(
            title: "Mutaxasisga yozing",
            content:
            "Biz bilan bog'lanish uchun \"Mutaxasisga yozing\" tugmasini bosing. Sizni Instagram sahifamizga olib boradi.",
            onCancelText: "Bekor qilish",
            onConfirmText: "Mutaxasisga yozing",
            onCancel: () {
              context.pop();
            },
            onConfirm: () {
              context.pop();
              openWebsiteAndLink("https://t.me/moomkinadmin");
            }));
  }

  void _onTapPhone(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => DialogShow(
            title: "Qo'ng'iroq qilish",
            content:
            "Biz bilan bog'lanish uchun \"Qong'ioroq qilsh\" tugmasini bosing. Sizni telefon raqamimizga olib boradi.",
            onCancelText: "Bekor qilish",
            onConfirmText: "Qo'ng'iroq qilish",
            onCancel: () {
              context.pop();
            },
            onConfirm: () {
              context.pop();
              openPhoneNumberCall("+998904800337");
            }));
  }

  void _onTapLanguage(BuildContext context,
      {String message = 'Hozircha bu funksiya mavjud emas'}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          message,
          style: AppTextStyles.bodyRegularPrimary.copyWith(
            color: ColorName.contentInverse,
          ),
        ),
        backgroundColor: ColorName.accentBrandNamePrimary,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

Widget _trailingArrowWidget = const Icon(
  Icons.arrow_forward_ios,
  size: 16,
  color: ColorName.contentTeritary,
);

Widget _trailingMoreWidget = const Icon(
  Icons.more_vert,
  color: ColorName.contentTeritary,
);

class _SwitchWidget extends StatefulWidget {
  final bool initialIsSwitched;
  final Function(bool)? onChanged;

  const _SwitchWidget({
    this.initialIsSwitched = false,
    this.onChanged,
  });

  @override
  State<_SwitchWidget> createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<_SwitchWidget> {
  bool _isSwitched = false;

  @override
  void initState() {
    _isSwitched = widget.initialIsSwitched;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: _isSwitched,
      onChanged: null,
      inactiveThumbColor: ColorName.backgroundSecondary.withValues(alpha: 0.1),
      inactiveTrackColor: ColorName.backgroundSecondary.withValues(alpha: 0.5),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final String imagePath;
  final String title;
  final String? subtitle;
  final Widget? trailingWidget;
  final Color? titleColor;
  final VoidCallback? onTap;

  const _SettingsItem({
    required this.imagePath,
    required this.title,
    this.subtitle,
    this.trailingWidget,
    this.titleColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppStatics.radiusMedium),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            ImageWidgetShared(
              imageUrl: imagePath,
              width: 28,
              height: 28,
              color: titleColor ?? ColorName.contentPrimary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyRegularPrimary.copyWith(
                  color: titleColor,
                ),
              ),
            ),
            if (subtitle != null) ...[
              Text(
                subtitle!,
                style: AppTextStyles.bodyRegularSecondary.copyWith(
                  color: ColorName.contentTeritary,
                ),
              ),
              const SizedBox(
                width: 8,
              )
            ],
            if (trailingWidget != null) trailingWidget!,
          ],
        ),
      ),
    );
  }
}

class DialogShow extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback? onConfirm;
  final String onConfirmText;
  final VoidCallback? onCancel;
  final String onCancelText;
  final bool isExpanded;

  const DialogShow({
    super.key,
    required this.title,
    required this.content,
    this.onConfirm,
    this.onConfirmText = '',
    this.onCancel,
    this.onCancelText = '',
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.headlineSemiboldSecondary,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              content,
              style: AppTextStyles.bodyRegularSecondary.copyWith(
                color: ColorName.contentTeritary,
              ),
            ),
            const SizedBox(height: 16),
            if (isExpanded) ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorName.backgroundPrimary,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          elevation: 0,
                          shadowColor: Colors.transparent,
                        ),
                        onPressed: onCancel,
                        child: Text(
                          onCancelText,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodySemiboldPrimary.copyWith(
                            color: ColorName.contentPrimary,
                          ),
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorName.accentBrandNamePrimary,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          elevation: 0,
                          shadowColor: Colors.transparent,
                        ),
                        onPressed: onConfirm,
                        child: Text(
                          onConfirmText,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodySemiboldPrimary.copyWith(
                            color: ColorName.contentInverse,
                          ),
                        )),
                  ),
                ],
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorName.backgroundPrimary,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          elevation: 0,
                          shadowColor: Colors.transparent,
                        ),
                        onPressed: onCancel,
                        child: Text(
                          onCancelText,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodySemiboldPrimary.copyWith(
                            color: ColorName.contentPrimary,
                          ),
                        )),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorName.accentBrandNamePrimary,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          elevation: 0,
                          shadowColor: Colors.transparent,
                        ),
                        onPressed: onConfirm,
                        child: Text(
                          onConfirmText,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodySemiboldPrimary.copyWith(
                            color: ColorName.contentInverse,
                          ),
                        )),
                  ),
                ],
              )
            ]
          ],
        ),
      ),
    );
  }
}


