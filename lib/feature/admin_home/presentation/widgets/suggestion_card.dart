// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class SuggestionCard extends StatelessWidget {
  final String suggestionText;
  final String? userName;
  final VoidCallback onProvide;
  final VoidCallback onIgnore;

  const SuggestionCard({
    super.key,
    required this.suggestionText,
    this.userName,
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline_rounded,
                    color: AppColors.primary,
                    size: 18.sp,
                  ),
                  6.horizontalSpace,
                  Text(
                    "مقترح منتج",
                    style: AppTextStyle.font12.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (userName != null && userName!.trim().isNotEmpty)
                Text(
                  userName!,
                  style: AppTextStyle.font12.copyWith(
                    color: AppColors.greyDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          12.verticalSpace,
          Text(
            suggestionText,
            style: AppTextStyle.font14.copyWith(
              color: AppColors.textMain,
              fontWeight: FontWeight.w500,
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
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                  ),
                  child: Text(
                    "توفير المنتج",
                    style: AppTextStyle.font14.copyWith(
                      color: AppColors.primary,
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
                      color: AppColors.greyDark,
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
