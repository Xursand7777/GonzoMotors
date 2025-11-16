import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gonzo_motors/core/route/route_names.dart';
import 'package:gonzo_motors/pages/verification/widgets/border_box.dart';
import 'package:gonzo_motors/pages/verification/widgets/white_container.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../core/di/app_injection.dart';
import '../../features/verification/bloc/verification_bloc.dart';
import '../../features/verification/data/repository/verification_repository.dart';

class VerificationPage extends StatefulWidget {
  final String phone;

  const VerificationPage({super.key, required this.phone});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  @override
  void initState() {
    super.initState();
    _listenOtp();
  }

  void _listenOtp() async {
    await SmsAutoFill().listenForCode();
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VerificationBloc(
        repository: sl<VerificationRepository>(),
        phoneNumber: widget.phone,
      ),
      child: BlocConsumer<VerificationBloc, VerificationState>(
        listener: (context, state) {
          if (state.status.isError()) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Ошибка')),
            );
          }

          if (state.status.isSuccess()) {
            context.goNamed(RouteNames.dashboard);
          }
        },
        builder: (context, state) {
          final bloc = context.read<VerificationBloc>();
          final isLoading = state.status.isLoading();

          return SafeArea(
            child: Scaffold(
              backgroundColor:
              isLoading ? Colors.white : const Color(0xFF070707),
              body: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(top: 50),
                          child: Container(height: 50),
                        ),
                        const SizedBox(height: 25),
                        WhiteContainer(
                          headerText: "Enter Code",
                          labelText:
                          "Code has been successfully sent to your \n ${widget.phone}",
                          child: SizedBox(
                            height: 70,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                PinFieldAutoFill(
                                  currentCode: state.code,
                                  decoration: BoxLooseDecoration(
                                    radius: Radius.circular(12),
                                    strokeColorBuilder:
                                    const FixedColorBuilder(
                                      Color(0xFFEC0322),
                                    ),
                                  ),
                                  codeLength: 6,
                                  onCodeChanged: (code) {
                                    if (code == null) return;
                                    bloc.add(VerificationCodeChanged(code));
                                  },
                                  onCodeSubmitted: (val) {
                                    bloc.add(
                                        const VerificationSubmitted());
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 30, vertical: 30),
                color: Colors.white,
                child: GestureDetector(
                  onTap: isLoading
                      ? null
                      : () {
                    bloc.add(const VerificationSubmitted());
                  },
                  child: Opacity(
                    opacity: isLoading ? 0.6 : 1,
                    child: const BorderBox(
                      margin: false,
                      color: Color(0xFFEC0322),
                      height: 50,
                      child: Text(
                        "Continue",
                        style:
                        TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

