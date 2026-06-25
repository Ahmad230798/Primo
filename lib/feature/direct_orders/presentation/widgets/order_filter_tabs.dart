import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class OrderFilterTabs extends StatelessWidget {
  const OrderFilterTabs({super.key});

  @override
  Widget build(BuildContext context) {
    // الترتيب كما في الصورة (اليمين لليسار)
    final tabs = [
      {"title": "جديد (12)", "isActive": true},
      {"title": "قيد التجهيز (5)", "isActive": false},
      {"title": "الطريق (3)", "isActive": false},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        children: tabs.map((tab) {
          final isActive = tab["isActive"] as bool;
          return Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: isActive ? AppColors.greyDark : AppColors.white,
                borderRadius: BorderRadius.circular(99.r),
                border: isActive
                    ? null
                    : Border.all(color: AppColors.formBorder),
              ),
              child: Text(
                tab["title"] as String,
                style: AppTextStyle.font14.copyWith(
                  color: isActive ? AppColors.white : AppColors.greyMedium3,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
