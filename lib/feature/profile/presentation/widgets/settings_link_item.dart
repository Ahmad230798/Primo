import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class SettingsLinkItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? trailingText; // النص الجانبي (مثل "العربية")
  final VoidCallback onTap;

  const SettingsLinkItem({
    super.key,
    required this.title,
    required this.icon,
    this.trailingText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: const BoxDecoration(
                    color: AppColors.greyBackground,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: AppColors.greyDark, size: 20.sp),
                ),
                12.horizontalSpace,
                Text(
                  title,
                  style: AppTextStyle.font16.copyWith(
                    color: AppColors.textMain,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                if (trailingText != null) ...[
                  Text(
                    trailingText!,
                    style: AppTextStyle.font14.copyWith(
                      color: AppColors.greyDark,
                    ),
                  ),
                  4.horizontalSpace,
                ],
                // سهم التوجيه لليسار
                Icon(
                  Icons.chevron_left_rounded,
                  color: AppColors.greyDark,
                  size: 24.sp,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
