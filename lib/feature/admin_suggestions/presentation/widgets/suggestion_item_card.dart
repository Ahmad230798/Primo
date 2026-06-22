// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class SuggestionItemCard extends StatelessWidget {
  final String customerName;
  final String customerType;
  final String avatarLetter;
  final String date;
  final String suggestionTitle;
  final String suggestionText;
  final VoidCallback onAccept;
  final VoidCallback onIgnore;

  const SuggestionItemCard({
    super.key,
    required this.customerName,
    required this.customerType,
    required this.avatarLetter,
    required this.date,
    required this.suggestionTitle,
    required this.suggestionText,
    required this.onAccept,
    required this.onIgnore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24.r), // زوايا دائرية كبيرة
        border: Border.all(color: AppColors.formBorder, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- الجزء العلوي: بيانات الزبون والتاريخ ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // اليمين: الصورة الشخصية والاسم
              Row(
                children: [
                  CircleAvatar(
                    radius: 22.r,
                    backgroundColor: AppColors.greyBackground,
                    child: Text(
                      avatarLetter,
                      style: AppTextStyle.font16.copyWith(
                        color: AppColors.textMain,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  12.horizontalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customerName,
                        style: AppTextStyle.font14.copyWith(
                          color: AppColors.textMain,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      2.verticalSpace,
                      Text(
                        customerType,
                        style: AppTextStyle.font12.copyWith(
                          color: AppColors.greyMedium3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // اليسار: التاريخ
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.greyBackground,
                  borderRadius: BorderRadius.circular(99.r),
                ),
                child: Text(
                  date,
                  style: AppTextStyle.font12.copyWith(
                    color: AppColors.greyDark,
                  ),
                ),
              ),
            ],
          ),
          24.verticalSpace,

          // --- الجزء الأوسط: محتوى المقترح ---
          Text(
            suggestionTitle,
            style: AppTextStyle.font16.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          8.verticalSpace,
          Text(
            suggestionText,
            style: AppTextStyle.font14.copyWith(
              color: AppColors.greyDark,
              height: 1.6, // تباعد الأسطر لسهولة القراءة
            ),
          ),
          24.verticalSpace,

          // --- الجزء السفلي: الأزرار (تجاهل / تم التوفير) ---
          Row(
            children: [
              // زر تجاهل
              Expanded(
                child: OutlinedButton(
                  onPressed: onIgnore,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.secondaryBorder),
                    minimumSize: Size(0, 52.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "تجاهل",
                        style: AppTextStyle.font14.copyWith(
                          color: AppColors.textMain,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      8.horizontalSpace,
                      Icon(
                        Icons.close_rounded,
                        color: AppColors.textMain,
                        size: 20.sp,
                      ),
                    ],
                  ),
                ),
              ),
              16.horizontalSpace,
              // زر تم التوفير
              Expanded(
                child: ElevatedButton(
                  onPressed: onAccept,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    minimumSize: Size(0, 52.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    shadowColor: AppColors.primary.withOpacity(
                      0.5,
                    ), // ظل خفيف للزر
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "تم التوفير",
                        style: AppTextStyle.font14.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      8.horizontalSpace,
                      Icon(
                        Icons.check_circle_outline_rounded,
                        color: AppColors.white,
                        size: 20.sp,
                      ),
                    ],
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
