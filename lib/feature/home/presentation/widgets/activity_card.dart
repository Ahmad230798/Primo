import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class ActivityCard extends StatelessWidget {
  final String image;
  const ActivityCard({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w),
      child: Container(
        width: 0.8.sw,
        // وحدنا الارتفاع مع القائمة ليصبح 180
        height: 180.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          // 1. الطبقة السفلية: الصورة
          image:  DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.cover, // هام جداً لتعبئة مساحة البطاقة بشكل احترافي
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                AppColors.textMain.withOpacity(0),
                AppColors.textMain.withOpacity(0.8),
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      "عروض الأسبوع",
                      style: AppTextStyle.font12.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  8.verticalSpace,
                  Text(
                    "خصم 20%",
                    style: AppTextStyle.font24.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  2.verticalSpace,
                  Text(
                    "على جميع المنتجات المستوردة",
                    style: AppTextStyle.font16.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
