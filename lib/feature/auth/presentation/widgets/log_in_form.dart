import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/helper/app_validators.dart';
import 'package:primo/core/helper/navigation.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/app_button.dart';
import 'package:primo/core/widgets/app_text_form_field.dart';
import 'package:primo/feature/auth/presentation/cubit/login_cubit.dart';
import 'package:primo/feature/auth/presentation/cubit/login_state.dart';

class LogInForm extends StatelessWidget {
  const LogInForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        final cubit = context.read<LoginCubit>();
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
                  Text("رقم الهاتف", style: AppTextStyle.font16),
                  8.verticalSpace,
                  AppTextFormField(
                    controller: cubit.phoneController,
                    validator: AppValidators.validatePhoneNumber,
                    keyboardType: TextInputType.phone,
                    textDirection: TextDirection.ltr,
                    isFilled: true,
                    fillColor: AppColors.background,
                    hinttText: 'أدخل رقمك',
                    prefixIcone: Icon(
                      Icons.person_outline,
                      size: 20,
                      color: AppColors.greyMedium2,
                    ),
                  ),
                  16.verticalSpace,
                  Text("كلمة المرور", style: AppTextStyle.font16),
                  8.verticalSpace,
                  AppTextFormField(
                    controller: cubit.passwordController,
                    validator: AppValidators.validatePassword,
                    textDirection: TextDirection.ltr,
                    isFilled: true,
                    isObscureText: cubit.isPasswordObscure,
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
                        cubit
                            .togglePasswordVisibility(); // استدعاء دالة التغيير
                      },
                    ),
                  ),
                  16.verticalSpace,
                  InkWell(
                    onTap: () {
                      context.pushNamed(Routes.forgotPassword);
                    },
                    child: Text(
                      "نسيت كلمة المرور؟",
                      style: AppTextStyle.font14.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  24.verticalSpace,
                  AppButton(
                    text: 'تسجيل الدخول',
                    isLoading: state is LoginLoading, // إظهار مؤشر التحميل
                    onPressed: () {
                      // التحقق من صحة المدخلات قبل الإرسال للسيرفر
                      if (cubit.formKey.currentState!.validate()) {
                        cubit.emitLoginStates();
                      }
                    },
                  ),
                  40.verticalSpace,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
