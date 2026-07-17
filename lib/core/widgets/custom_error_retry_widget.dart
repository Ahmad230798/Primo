import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/app_button.dart';

class CustomErrorRetryWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final String? title;

  const CustomErrorRetryWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 32.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88.w,
              height: 88.w,
              decoration: BoxDecoration(
                color: AppColors.red.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.wifi_off_rounded,
                  size: 42.sp,
                  color: AppColors.red,
                ),
              ),
            ),
            20.verticalSpace,
            Text(
              title ?? "عذراً، حدث خطأ ما",
              style: AppTextStyle.font18.copyWith(
                color: AppColors.textMain,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            8.verticalSpace,
            Text(
              message.isEmpty
                  ? "تعذر الاتصال بالخادم. يرجى التحقق من اتصالك بالإنترنت وإعادة المحاولة."
                  : message,
              style: AppTextStyle.font14.copyWith(
                color: AppColors.greyMedium2,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              24.verticalSpace,
              SizedBox(
                width: 200.w,
                child: AppButton(
                  text: "إعادة المحاولة",
                  icon: Icons.refresh_rounded,
                  onPressed: onRetry,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
