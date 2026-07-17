import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/app_button.dart';

class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String? message;
  final String? title;
  final String? subtitle;
  final VoidCallback? onRetry;

  const AppEmptyState({
    super.key,
    this.icon = Icons.inbox_outlined,
    this.message,
    this.title,
    this.subtitle,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final displayTitle = title ?? message ?? "لا توجد بيانات";
    final displaySubtitle = subtitle ??
        (message != null && title == null
            ? null
            : "كل شيء هادئ هنا في الوقت الحالي");

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 72.sp,
                color: AppColors.primary.withValues(alpha: 0.65),
              ),
            ),
            16.verticalSpace,
            Text(
              displayTitle,
              style: AppTextStyle.font18.copyWith(
                color: AppColors.textMain,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            if (displaySubtitle != null) ...[
              8.verticalSpace,
              Text(
                displaySubtitle,
                style: AppTextStyle.font14.copyWith(
                  color: AppColors.greyMedium3,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              20.verticalSpace,
              SizedBox(
                width: 180.w,
                child: AppButton(
                  text: "تحديث البيانات",
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
