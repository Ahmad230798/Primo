// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';

import '../widgets/password_input_field.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // 1. شريط التنقل العلوي
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: CustomAppBar(
                title: "تغيير كلمة المرور",
                // سهم الرجوع باللون الأحمر كما في التصميم
                suffixsIcon: Icon(
                  Icons.arrow_back,
                  color: AppColors.primary,
                  size: 26.sp,
                ),
                showRightIcon: false, // لا نحتاج أيقونة إضافية على اليسار هنا
                onBackTap: () => Navigator.pop(context),
              ),
            ),

            // 2. محتوى الصفحة
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    32.verticalSpace,

                    // الأيقونة والنص التوضيحي
                    Container(
                      width: 64.w,
                      height: 64.w,
                      decoration: const BoxDecoration(
                        color: AppColors.greyBackground,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.lock_outline_rounded,
                        color: AppColors.greyDark,
                        size: 32.sp,
                      ),
                    ),
                    16.verticalSpace,
                    Text(
                      "يرجى إدخال كلمة المرور الحالية لتتمكن من تعيين\nكلمة مرور جديدة.",
                      style: AppTextStyle.font14.copyWith(
                        color: AppColors.greyMedium3,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    32.verticalSpace,

                    // حقول الإدخال
                    const PasswordInputField(label: "كلمة المرور الحالية"),
                    20.verticalSpace,
                    const PasswordInputField(label: "كلمة المرور الجديدة"),
                    20.verticalSpace,
                    const PasswordInputField(
                      label: "تأكيد كلمة المرور الجديدة",
                    ),

                    40.verticalSpace,

                    // زر التحديث
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          elevation:
                              0, // أوقفنا ظل الزر الافتراضي لنستخدم الظل المخصص أعلاه (Glow)
                          minimumSize: Size(double.infinity, 56.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        child: Text(
                          "تحديث كلمة المرور",
                          style: AppTextStyle.font18.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    40.verticalSpace, // مساحة سفلية إضافية
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
