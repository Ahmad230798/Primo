import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/helper/navigation.dart';
import 'package:primo/core/helper/snack_bar_helper.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/app_button.dart';
import 'package:primo/core/widgets/app_text_form_field.dart';

class LogInForm extends StatelessWidget {
  const LogInForm({super.key});

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("رقم الهاتف أو البريد الإلكتروني", style: AppTextStyle.font16),
            8.verticalSpace,
            AppTextFormField(
              isFilled: true,
              fillColor: AppColors.background,
              hinttText: 'أدخل رقمك أو بريدك',
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
              isFilled: true,
              fillColor: AppColors.background,
              hinttText: 'أدخل كلمة المرور',
              prefixIcone: Icon(
                Icons.lock_outline,
                size: 20,
                color: AppColors.greyMedium2,
              ),
              suffixIcone: Icon(
                Icons.visibility,
                size: 20,
                color: AppColors.greyMedium2,
              ),
            ),
            16.verticalSpace,
            Text(
              "نسيت كلمة المرور؟",
              style: AppTextStyle.font14.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            24.verticalSpace,
            AppButton(
              text: 'تسجيل الدخول',
              onPressed: () {
                context.pushNamedAndRemoveUntil(Routes.home);
                context.showSuccess("Welcome User");
              },
            ),
            40.verticalSpace,
          ],
        ),
      ),
    );
  }
}
