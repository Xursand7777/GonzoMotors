import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../core/theme/text_styles.dart';
import '../../gen/colors.gen.dart';

class CustomFooterShared extends StatelessWidget {
  final String? canLoadingText;
  final String? loadingText;
  final String? failedLoadingText;
  final String? noDataText;
  const CustomFooterShared(
      {this.canLoadingText,
        this.loadingText,
        this.failedLoadingText,
        this.noDataText,
        super.key});

  @override
  Widget build(BuildContext context) {
    return CustomFooter(
      builder: (context, mode) {
        Widget body;
        if (mode == LoadStatus.idle) {
          body = Text(
            canLoadingText ?? "Yuklash uchun torting",
            style: AppTextStyles.bodyMediumPrimary
                .copyWith(color: ColorName.contentMuted),
          );
        } else if (mode == LoadStatus.loading) {
          body = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 20,
                height: 20,
                child: CupertinoActivityIndicator(),
              ),
              const SizedBox(width: 10),
              Text(
                loadingText ?? "Yuklanmoqda...",
                style: AppTextStyles.bodyMediumPrimary
                    .copyWith(color: ColorName.contentMuted),
              ),
            ],
          );
        } else if (mode == LoadStatus.failed) {
          body = Text(
            failedLoadingText ?? "Yuklashda xatolik",
            style: AppTextStyles.bodyMediumPrimary
                .copyWith(color: ColorName.contentMuted),
          );
        } else if (mode == LoadStatus.canLoading) {
          body = Text(
            canLoadingText ?? "Yuklash uchun torting",
            style: AppTextStyles.bodyMediumPrimary
                .copyWith(color: ColorName.contentMuted),
          );
        } else {
          body = Text(
            noDataText ?? "Ma'lumot yuklandi",
            style: AppTextStyles.bodyMediumPrimary
                .copyWith(color: ColorName.contentMuted),
          );
        }
        return SizedBox(
          height: 55.0,
          child: Center(child: body),
        );
      },
    );
  }
}