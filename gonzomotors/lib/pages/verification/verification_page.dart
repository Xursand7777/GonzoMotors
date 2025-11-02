// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// class VerificationPage extends StatefulWidget {
//   const VerificationPage({
//     super.key,
//     required this.phone,
//     this.resendDelay = const Duration(seconds: 120),
//     this.onSubmit,
//     this.onResend,
//     this.onCantReceive,
//   });
//
//   final String phone;
//   final Duration resendDelay;
//   final Future<void> Function(String code)? onSubmit;
//   final Future<void> Function()? onResend;
//   final VoidCallback? onCantReceive;
//
//   @override
//   State<VerificationPage> createState() => _VerificationPageState();
// }
//
// class _VerificationPageState extends State<VerificationPage> {
//   late final List<TextEditingController> _ctrls;
//   late final List<FocusNode> _nodes;
//   Timer? _timer;
//   int _secondsLeft = 0;
//   bool _submitting = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _ctrls = List.generate(6, (_) => TextEditingController());
//     _nodes = List.generate(6, (_) => FocusNode());
//     _startTimer();
//     // автофокус на первую ячейку
//     WidgetsBinding.instance.addPostFrameCallback((_) => _nodes.first.requestFocus());
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     for (final c in _ctrls) {
//       c.dispose();
//     }
//     for (final n in _nodes) {
//       n.dispose();
//     }
//     super.dispose();
//   }
//
//   void _startTimer() {
//     _timer?.cancel();
//     _secondsLeft = widget.resendDelay.inSeconds;
//     _timer = Timer.periodic(const Duration(seconds: 1), (t) {
//       if (!mounted) return;
//       setState(() {
//         _secondsLeft--;
//         if (_secondsLeft <= 0) {
//           _secondsLeft = 0;
//           t.cancel();
//         }
//       });
//     });
//   }
//
//   String get _code => _ctrls.map((c) => c.text).join();
//
//   bool get _isFilled => _code.length == 6 && !_code.contains(RegExp(r'[^0-9]'));
//
//   Future<void> _submit() async {
//     if (!_isFilled || widget.onSubmit == null) return;
//     setState(() => _submitting = true);
//     try {
//       await widget.onSubmit!.call(_code);
//     } finally {
//       if (mounted) setState(() => _submitting = false);
//     }
//   }
//
//   Future<void> _resend() async {
//     if (_secondsLeft > 0) return;
//     await widget.onResend?.call();
//     _clearAll();
//     _startTimer();
//   }
//
//   void _clearAll() {
//     for (final c in _ctrls) {
//       c.clear();
//     }
//     _nodes.first.requestFocus();
//     setState(() {});
//   }
//
//   void _onChanged(int index, String value) {
//     // Пропускаем всё, кроме одной цифры
//     if (value.length > 1) {
//       _ctrls[index].text = value.characters.last;
//       _ctrls[index].selection = TextSelection.collapsed(offset: 1);
//     }
//
//     if (value.isNotEmpty && index < _nodes.length - 1) {
//       _nodes[index + 1].requestFocus();
//     }
//
//     // Проверяем, заполнен ли код полностью
//     if (_isFilled) {
//       // Снимаем фокус, чтобы клавиатура скрылась
//       FocusScope.of(context).unfocus();
//
//       // Автосабмит
//       Future.microtask(() => _submit());
//     }
//
//     setState(() {});
//   }
//
//
//   KeyEventResult _onKey(FocusNode node, KeyEvent e, int index) {
//     if (e is KeyDownEvent && e.logicalKey == LogicalKeyboardKey.backspace) {
//       if (_ctrls[index].text.isEmpty && index > 0) {
//         _nodes[index - 1].requestFocus();
//         _ctrls[index - 1].clear();
//       }
//     }
//     return KeyEventResult.ignored;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_ctrls.isEmpty || _nodes.isEmpty) {
//       return const SizedBox.shrink();
//     }
//
//     final theme = Theme.of(context);
//     final isDark = theme.brightness == Brightness.dark;
//
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new_rounded),
//           onPressed: () => Navigator.of(context).maybePop(),
//         ),
//         title: const Text('Verification 1'),
//         elevation: 0,
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24),
//           child: Column(
//             children: [
//               const SizedBox(height: 12),
//               GestureDetector(
//                 onTap: widget.onCantReceive,
//                 child: Text(
//                   "Can't receive SMS",
//                   style: theme.textTheme.bodyMedium?.copyWith(color: Colors.red),
//                 ),
//               ),
//               const SizedBox(height: 32),
//               Text(
//                 'Sent message',
//                 style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 6),
//               Text(
//                 widget.phone,
//                 style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 24),
//
//               // ✅ Рисуем только если контроллеры готовы
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(6, (i) {
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 6),
//                     child: _buildCodeBox(context, i, isDark),
//                   );
//                 }),
//               ),
//
//               const SizedBox(height: 16),
//               if (_secondsLeft > 0)
//                 Text(
//                   'Retry sending in $_secondsLeft seconds.',
//                   style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
//                   textAlign: TextAlign.center,
//                 )
//               else
//                 TextButton(
//                   onPressed: _resend,
//                   child: const Text('Resend code'),
//                 ),
//               const Spacer(),
//               SizedBox(
//                 width: double.infinity,
//                 child: FilledButton(
//                   onPressed: _isFilled && !_submitting ? _submit : null,
//                   child: _submitting
//                       ? const SizedBox(
//                     height: 18,
//                     width: 18,
//                     child: CircularProgressIndicator(strokeWidth: 2),
//                   )
//                       : const Text('Continue'),
//                 ),
//               ),
//               const SizedBox(height: 16),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCodeBox(BuildContext context, int i, bool isDark) {
//     final theme = Theme.of(context);
//     return SizedBox(
//       width: 46,
//       height: 50,
//       child: Focus(
//         focusNode: _nodes[i],
//         onKeyEvent: (node, e) => _onKey(node, e, i),
//         child: TextField(
//           controller: _ctrls[i],
//           textAlign: TextAlign.center,
//           style: theme.textTheme.titleMedium,
//           keyboardType: TextInputType.number,
//           autofillHints: const [AutofillHints.oneTimeCode],
//           inputFormatters: [
//             FilteringTextInputFormatter.digitsOnly,
//             LengthLimitingTextInputFormatter(1),
//           ],
//           onChanged: (v) => _onChanged(i, v),
//           decoration: InputDecoration(
//             isDense: true,
//             contentPadding: EdgeInsets.zero,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(
//                 color: isDark ? const Color(0xFF334155) : const Color(0xFF94A3B8),
//                 width: 1.4,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gonzo_motors/core/route/route_names.dart';
import 'package:gonzo_motors/pages/verification/widgets/border_box.dart';
import 'package:gonzo_motors/pages/verification/widgets/white_container.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../core/utils/common_utils.dart';


class VerificationPage extends StatefulWidget {
  final String phone;

  const VerificationPage({super.key, required this.phone});

  @override
  State<VerificationPage> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<VerificationPage> {
  String otpCode = "";
  String otp = "";
  bool isLoaded = false;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    _listenOtp();
    super.initState();
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    print("Unregistered Listener");
    super.dispose();
  }

  void _listenOtp() async {
    await SmsAutoFill().listenForCode();
    print("OTP Listen is called");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: isLoaded ? Colors.white : const Color(0xFF070707),
        body: isLoaded
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
                            currentCode: otpCode,
                            decoration: BoxLooseDecoration(
                              radius: Radius.circular(12),
                              strokeColorBuilder: const FixedColorBuilder(
                                Color(0xFFEC0322),
                              ),
                            ),
                            codeLength: 6,
                            onCodeChanged: (code) {
                              print("OnCodeChanged : $code");
                              otpCode = code.toString();
                            },
                            onCodeSubmitted: (val) {
                              print("OnCodeSubmitted : $val");
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
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          color: Colors.white,
          child: GestureDetector(
            onTap: () async {
              print("OTP: $otpCode");
              setState(() {
                isLoaded = true;
              });
              try {
                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                  verificationId: CommonUtils.verify,
                  smsCode: otpCode,
                );
                await auth.signInWithCredential(credential);
                setState(() {
                  isLoaded = false;
                });
                Navigator.of(context).pushNamed(RouteNames.dashboard);
              } catch (e) {
                setState(() {
                  isLoaded = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Wrong OTP! Please enter again")),
                );
                print("Wrong OTP");
              }
            },
            child: const BorderBox(
              margin: false,
              color: Color(0xFFEC0322),
              height: 50,
              child: Text(
                "Continue",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

}