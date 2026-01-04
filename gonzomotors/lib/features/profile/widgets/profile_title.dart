


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_statics.dart';
import '../../../core/theme/text_styles.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';
import '../bloc/profile_bloc.dart';

class ProfileTitleWidget extends StatelessWidget {
  const ProfileTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state.user == null) {
          return const _UserNotLoginWidget();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.user != null ? state.user!.firstName ?? '' : 'you name ',
              style: AppTextStyles.headlineBoldPrimary,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              state.user != null ? state.user!.phone ?? '' : 'you phone number',
              style: AppTextStyles.bodyRegularSecondary.copyWith(
                color: ColorName.contentTeritary,
              ),
            ),
            const SizedBox(height: 8),
            BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state.user != null) {
                  return const SizedBox(height: 8,);
                }
                return Column(
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        ///TODO: change color xml
                        color: const Color(0xFF3399FF),
                        borderRadius:
                        BorderRadius.circular(AppStatics.radiusLarge),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 4,
                          right: 8,
                          top: 4,
                          bottom: 4,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Assets.icons.check.svg(
                              width: 16,
                              height: 16,
                            ),
                            Text(
                              'aksiyasi ishtirokchisi',
                              style: AppTextStyles.specialBodyMediumSecondary
                                  .copyWith(
                                color: ColorName.contentInverse,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                  ],
                );
              },
            ),
            const Divider(
              color: ColorName.lineDivider,
              indent: 24,
              endIndent: 24,
            ),
          ],
        );
      },
    );
  }
}

class _UserNotLoginWidget extends StatelessWidget {
  const _UserNotLoginWidget();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Akkountga kirish',
            style: AppTextStyles.headlineBoldPrimary,
          ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Bu ko‘p vaqt olmaydi, faqat telefon raqamingiz kerak.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyRegularSecondary.copyWith(
                color: ColorName.contentTeritary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: ColorName.accentBrandNamePrimary,
                  fixedSize: const Size.fromHeight(48),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  minimumSize: const Size.fromHeight(
                    48,
                  ),
                  maximumSize: const Size.fromHeight(
                    48,
                  )),
              onPressed: () {
                _openAuthPage(context);
              },
              child: Text(
                'Kirish yoki ro‘yxatdan o‘tish',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySemiboldPrimary.copyWith(
                  color: ColorName.contentInverse,
                ),
              )),
          const SizedBox(
            height: 24,
          ),
          const Divider(
            color: ColorName.lineDivider,
            indent: 24,
            endIndent: 24,
          ),
        ],
      ),
    );
  }

  void _openAuthPage(BuildContext context) {
   // context.read<ProfileCubit>().navigateTo(ProfileNavigation.register);
  }
}