// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/app_text_form_field.dart';

import '../widgets/category_image_upload.dart';

class AddCategoryScreen extends StatelessWidget {
  const AddCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // لون الخلفية فاتح كما في الصورة
      body: SafeArea(
        child: Column(
          children: [
            // 1. شريط التنقل العلوي (AppBar)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Row(
                children: [
                  // أيقونة الإغلاق (X) على اليمين (RTL)
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(99.r),
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Icon(
                        Icons.close_rounded,
                        color: AppColors.greyMedium3,
                        size: 24.sp,
                      ),
                    ),
                  ),
                  8.horizontalSpace,
                  // العنوان
                  Text(
                    "إضافة قسم جديد",
                    style: AppTextStyle.font20.copyWith(
                      color: AppColors.primary, // اللون أحمر
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // 2. محتوى الشاشة
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    24.verticalSpace,

                    // قسم رفع الصورة
                    Text(
                      "صورة القسم",
                      style: AppTextStyle.font12.copyWith(
                        color: AppColors.greyDark,
                      ),
                    ),
                    8.verticalSpace,
                    const CategoryImageUpload(),
                    32.verticalSpace,

                    // حقل اسم القسم
                    Text(
                      "اسم القسم",
                      style: AppTextStyle.font12.copyWith(
                        color: AppColors.greyDark,
                      ),
                    ),
                    8.verticalSpace,
                    AppTextFormField(
                      hinttText: "أدخل اسم القسم هنا...",
                      isFilled: true,
                      fillColor: AppColors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: const BorderSide(
                          color: Color(0xFFE6BDB8),
                          width: 1,
                        ), // لون حد فاتح قريب للأحمر
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                    ),

                    // خط فاصل فوق الأزرار
                    40.verticalSpace,
                    Divider(color: AppColors.formBorder, height: 1),
                    24.verticalSpace,

                    // الأزرار السفلية
                    // زر الحفظ
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 0,
                        minimumSize: Size(double.infinity, 56.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        shadowColor: AppColors.primary.withOpacity(
                          0.5,
                        ), // ظل خفيف (Glow)
                      ),
                      child: Text(
                        "حفظ القسم الجديد",
                        style: AppTextStyle.font18.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    16.verticalSpace,

                    // زر الإلغاء
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.greyDark, width: 1.5),
                        minimumSize: Size(double.infinity, 56.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: Text(
                        "إلغاء",
                        style: AppTextStyle.font18.copyWith(
                          color: AppColors.greyDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    40.verticalSpace, // مساحة سفلية
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
