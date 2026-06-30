import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // 1. شريط التنقل العلوي (مبسط حسب التصميم)
            Container(
              height: 64.h,
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // سهم الرجوع (يمين)
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(99.r),
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        color: AppColors.textMain,
                        size: 26.sp,
                      ),
                    ),
                  ),

                  // كلمة Primo في المنتصف
                  Expanded(
                    child: Center(
                      child: Text(
                        "Primo",
                        style: AppTextStyle.font20.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // مساحة فارغة لمعادلة التوسيط
                  SizedBox(width: 34.w),
                ],
              ),
            ),

            // 2. محتوى الشاشة
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    40.verticalSpace,

                    // صورة / أيقونة القفل
                    Container(
                      width: 120.w,
                      height: 120.w,
                      decoration: BoxDecoration(
                        color: AppColors.greyBackground,
                        borderRadius: BorderRadius.circular(24.r),
                        image: const DecorationImage(
                          image: NetworkImage(
                            "https://lh3.googleusercontent.com/aida-public/AB6AXuD_cz8rBd-jTGpm2NzLJKK5DmPCA1eWKwnMJMsLZ66kGG5-6ycZvfZMf31dKqd1TZvfXntJH77HLBVWYXGYS8rNLkJxuw2ZM1zGsFNDUXFetziBP1TcJSRcaKMnbrVjyve0lfutz5Y4FSyPscio-iwA5JScmBMRfXIUyG2g5fhkBexQ1KsHpzu5t3FMtpLyWtFwJ3B-TYCpk3qgjPEiEciS2HkUL_yMjAvofHNK1dwaC183WSBJ4DW091v6KrsaqXMrvEhCx51AVMwZ",
                          ), // رابط مؤقت للصورة
                          fit: BoxFit.cover,
                        ),
                      ),
                      // في حال لم تحمل الصورة، يمكن وضع أيقونة كبديل:
                      // child: Icon(Icons.lock_reset_rounded, size: 60.sp, color: AppColors.primary),
                    ),
                    32.verticalSpace,

                    // النصوص التوضيحية
                    Text(
                      "نسيت كلمة المرور؟",
                      style: AppTextStyle.font30.copyWith(
                        color: AppColors.textMain,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    12.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        "لا تقلق، أدخل رقم هاتفك المسجل لدينا وسنرسل لك رمزاً لإعادة تعيين كلمة المرور.",
                        style: AppTextStyle.font14.copyWith(
                          color: AppColors.greyMedium3,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    40.verticalSpace,

                    // حقل إدخال رقم الهاتف
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "رقم الهاتف",
                          style: AppTextStyle.font14.copyWith(
                            color: AppColors.textMain,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        8.verticalSpace,
                        // استخدام Directionality للحفاظ على الأيقونة يميناً والنص يساراً
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: TextFormField(
                            keyboardType: TextInputType.phone,
                            textAlign: TextAlign.left, // محاذاة الأرقام لليسار
                            style: AppTextStyle.font16.copyWith(
                              color: AppColors.textMain,
                              letterSpacing: 1.5, // تباعد خفيف للأرقام
                            ),
                            decoration: InputDecoration(
                              hintText: "05X XXX XXXX",
                              hintStyle: AppTextStyle.font14.copyWith(
                                color: AppColors.greyMedium3,
                              ),
                              filled: true,
                              fillColor: AppColors.white,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 16.h,
                              ),

                              // أيقونة الهاتف (على اليمين بسبب الـ RTL)
                              prefixIcon: Icon(
                                Icons.phone_rounded,
                                color: AppColors.greyDark,
                                size: 22.sp,
                              ),

                              // تنسيق الحدود
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.r),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE6BDB8),
                                  width: 1,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.r),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE6BDB8),
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.r),
                                borderSide: BorderSide(
                                  color: AppColors.primary,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    60.verticalSpace, // مساحة إضافية قبل الزر السفلي
                  ],
                ),
              ),
            ),

            // 3. زر الإرسال السفلي
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
                  Navigator.pushNamed(context, Routes.otpVerification);
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
                  ), // تأثير التوهج (Glow)
                ),
                child: Text(
                  "إرسال رمز التحقق",
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
