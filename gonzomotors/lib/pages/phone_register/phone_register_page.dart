import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../core/route/route_names.dart';
import '../../core/utils/common_utils.dart';
import '../../gen/assets.gen.dart';


class Country {
  final String name;
  final String iso2;
  final String dialCode;
  final String flag; // emoji

  const Country({
    required this.name,
    required this.iso2,
    required this.dialCode,
    required this.flag,
  });
}

/// Примерный список стран (можешь расширить)
const countries = <Country>[
  Country(name: 'Uzbekistan', iso2: 'UZ', dialCode: '+998', flag: '🇺🇿'),
  Country(name: 'Kazakhstan', iso2: 'KZ', dialCode: '+7', flag: '🇰🇿'),
  Country(name: 'Russia', iso2: 'RU', dialCode: '+7', flag: '🇷🇺'),
  Country(name: 'USA', iso2: 'US', dialCode: '+1', flag: '🇺🇸'),
];

/// ====== Страница регистрации по телефону ======
class PhoneRegisterPage extends StatefulWidget {
  const PhoneRegisterPage({super.key});

  @override
  State<PhoneRegisterPage> createState() => _PhoneRegisterPageState();
}

class _PhoneRegisterPageState extends State<PhoneRegisterPage> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  Country _selected = countries.first;
  bool _isValid = false;
  bool _sending = false; // состояние отправки OTP

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _onChanged() {
    final digits = _digitsOnly(_controller.text);
    final need = _selected.dialCode == '+998' ? 9 : 10;
    setState(() => _isValid = digits.length >= need);
  }

  String _digitsOnly(String s) => s.replaceAll(RegExp(r'\D'), '');

  String get _e164 {
    final digits = _digitsOnly(_controller.text);
    return '${_selected.dialCode}$digits';
  }

  /// Маска под страну
  List<TextInputFormatter> _formatters() {
    if (_selected.dialCode == '+998') {
      return [FilteringTextInputFormatter.digitsOnly, _UzbekistanPhoneFormatter()];
    }
    return [FilteringTextInputFormatter.digitsOnly, _GenericGroupingFormatter()];
  }

  void _openCountryPicker() async {
    _focus.unfocus();
    final chosen = await showModalBottomSheet<Country>(
      context: context,
      showDragHandle: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (_) {
        return ListView.separated(
          itemCount: countries.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (ctx, i) {
            final c = countries[i];
            return ListTile(
              leading: Text(c.flag, style: const TextStyle(fontSize: 24)),
              title: Text(c.name),
              subtitle: Text(c.dialCode),
              onTap: () => Navigator.of(ctx).pop(c),
            );
          },
        );
      },
    );
    if (chosen != null && mounted) {
      setState(() {
        _selected = chosen;
        _controller.clear();
        _isValid = false;
      });
    }
  }

  Future<void> _sendOtpAndNavigate() async {
    if (!_isValid || _sending) return;
    setState(() => _sending = true);
    try {
      // Необязательно, но полезно для Android (SMS Retriever API подпись)
      final appSignature = await SmsAutoFill().getAppSignature;
      debugPrint('App Signature: $appSignature');

      // Отправляем OTP (внутри CommonUtils будет сохранён verificationId -> CommonUtils.verify)
      await CommonUtils.firebasePhoneAuth(phone: _e164, context: context);

      if (!mounted) return;
      // Переходим на VerificationPage, передаём номер (пусть роут читает state.extra as String)
      context.pushNamed(RouteNames.verification, extra: _e164);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send OTP: $e')),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headline = theme.textTheme.headlineSmall?.copyWith(
      fontWeight: FontWeight.w800,
      color: Colors.black,
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.red.shade600,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Assets.icons.logo.image(),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'GonzoMotors',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Center(
                child: Column(
                  children: [
                    Text('Phone number', style: headline, textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    Text(
                      'Enter your phone number for registration',
                      style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'We will send SMS',
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.black45),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Поле ввода
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black26),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    // выбор страны
                    InkWell(
                      onTap: _sending ? null : _openCountryPicker,
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                        child: Row(
                          children: [
                            Text(_selected.flag, style: const TextStyle(fontSize: 22)),
                            const SizedBox(width: 6),
                            const Icon(Icons.keyboard_arrow_down_rounded),
                          ],
                        ),
                      ),
                    ),
                    Container(width: 1, height: 28, color: Colors.black12),
                    const SizedBox(width: 10),
                    Text(
                      _selected.dialCode,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 8),

                    // Само поле
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        focusNode: _focus,
                        enabled: !_sending,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          hintText: '12 345 67 89',
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 14),
                        ),
                        inputFormatters: _formatters(),
                        onSubmitted: (_) => _sendOtpAndNavigate(),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),

              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (_isValid && !_sending) ? Colors.red : Colors.red.shade200,
                    elevation: (_isValid && !_sending) ? 2 : 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: (_isValid && !_sending) ? _sendOtpAndNavigate : null,
                  child: _sending
                      ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                      : const Text(
                    'Continue',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

/// ====== Форматтеры ======
/// Узбекистан: 9 цифр, формат: 12 345 67 89
class _UzbekistanPhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buf = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      buf.write(digits[i]);
      // схема 2-3-2-2
      if (i == 1 || i == 4 || i == 6) buf.write(' ');
    }
    final text = buf.toString().trimRight();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

/// Общая группировка для 10 цифр: 3-3-4 (например для +1/+7)
class _GenericGroupingFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final d = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buf = StringBuffer();
    for (int i = 0; i < d.length; i++) {
      buf.write(d[i]);
      if (i == 2 || i == 5) buf.write(' ');
    }
    final text = buf.toString().trimRight();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}