

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/route/route_names.dart';
import '../../core/theme/text_styles.dart';
import '../../gen/assets.gen.dart';
import '../../shared/button/button_shared.dart';
import '../../shared/padding/padding_shared.dart';
import '../dashboard/cubit/dashboard_cubit.dart';

class SuccessPage extends StatelessWidget {
  final SuccessNavigation navigation;

  const SuccessPage({super.key, this.navigation = SuccessNavigation.login});

  @override
  Widget build(BuildContext context) {
    return _SuccessView(
      navigation: navigation,
    );
  }
}

class _SuccessView extends StatelessWidget {
  final SuccessNavigation navigation;

  const _SuccessView({this.navigation = SuccessNavigation.login});

  @override
  Widget build(BuildContext context) {
    final descriptionText = switch (navigation) {
      SuccessNavigation.login =>
      'Tabriklaymiz, tizimga muvaffaqtiyatli kirdingiz!',
      SuccessNavigation.register =>
      'Tabriklaymiz, tizimdan muvaffaqtiyatli ro‘yhatdan o‘tdingiz!',
      SuccessNavigation.none => 'Amal muvaffaqiyatli bajarildi.',
    };

    final titleText = switch (navigation) {
      SuccessNavigation.login => 'Profilga o‘tish',
      SuccessNavigation.register => 'Profilga o‘tish',
      SuccessNavigation.none => 'Muvaffaqiyatli',
    };

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment:  CrossAxisAlignment.center,
                children: [
                  Assets.icons.checkCircleFill.svg(
                    width: 72,
                    height: 72,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    textAlign: TextAlign.center,
                    'Muvaffaqiyatli',
                    style: AppTextStyles.headlineBoldSecondary,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    descriptionText,
                    style: AppTextStyles.bodyRegularPrimary.copyWith(
                      /// TODO: color add qilib qoshiladi colors xml ga
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // BlocBuilder<ProfileBloc, ProfileState>(
          //   builder: (context, state) {
          //     if (state.user != null && state.user!.studentUniversity != null) {
          //       return const SizedBox(
          //         height: 0,
          //       );
          //     }
          //   },
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: ButtonSharedWidget.auth(
                text: titleText,
                onTap: () => _onPressedNavigate(
                  context,
                  navigation,
                )),
          ),
          PaddingShared.bottom(
            context,
            additional: 14,
          ),
        ],
      ),
    );
  }

  void _onPressedNavigate(BuildContext context, SuccessNavigation navigation) {
    context.goNamed(RouteNames.dashboard);
  }
}

enum SuccessNavigation { login, register,  none }
