import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class DeliveryMethodCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const DeliveryMethodCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.formBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: isSelected ? AppColors.primary : AppColors.greyLight,
                  size: 20.sp,
                ),
                8.horizontalSpace,
                Icon(
                  icon,
                  color: isSelected ? AppColors.primary : AppColors.greyMedium1,
                  size: 28.sp,
                ),
              ],
            ),
            12.verticalSpace,
            Text(
              title,
              style: AppTextStyle.font16.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textMain,
              ),
              textAlign: TextAlign.center,
            ),
            4.verticalSpace,
            Text(
              subtitle,
              style: AppTextStyle.font12.copyWith(
                fontWeight: FontWeight.w400,
                color: AppColors.greyMedium3,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}