import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class CategoryGridCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const CategoryGridCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // قص الحواف لتكون دائرية تماماً من جميع الزوايا
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: AppColors.greyBackground,
          // إضافة ظل خفيف جداً لإبراز البطاقة (اختياري)
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // --- 1. صورة القسم (الخلفية) ---
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
            
            // --- 2. التدرج اللوني (Gradient Overlay) ---
            // هذا التدرج يبدأ من أسود شفاف بالأسفل ليتلاشى للأعلى
            // مما يجعل النص الأبيض مقروءاً بوضوح مهما كانت الصورة فاتحة
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 60.h, // ارتفاع التدرج اللوني
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.75), // أسود شفاف بالأسفل
                      Colors.transparent, // شفاف بالأعلى
                    ],
                  ),
                ),
              ),
            ),

            // --- 3. اسم القسم ---
            Positioned(
              bottom: 12.h,
              left: 8.w,
              right: 8.w,
              child: Text(
                title,
                style: AppTextStyle.font16.copyWith(
                  color: AppColors.white, // نص أبيض ليتناسب مع التدرج الداكن
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}