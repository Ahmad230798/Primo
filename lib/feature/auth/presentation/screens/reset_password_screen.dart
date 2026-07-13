// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import 'package:primo/core/helper/app_validators.dart';
import 'package:primo/core/helper/navigation.dart';
import 'package:primo/core/helper/snack_bar_helper.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/app_button.dart';
import 'package:primo/core/widgets/app_text_form_field.dart';
import 'package:primo/core/widgets/custom_app_bar.dart'; // تأكد من المسار

import 'package:primo/feature/auth/presentation/cubit/reset_password_cubit.dart';
import 'package:primo/feature/auth/presentation/cubit/reset_password_state.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String phoneNumber; // نستقبل رقم الهاتف من شاشة الـ OTP

  const ResetPasswordScreen({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    // ربط رقم الهاتف بالكيوبت بمجرد فتح الشاشة
    final cubit = context.read<ResetPasswordCubit>();
    cubit.phoneNumber = phoneNumber;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
          listenWhen: (previous, current) =>
              current is ResetPasswordSuccess || current is ResetPassowrdError,
          listener: (context, state) {
            if (state is ResetPassowrdError) {
              context.showError(state.error);
            } else if (state is ResetPasswordSuccess) {
              context.showSuccess(
                "تم تغيير كلمة المرور بنجاح، يرجى تسجيل الدخول.",
              );
              // تدمير جميع الشاشات السابقة وتوجيه المستخدم لتسجيل الدخول
              context.pushNamedAndRemoveUntil(Routes.login);
            }
          },
          buildWhen: (previous, current) =>
              current is ResetPasswordLoading ||
              current is ResetPasswordChangeUI ||
              current is ResetPasswordInitial,
          builder: (context, state) {
            return Form(
              key: cubit.formKey,
              child: Column(
                children: [
                  // 1. شريط التنقل العلوي الموحد
                  const CustomAppBar(title: "Primo"),

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

                          // حقل إدخال كلمة المرور
                          Text(
                            "كلمة المرور الجديدة",
                            style: AppTextStyle.font16,
                          ),
                          8.verticalSpace,
                          AppTextFormField(
                            controller: cubit.passwordController,
                            validator: AppValidators.validatePassword,
                            textDirection: TextDirection.ltr,
                            isObscureText: cubit.isPasswordObscure,
                            isFilled: true,
                            fillColor: AppColors.white,
                            hinttText: 'أدخل كلمة المرور الجديدة',
                            prefixIcone: Icon(
                              Icons.lock_outline,
                              size: 20,
                              color: AppColors.greyMedium2,
                            ),
                            suffixIcone: IconButton(
                              icon: Icon(
                                cubit.isPasswordObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                size: 20,
                                color: AppColors.greyMedium2,
                              ),
                              onPressed: cubit.togglePasswordVisibility,
                            ),
                          ),
                          24.verticalSpace,

                          // حقل تأكيد كلمة المرور
                          Text("تأكيد كلمة المرور", style: AppTextStyle.font16),
                          8.verticalSpace,
                          AppTextFormField(
                            controller: cubit.passwordConfirmationController,
                            validator: (value) =>
                                AppValidators.validateConfirmPassword(
                                  value,
                                  cubit
                                      .passwordController
                                      .text, // مقارنة مع الحقل الأول
                                ),
                            textDirection: TextDirection.ltr,
                            isObscureText: cubit.isPasswordConfirmationObscure,
                            isFilled: true,
                            fillColor: AppColors.white,
                            hinttText: 'أعد إدخال كلمة المرور',
                            prefixIcone: Icon(
                              Icons.lock_reset_outlined,
                              size: 20,
                              color: AppColors.greyMedium2,
                            ),
                            suffixIcone: IconButton(
                              icon: Icon(
                                cubit.isPasswordConfirmationObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                size: 20,
                                color: AppColors.greyMedium2,
                              ),
                              onPressed: cubit.toggleConfirmPasswordVisibility,
                            ),
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
                    child: AppButton(
                      text: "حفظ وتسجيل الدخول",
                      isLoading:
                          state
                              is ResetPasswordLoading, // إظهار اللودينج من الكيوبت
                      onPressed: () {
                        // التحقق من صحة المدخلات وتطابق كلمتي المرور قبل الإرسال
                        if (cubit.formKey.currentState!.validate()) {
                          cubit.emitResetPasswordStates();
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
