// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

import '../widgets/otp_input_row.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              16.verticalSpace,
              // 1. زر الرجوع (دائري مع ظل خفيف) في أعلى اليمين
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(99.r),
                  child: Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColors.textMain,
                      size: 24.sp,
                    ),
                  ),
                ),
              ),

              32.verticalSpace,

              // 2. النصوص (العنوان والوصف)
              Text(
                "أدخل رمز التحقق",
                style: AppTextStyle.font32.copyWith(
                  color: AppColors.textMain,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              16.verticalSpace,
              Text(
                "أرسلنا رمزاً مكوناً من 4 أرقام إلى رقم هاتفك المرجو إدخاله أدناه.",
                style: AppTextStyle.font16.copyWith(
                  color: AppColors.greyDark,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              40.verticalSpace,

              // 3. حقول الـ OTP المخصصة
              const OtpInputRow(),

              // مسافة لدفع العناصر السفلية إلى أسفل الشاشة
              const Spacer(),

              // 4. إعادة الإرسال والزر السفلي
              Column(
                children: [
                  // نص إعادة الإرسال
                  RichText(
                    text: TextSpan(
                      text: "لم تستلم الرمز؟ ",
                      style: AppTextStyle.font14.copyWith(
                        color: AppColors.greyDark,
                      ),
                      children: [
                        TextSpan(
                          text: "إعادة الإرسال بعد 00:59",
                          style: AppTextStyle.font14.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  24.verticalSpace,

                  // زر التحقق
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          Routes.resetPassword,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 0,
                        minimumSize: Size(double.infinity, 56.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: Text(
                        "تحقق",
                        style: AppTextStyle.font20.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  32.verticalSpace, // مسافة أسفل الزر
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
