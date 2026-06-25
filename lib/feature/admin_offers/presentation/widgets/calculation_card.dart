// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class CalculationCard extends StatelessWidget {
  const CalculationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF3C3837), // لون رمادي داكن يميل للبني
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // السعر قبل الخصم
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "السعر قبل الخصم:",
                style: AppTextStyle.font14.copyWith(
                  color: AppColors.white.withOpacity(0.8),
                ),
              ),
              Text(
                "45 ر.س",
                style: AppTextStyle.font16.copyWith(
                  color: AppColors.white.withOpacity(0.6),
                  decoration: TextDecoration.lineThrough, // خط في المنتصف (شطب)
                  decorationColor: AppColors.white.withOpacity(0.6),
                ),
              ),
            ],
          ),
          16.verticalSpace,

          // خط فاصل خفيف
          Divider(color: AppColors.white.withOpacity(0.1), height: 1),
          16.verticalSpace,

          // السعر بعد الخصم
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "السعر بعد الخصم:",
                style: AppTextStyle.font16.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "35 ر.س",
                style: AppTextStyle.font24.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
