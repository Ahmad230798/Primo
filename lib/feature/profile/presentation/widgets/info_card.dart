// استبدل ملف info_card.dart بهذا الكود
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class InfoCard extends StatelessWidget {
  final String text;
  final IconData iconData;
  final Color? borderColor;
  final Color? iconContainerColor;
  final Color? textColor;
  final FontWeight? fontWeight;
  final VoidCallback onTap; // إضافة خاصية الضغط

  const InfoCard({
    super.key,
    required this.text,
    required this.iconData,
    required this.onTap, // جعلها مطلوبة
    this.borderColor,
    this.iconContainerColor,
    this.textColor,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // تفعيل الضغط
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        width: 1.sw,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            width: 1.w,
            color: borderColor ?? AppColors.formBorder.withOpacity(0.5),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: iconContainerColor ?? AppColors.background,
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, size: 20, color: AppColors.primary),
            ),
            16.horizontalSpace,
            Text(
              text,
              style: AppTextStyle.font18.copyWith(
                color: textColor ?? AppColors.textMain,
                fontWeight: fontWeight,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16.sp,
              color: AppColors.greyMedium3,
            ), // سهم دلالي للملاحة
          ],
        ),
      ),
    );
  }
}
