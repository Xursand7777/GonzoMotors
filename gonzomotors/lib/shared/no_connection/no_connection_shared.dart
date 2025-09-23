import 'package:flutter/material.dart';
import '../../core/theme/text_styles.dart';
import '../../gen/assets.gen.dart';
import '../../gen/colors.gen.dart';



class NoConnectionShared extends StatelessWidget {
  final Function()? onRetry;

  const NoConnectionShared({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Image.asset(
          Assets.icons.connectNo.path,
          width: 40,
          height: 40,
        ),
        const SizedBox(height: 8),
        const Text(
          'Internet aloqasi yo‘q',
          style: AppTextStyles.titleBoldPrimary,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.sizeOf(context).width * 0.2),
          child: Text(
            "Internetga ulaning va qayta urinib ko'ring!",
            style: AppTextStyles.bodyRegularSecondary.copyWith(
              color: ColorName.contentSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorName.accentPrimary,
              fixedSize: const Size.fromHeight(48),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              elevation: 0,
              shadowColor: Colors.transparent,
            ),
            onPressed: () {
              onRetry?.call();
            },
            child: Text(
              'Sahifani yangilang',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySemiboldPrimary.copyWith(
                color: ColorName.contentInverse,
              ),
            )),
      ]),
    );
  }
}
