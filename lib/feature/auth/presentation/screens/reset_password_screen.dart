// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

import '../widgets/auth_password_field.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // 1. شريط التنقل العلوي (مبسط: سهم رجوع فقط باللون الأحمر)
            Container(
              height: 64.h,
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(99.r),
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        color: AppColors.primary,
                        size: 26.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 2. محتوى الصفحة
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    32.verticalSpace,

                    // العناوين
                    Text(
                      "كلمة مرور جديدة",
                      style: AppTextStyle.font30.copyWith(
                        color: AppColors.textMain,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    12.verticalSpace,
                    Text(
                      "يرجى كتابة كلمة المرور الجديدة وتأكيدها.",
                      style: AppTextStyle.font16.copyWith(
                        color: AppColors.greyDark,
                      ),
                    ),

                    40.verticalSpace,

                    // حقول إدخال كلمات المرور
                    const AuthPasswordField(
                      label: "كلمة المرور الجديدة",
                      hintText: "أدخل كلمة المرور الجديدة",
                    ),
                    24.verticalSpace,
                    const AuthPasswordField(
                      label: "تأكيد كلمة المرور",
                      hintText: "أعد إدخال كلمة المرور",
                    ),

                    100.verticalSpace, // مساحة للنزول وتجنب الزر السفلي
                  ],
                ),
              ),
            ),

            // 3. الزر السفلي الثابت (حفظ وتسجيل الدخول)
            Container(
              padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 32.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.background,
                    AppColors.background.withOpacity(0.9),
                    AppColors.background.withOpacity(0.0),
                  ],
                ),
              ),
              child: ElevatedButton(
                onPressed: () {
                  // TODO: حفظ كلمة المرور وتوجيه المستخدم للرئيسية
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  minimumSize: Size(double.infinity, 56.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  shadowColor: AppColors.primary.withOpacity(
                    0.4,
                  ), // التوهج الأحمر
                ),
                child: Text(
                  "حفظ وتسجيل الدخول",
                  style: AppTextStyle.font18.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
