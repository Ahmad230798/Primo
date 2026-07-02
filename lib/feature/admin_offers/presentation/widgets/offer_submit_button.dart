import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class OfferSubmitButton extends StatelessWidget {
  final VoidCallback onPressed;

  const OfferSubmitButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.95),
        border: Border(
          top: BorderSide(color: AppColors.formBorder.withOpacity(0.5)),
        ),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          elevation: 0,
          minimumSize: Size(double.infinity, 56.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          shadowColor: AppColors.primary.withOpacity(0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "تفعيل العرض",
              style: AppTextStyle.font18.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            8.horizontalSpace,
            Icon(
              Icons.check_circle_outline_rounded,
              color: AppColors.white,
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }
}
