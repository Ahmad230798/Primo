import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/app_button.dart';
import 'package:primo/core/widgets/app_text_form_field.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

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
            Text("الاسم الكامل", style: AppTextStyle.font16),
            8.verticalSpace,
            AppTextFormField(
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
              isFilled: true,
              fillColor: AppColors.background,
              hinttText: 'أدخل رقم هاتفك',
              prefixIcone: Icon(
                Icons.phone_enabled_outlined,
                size: 20,
                color: AppColors.greyMedium2,
              ),
              suffixIcone: Icon(
                Icons.visibility,
                size: 20,
                color: AppColors.greyMedium2,
              ),
            ),
            24.verticalSpace,
            Container(
              padding: EdgeInsets.symmetric(vertical: 13.5.h, horizontal: 30.w),
              width: 1.sw,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  width: 1,
                  style: BorderStyle.solid,
                  color: AppColors.secondaryBorder,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: AppColors.secondaryBorder,
                  ),
                  Expanded(
                    child: Text(
                      "تحديد موقع التوصيل على الخريطة",
                      style: AppTextStyle.font14.copyWith(
                        letterSpacing: 0.28,
                        color: AppColors.greyMedium2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            24.verticalSpace,
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
            Text("تأكيد كلمة المرور", style: AppTextStyle.font16),
            8.verticalSpace,
            AppTextFormField(
              isFilled: true,
              fillColor: AppColors.background,
              hinttText: "ادخل كلمة السر مرة اخرى",
              prefixIcone: Icon(
                Icons.lock_reset_outlined,
                size: 20,
                color: AppColors.greyMedium2,
              ),
              suffixIcone: Icon(
                Icons.visibility,
                size: 20,
                color: AppColors.greyMedium2,
              ),
            ),
            48.verticalSpace,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(value: false, onChanged: (value) {}),
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
            AppButton(text: "إنشاء حساب"),
          ],
        ),
      ),
    );
  }
}
