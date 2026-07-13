import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import 'package:primo/core/helper/app_validators.dart';
import 'package:primo/core/helper/snack_bar_helper.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/app_button.dart';
import 'package:primo/core/widgets/app_text_form_field.dart';
import 'package:primo/feature/auth/presentation/cubit/register_cubit.dart';
import 'package:primo/feature/auth/presentation/cubit/register_state.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    // السحر هنا: هذا الـ Builder سيستمع لأي تغيير في الـ Cubit (مثل زر العين) ويعيد رسم الفورم
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        // جلب الـ Cubit من الـ Context
        final cubit = context.read<RegisterCubit>();

        return Container(
          width: 1.sw,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              width: 1,
              style: BorderStyle.solid,
              color: AppColors.formBorder,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Form(
              key: cubit.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("الاسم الكامل", style: AppTextStyle.font16),
                  8.verticalSpace,
                  AppTextFormField(
                    controller: cubit.nameController,
                    validator: AppValidators.validateFullName,
                    isFilled: true,
                    fillColor: AppColors.background,
                    hinttText: 'أدخل اسمك الكامل',
                    prefixIcone: Icon(
                      Icons.person_outline,
                      size: 20,
                      color: AppColors.greyMedium2,
                    ),
                  ),
                  16.verticalSpace,
                  Text("رقم الهاتف", style: AppTextStyle.font16),
                  8.verticalSpace,
                  AppTextFormField(
                    controller: cubit.phoneController,
                    validator: AppValidators.validatePhoneNumber,
                    keyboardType: TextInputType.phone,
                    textDirection: TextDirection.ltr,
                    isFilled: true,
                    fillColor: AppColors.background,
                    hinttText: 'أدخل رقم هاتفك',
                    prefixIcone: Icon(
                      Icons.phone_enabled_outlined,
                      size: 20,
                      color: AppColors.greyMedium2,
                    ),
                  ),

                  24.verticalSpace,
                  Text("كلمة المرور", style: AppTextStyle.font16),
                  8.verticalSpace,
                  AppTextFormField(
                    controller: cubit.passwordController,
                    validator: AppValidators.validatePassword,
                    textDirection: TextDirection.ltr,
                    isObscureText: cubit.isPasswordObscure,
                    isFilled: true,
                    fillColor: AppColors.background,
                    hinttText: 'أدخل كلمة المرور',
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
                      onPressed: () {
                        cubit.togglePasswordVisibility();
                      },
                    ),
                  ),
                  16.verticalSpace,
                  Text("تأكيد كلمة المرور", style: AppTextStyle.font16),
                  8.verticalSpace,
                  AppTextFormField(
                    controller: cubit.passwordConfirmationController,
                    validator: (value) => AppValidators.validateConfirmPassword(
                      value,
                      cubit.passwordController.text,
                    ),
                    textDirection: TextDirection.ltr,
                    isObscureText: cubit.isConfirmPasswordObscure,
                    isFilled: true,
                    fillColor: AppColors.background,
                    hinttText: "ادخل كلمة السر مرة اخرى",
                    prefixIcone: Icon(
                      Icons.lock_reset_outlined,
                      size: 20,
                      color: AppColors.greyMedium2,
                    ),
                    suffixIcone: IconButton(
                      icon: Icon(
                        cubit.isConfirmPasswordObscure
                            ? Icons.visibility
                            : Icons.visibility_off,
                        size: 20,
                        color: AppColors.greyMedium2,
                      ),
                      onPressed: () {
                        cubit.toggleConfirmPasswordVisibility();
                      },
                    ),
                  ),
                  48.verticalSpace,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // تم تفعيل الـ Checkbox وربطه بالـ Cubit
                      Checkbox(
                        value: cubit.isTermsAccepted,
                        activeColor: AppColors.primary,
                        onChanged: (value) {
                          cubit.toggleTermsAcceptance(value);
                        },
                      ),
                      Expanded(
                        child: Text.rich(
                          maxLines: 2,
                          textAlign: TextAlign.start,
                          TextSpan(
                            text: "بالتسجيل فانك توافق على ",
                            style: AppTextStyle.font12.copyWith(
                              color: AppColors.greyMedium1,
                            ),
                            children: [
                              TextSpan(
                                text: "الشروط والأحكام",
                                style: AppTextStyle.font12.copyWith(
                                  color: AppColors.primary,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              TextSpan(
                                text: " و ",
                                style: AppTextStyle.font12.copyWith(
                                  color: AppColors.greyMedium1,
                                ),
                              ),
                              TextSpan(
                                text: "سياسة الخصوصية",
                                style: AppTextStyle.font12.copyWith(
                                  color: AppColors.primary,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              TextSpan(
                                text: " الخاصة بنا.",
                                style: AppTextStyle.font12.copyWith(
                                  color: AppColors.greyMedium1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  16.verticalSpace,

                  // إظهار مؤشر التحميل أو الزر بناءً على حالة الـ Cubit
                  AppButton(
                    isLoading: state is RegisterLoading,
                    text: "إنشاء حساب",
                    onPressed: () {
                      // 1. التحقق من الشروط
                      if (!cubit.isTermsAccepted) {
                        context.showError(
                          "يجب الموافقة على الشروط والأحكام أولاً",
                        );
                        return;
                      }
                      // 2. التحقق من المدخلات ثم الإرسال
                      if (cubit.formKey.currentState!.validate()) {
                        cubit.emitRegisterStates();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
