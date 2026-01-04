import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../../core/theme/app_statics.dart';
import '../../../core/theme/text_styles.dart';
import '../../../gen/colors.gen.dart';
import '../../../pages/auth/cubit/auth_cubit.dart';
import '../../../shared/button/button_shared.dart';
import '../../../shared/custom_text_field/custom_text_field.dart';
import '../bloc/auth_bloc.dart';

List<Widget> get authPages => _pages;

const _pages = [
  _AuthPhoneNumberWidget(),
  _AuthOtpCodeWidget(),
  _AuthInfoWidget(),
];


class _AuthPhoneNumberWidget extends StatelessWidget {
  const _AuthPhoneNumberWidget();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthPageState>(
      listenWhen: (previous, current) =>
      previous.isVerified != current.isVerified ||
          current.status.isLoading(),
      listener: (context, state) {
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      },
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsetsGeometry.only(
                top: 32,
                bottom: MediaQuery
                    .viewInsetsOf(context)
                    .bottom + 24,
              ),
              child: Column(
                children: [
                  Text(
                    "Ilova kiring yoki ro'yxatdan o'ting",
                    style: AppTextStyles.headlineSemiboldPrimary
                        .copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Xizmatlardan to'liq foydalanish uchun telefon raqamingizni kiriting. Biz sizga tasdiqlash kodi yuboramiz.",
                    style: AppTextStyles.bodyRegularPrimary.copyWith(
                      color: ColorName.contentSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return CustomTextField(
                        controller: context
                            .read<AuthBloc>()
                            .phoneController,
                        onChanged: (value) {
                          context.read<AuthBloc>().add(
                            const CheckPhoneNumberEvent(),
                          );
                        },
                        hintText: "Telefon raqamingiz",
                        prefixText: "+998 ",
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          context
                              .read<AuthBloc>()
                              .phoneMaskFormatter,
                        ],
                        isLoading: state.status.isLoading(),
                        suffixIcon: _buildPhoneSuffixIcon(context, state),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsGeometry.only(
              bottom: MediaQuery
                  .paddingOf(context)
                  .bottom + 24,
            ),
            child: BlocBuilder<AuthBloc, AuthState>(
              buildWhen: (previous, current) =>
              previous.isVerified != current.isVerified ||
                  current.status.isLoading(),
              builder: (context, state) {
                final enabled = state.isVerified && !state.status.isLoading();
                return ButtonSharedWidget.auth(
                  onTap: () {
                    context
                        .read<AuthBloc>()
                        .add(const ConfirmPhoneNumberEvent());
                  },
                  enabled: enabled,
                  text: "Kod yuborish",
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}



class _AuthOtpCodeWidget extends StatefulWidget {
  const _AuthOtpCodeWidget();

  @override
  State<_AuthOtpCodeWidget> createState() => _AuthOtpCodeWidgetState();
}

class _AuthOtpCodeWidgetState extends State<_AuthOtpCodeWidget>
    with CodeAutoFill {
  late final FocusNode focusNode;
  late final GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    focusNode = FocusNode();

    _startListeningForSms();
  }

  Future<void> _startListeningForSms() async {
    final signature = await SmsAutoFill().getAppSignature;
    log('App Signature: $signature');

    listenForCode();
  }

  @override
  void codeUpdated() {
    log('SMS Code received: $code');

    if (code != null && code!.length == 4) {
      context.read<AuthBloc>().pinController.text = code!;

      context.read<AuthBloc>().add(const ChangeOtpEvent());
    }
  }

  @override
  void dispose() {
    cancel();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: AppTextStyles.headlineBoldPrimary,
      decoration: BoxDecoration(
        color: ColorName.backgroundPrimary,
        borderRadius: BorderRadius.circular(AppStatics.radiusMedium),
      ),
    );

    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Text(
              "Tasdiqlash kodi",
              style: AppTextStyles.headlineSemiboldPrimary
                  .copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              "Telefon raqamingizga 4 xonali tasdiqlash kodini yubordik. Uni shu yerga kiriting.",
              style: AppTextStyles.bodyRegularPrimary.copyWith(
                color: ColorName.contentSecondary,
              ),
            ),
            const SizedBox(height: 32),
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Pinput(
                        controller: context.read<AuthBloc>().pinController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        length: 4,
                        focusNode: focusNode,
                        autofocus: true,
                        defaultPinTheme: defaultPinTheme,
                        separatorBuilder: (index) => const SizedBox(width: 8),
                        hapticFeedbackType: HapticFeedbackType.lightImpact,
                        onChanged: (_) {
                          context.read<AuthBloc>().add(const ChangeOtpEvent());
                        },
                        cursor: Center(
                          child: Container(
                            width: 1.5,
                            height: 20,
                            decoration: BoxDecoration(
                              color: ColorName.accentBrandNamePrimary,
                              borderRadius: BorderRadius.circular(1.5),
                            ),
                          ),
                        ),
                        submittedPinTheme: defaultPinTheme.copyWith(
                          textStyle: AppTextStyles.headlineBoldPrimary.copyWith(
                            color: state.status.isSuccess()
                                ? ColorName.accentGreenPrimary
                                : ColorName.contentPrimary,
                          ),
                        ),
                        forceErrorState: state.status.isError(),
                        errorPinTheme: defaultPinTheme.copyWith(
                          textStyle: AppTextStyles.headlineBoldPrimary.copyWith(
                            color: ColorName.accentRedPrimary,
                          ),
                        ),
                        errorTextStyle:
                        AppTextStyles.bodyRegularSecondary.copyWith(
                          color: ColorName.accentRedPrimary,
                        ),
                        errorText: state.status.message,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (state.status.isLoading()) ...[
              const SizedBox(height: 60),
              const Center(child: CupertinoActivityIndicator())
            ],
            const Expanded(child: SizedBox()),
            BlocBuilder<AuthCubit, AuthPageState>(
              builder: (context, state) {
                final enabled = state.resendCodeTime <= 0;
                return ButtonSharedWidget.auth(
                  enabled: enabled,
                  onTap: () {
                    context.read<AuthBloc>().add(const ResendOtpCodeEvent());
                  },
                  text:
                  "Qaytadan yuborish${state.resendCodeTime > 0 ? ": ${state.resendCodeTime} " : ""}",
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}


class _AuthInfoWidget extends StatelessWidget {
  const _AuthInfoWidget();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsetsGeometry.only(
                  top: 32,
                  bottom: MediaQuery
                      .viewInsetsOf(context)
                      .bottom + 24,
                ),
                child: Column(
                  children: [
                    Text(
                      "Shaxsiy ma'lumotlaringizni qo'shing",
                      style: AppTextStyles.headlineSemiboldPrimary
                          .copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Ismingiz va tug'ilgan sanangiz asosida sizga mos tavsiyalar va xizmatlar taklif qilamiz.",
                      style: AppTextStyles.bodyRegularPrimary.copyWith(
                        color: ColorName.contentSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Name field with validation
                    BlocBuilder<AuthBloc, AuthState>(
                      buildWhen: (previous, current) =>
                      previous.nameError != current.nameError,
                      builder: (context, state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextField(
                              controller:
                              context
                                  .read<AuthBloc>()
                                  .nameController,
                              hintText: "Ismingiz ",
                              keyboardType: TextInputType.name,
                              textCapitalization: TextCapitalization.words,
                              onChanged: (value) {
                                context
                                    .read<AuthBloc>()
                                    .add(const CheckUserInfoValidationEvent());
                              },
                            ),
                            if (state.nameError != null) ...[
                              const SizedBox(height: 4),
                              Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Text(
                                  state.nameError!,
                                  style: AppTextStyles.bodyRegularSecondary
                                      .copyWith(
                                    color: ColorName.accentRedPrimary,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    CustomTextField(
                      controller: context
                          .read<AuthBloc>()
                          .lastController,
                      hintText: "Familyangiz",
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                    ),

                    const SizedBox(height: 16),

                    // Birth date field with validation
                    const _DateOfBirthWidget(),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Submit button - Now goes to next page
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery
                    .paddingOf(context)
                    .bottom + 24,
              ),
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return ButtonSharedWidget.auth(
                    text: "Keyingi",
                    onTap: () {
                      context
                          .read<AuthBloc>()
                          .add(const ValidateUserInfoEvent());
                    },
                    enabled: state.isUserInfoValid,
                  );
                },
              ),
            ),
          ],
        ),
        BlocBuilder<AuthBloc, AuthState>(
          buildWhen: (previous, current) => previous.status != current.status,
          builder: (context, state) {
            if (!state.status.isLoading()) {
              return const SizedBox.shrink();
            }
            return const Center(child: CupertinoActivityIndicator());
          },
        ),
      ],
    );
  }
}

class _DateOfBirthWidget extends StatelessWidget {
  const _DateOfBirthWidget();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (previous, current) =>
      previous.userDateOfBirth != current.userDateOfBirth ||
          previous.birthDateError != current.birthDateError,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              controller: context
                  .read<AuthBloc>()
                  .birthDateController,
              hintText: "(kk.oo.yyyy) Tug'ilgan sanangiz ",
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                context
                    .read<AuthBloc>()
                    .birthDateMaskFormatter,
              ],
              onChanged: (value) {
                if (value.length == 10) {
                  final parts = value.split('.');
                  if (parts.length == 3) {
                    try {
                      final day = int.parse(parts[0]);
                      final month = int.parse(parts[1]);
                      final year = int.parse(parts[2]);
                      final date = DateTime(year, month, day);

                      context
                          .read<AuthBloc>()
                          .add(SetUserDateEvent(date: date));
                    } catch (e) {
                      context
                          .read<AuthBloc>()
                          .add(const CheckUserInfoValidationEvent());
                    }
                  }
                } else {
                  context
                      .read<AuthBloc>()
                      .add(const CheckUserInfoValidationEvent());
                }
              },
              suffixIcon: InkWell(
                onTap: () => _onTapDateOfBirth(context),
                child: const Icon(
                  Icons.calendar_today,
                  color: ColorName.contentSecondary,
                  size: 20,
                ),
              ),
              textStyle: AppTextStyles.bodyRegularSecondary.copyWith(
                color: ColorName.contentPrimary,
              ),
            ),
            if (state.birthDateError != null) ...[
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  state.birthDateError!,
                  style: AppTextStyles.bodyRegularSecondary.copyWith(
                    color: ColorName.accentRedPrimary,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

void _onTapDateOfBirth(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) =>
        BlocProvider.value(
          value: context.read<AuthBloc>(),
          child: const _SelectDateOfBirth(),
        ),
  );
}

class _SelectDateOfBirth extends StatelessWidget {
  const _SelectDateOfBirth();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppStatics.radiusMedium),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          const Text(
            "Tug'ilgan sanangizni tanlang",
            style: AppTextStyles.titleSemiboldPrimary,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: MediaQuery
                .sizeOf(context)
                .height * 0.2,
            child: CupertinoDatePicker(
              initialDateTime: context
                  .read<AuthBloc>()
                  .state
                  .userDateOfBirth ??
                  DateTime(DateTime
                      .now()
                      .year - 12, 1, 1),
              mode: CupertinoDatePickerMode.date,
              minimumYear: DateTime
                  .now()
                  .year - 100,
              maximumYear: DateTime
                  .now()
                  .year - 5,
              onDateTimeChanged: (date) {
                context.read<AuthBloc>().add(SetUserDateEvent(date: date));
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const SizedBox(width: 16),
              Expanded(
                child: ButtonSharedWidget(
                  text: "Bekor qilish",
                  onTap: () => context.pop(),
                  backgroundColor: ColorName.backgroundPrimary,
                  textColor: ColorName.contentPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ButtonSharedWidget(
                  text: "Tanlash",
                  onTap: () {
                    context.pop();
                  },
                  backgroundColor: ColorName.accentBrandNamePrimary,
                  textColor: ColorName.contentInverse,
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}


Widget _buildPhoneSuffixIcon(BuildContext context, AuthState state) {
    if (state.status.isLoading()) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: ColorName.accentBrandNamePrimary,
        ),
      );
    }

    if (context
        .read<AuthBloc>()
        .phoneController
        .text
        .isEmpty) {
      return const SizedBox();
    }

    return InkWell(
      onTap: () {
        context
            .read<AuthBloc>()
            .phoneController
            .clear();
        context.read<AuthBloc>().add(
          const CheckPhoneNumberEvent(),
        );
      },
      child: const Icon(
        Icons.close,
        color: ColorName.contentSecondary,
      ),
    );
  }




