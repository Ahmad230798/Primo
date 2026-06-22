import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class SuggestionCard extends StatelessWidget {
  final String suggestionText;
  final VoidCallback onProvide;
  final VoidCallback onIgnore;

  const SuggestionCard({
    super.key,
    required this.suggestionText,
    required this.onProvide,
    required this.onIgnore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.formBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                color: AppColors.primary,
                size: 18.sp,
              ),
              4.horizontalSpace,
              Text(
                "فكرة منتج",
                style: AppTextStyle.font12.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          12.verticalSpace,
          Text(
            suggestionText,
            style: AppTextStyle.font14.copyWith(
              color: AppColors.textMain,
              height: 1.5,
            ),
          ),
          16.verticalSpace,
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onProvide,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.secondaryBorder),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                  ),
                  child: Text(
                    "توفير المنتج",
                    style: AppTextStyle.font14.copyWith(
                      color: AppColors.greyMedium2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              12.horizontalSpace,
              Expanded(
                child: TextButton(
                  onPressed: onIgnore,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    "تجاهل",
                    style: AppTextStyle.font14.copyWith(
                      color: AppColors.greyMedium3,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
