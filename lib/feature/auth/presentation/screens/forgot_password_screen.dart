// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import 'package:primo/core/helper/app_validators.dart';
import 'package:primo/core/helper/navigation.dart';
import 'package:primo/core/helper/snack_bar_helper.dart';
import 'package:primo/core/routing/otp_enum.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/app_button.dart';
import 'package:primo/core/widgets/app_text_form_field.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';

import 'package:primo/feature/auth/presentation/cubit/forgot_password_cubit.dart';
import 'package:primo/feature/auth/presentation/cubit/forgot_password_state.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // جلب الكيوبت المحقون
    final cubit = context.read<ForgotPasswordCubit>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
          listenWhen: (previous, current) =>
              current is ForgotPasswordSuccess ||
              current is ForgotPasswordError,
          listener: (context, state) {
            if (state is ForgotPasswordError) {
              context.showError(state.error);
            } else if (state is ForgotPasswordSuccess) {
              context.showSuccess(
                state.response.message ?? "تم إرسال الكود بنجاح",
              );

              // التوجيه إلى شاشة الـ OTP مع تمرير رقم الهاتف
              context.pushNamed(
                Routes.otpVerification,
                arguments: OtpVerificationArgs(
                  phoneNumber: cubit.phoneController.text,
                  otpType:
                      OtpType.forgotPassword, // تحديد النوع كـ forgotPassword
                ),
              );
            }
          },
          builder: (context, state) {
            return Form(
              key: cubit.formKey, // ربط الفورم بالكيوبت
              child: Column(
                children: [
                  // 1. شريط التنقل العلوي (باستخدام الويدجت العام)
                  const CustomAppBar(title: "Primo"),

                  // 2. محتوى الشاشة
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "رقم الهاتف",
                              style: AppTextStyle.font14.copyWith(
                                color: AppColors.textMain,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          8.verticalSpace,

                          // استخدام الويدجت العام AppTextFormField
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: AppTextFormField(
                              controller: cubit.phoneController,
                              validator: AppValidators.validatePhoneNumber,
                              isFilled: true,
                              fillColor: AppColors.white,
                              hinttText: '05X XXX XXXX',
                              prefixIcone: Icon(
                                Icons.phone_rounded,
                                color: AppColors.greyDark,
                                size: 22.sp,
                              ),
                            ),
                          ),

                          60.verticalSpace,
                        ],
                      ),
                    ),
                  ),

                  // 3. زر الإرسال السفلي (باستخدام AppButton)
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
                    child: AppButton(
                      text: "إرسال رمز التحقق",
                      isLoading:
                          state
                              is ForgotPasswordLoading, // ربط مؤشر التحميل بالحالة
                      onPressed: () {
                        if (cubit.formKey.currentState!.validate()) {
                          cubit
                              .emitForgotPasswordStates(); // إرسال الطلب للسيرفر
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
