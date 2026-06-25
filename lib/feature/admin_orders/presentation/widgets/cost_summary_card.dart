import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class CostSummaryCard extends StatelessWidget {
  const CostSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.formBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // المجموع الفرعي
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "المجموع الفرعي",
                style: AppTextStyle.font14.copyWith(
                  color: AppColors.greyMedium3,
                ),
              ),
              Text(
                "210.00 ر.س",
                style: AppTextStyle.font14.copyWith(
                  color: AppColors.greyMedium3,
                ),
              ),
            ],
          ),
          12.verticalSpace,
          // رسوم التوصيل
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "رسوم التوصيل",
                style: AppTextStyle.font14.copyWith(
                  color: AppColors.greyMedium3,
                ),
              ),
              Text(
                "15.00 ر.س",
                style: AppTextStyle.font14.copyWith(
                  color: AppColors.greyMedium3,
                ),
              ),
            ],
          ),
          16.verticalSpace,
          Divider(color: AppColors.formBorder, height: 1),
          16.verticalSpace,
          // الإجمالي
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "الإجمالي",
                style: AppTextStyle.font20.copyWith(
                  color: AppColors.textMain,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "225.00 ر.س",
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
