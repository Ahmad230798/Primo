// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class EditImageSection extends StatelessWidget {
  const EditImageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: AppColors.greyBackground,
        // يمكنك استبدالها بصورة المنتج الحقيقية (NetworkImage)
        image: const DecorationImage(
          image: AssetImage("assets/images/honey.png"), // رابط مؤقت
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // طبقة داكنة خفيفة جداً لتحسين رؤية الزر
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              color: Colors.black.withOpacity(0.05),
            ),
          ),

          // زر "تغيير الصورة" في الزاوية السفلية اليسرى
          Positioned(
            bottom: 12.h,
            left: 12.w, // لأن التطبيق RTL، اليسار هو نهاية الشاشة
            child: InkWell(
              onTap: () {
                // TODO: فتح استوديو الصور
              },
              borderRadius: BorderRadius.circular(99.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(99.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Text(
                      "تغيير الصورة",
                      style: AppTextStyle.font12.copyWith(
                        color: AppColors.textMain,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    4.horizontalSpace,
                    Icon(
                      Icons.photo_camera_outlined,
                      color: AppColors.textMain,
                      size: 16.sp,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
