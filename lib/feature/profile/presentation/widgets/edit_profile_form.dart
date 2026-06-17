import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/app_button.dart';
import 'package:primo/core/widgets/app_text_form_field.dart';

class EditProfileForm extends StatelessWidget {
  const EditProfileForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      width: 1.sw,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(width: 1, color: AppColors.formBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "المعلومات الشخصية",
            style: AppTextStyle.font20.copyWith(
              letterSpacing: 0,
              color: AppColors.textMain,
            ),
          ),
          16.verticalSpace,
          Text(
            "الاسم الكامل",
            style: AppTextStyle.font14.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.greyMedium2,
            ),
          ),
          8.verticalSpace,
          AppTextFormField(
            hinttText: "أحمد المحمد",

            focusColor: AppColors.formBorder,
            isFilled: true,
            fillColor: AppColors.background,
          ),
          16.verticalSpace,
          Text(
            "رقم الهاتف",
            style: AppTextStyle.font14.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.greyMedium2,
            ),
          ),
          8.verticalSpace,
          AppTextFormField(
            hinttText: "+966 50 123 4567",
            focusColor: AppColors.formBorder,
            isFilled: true,
            fillColor: AppColors.background,
          ),
          16.verticalSpace,
          Text(
            "البريد الإلكتروني",
            style: AppTextStyle.font14.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.greyMedium2,
            ),
          ),
          8.verticalSpace,
          AppTextFormField(
            hinttText: "ahmed@example.com",
            focusColor: AppColors.formBorder,
            isFilled: true,
            fillColor: AppColors.background,
          ),
          16.verticalSpace,
          Divider(height: 1.h, color: AppColors.quantityBackground),
          16.verticalSpace,
          Text(
            "تغيير كلمة المرور",
            style: AppTextStyle.font20.copyWith(
              letterSpacing: 0,
              color: AppColors.textMain,
            ),
          ),
          16.verticalSpace,
          Text(
            "كلمة المرور الحالية",
            style: AppTextStyle.font14.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.greyMedium2,
            ),
          ),
          8.verticalSpace,
          AppTextFormField(
            hinttText: "••••••••",
            focusColor: AppColors.formBorder,
            isFilled: true,
            fillColor: AppColors.background,
          ),
          16.verticalSpace,
          Text(
            "كلمة المرور الجديدة",
            style: AppTextStyle.font14.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.greyMedium2,
            ),
          ),
          8.verticalSpace,
          AppTextFormField(
            hinttText: "••••••••",
            focusColor: AppColors.formBorder,
            isFilled: true,
            fillColor: AppColors.background,
          ),
          16.verticalSpace,
          Text(
            "تأكيد كلمة المرور الجديدة",
            style: AppTextStyle.font14.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.greyMedium2,
            ),
          ),
          8.verticalSpace,
          AppTextFormField(
            hinttText: "••••••••",
            focusColor: AppColors.formBorder,
            isFilled: true,
            fillColor: AppColors.background,
          ),
          32.verticalSpace,
          AppButton(text: "حفظ التغييرات"),
        ],
      ),
    );
  }
}
