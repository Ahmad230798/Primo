import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/feature/auth/presentation/cubit/otp_cubit.dart';

class OtpInputRow extends StatelessWidget {
  const OtpInputRow({super.key});

  // إنشاء 4 متحكمات وعُقد تركيز (FocusNodes)
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OtpCubit>();
    // استخدمنا Directionality LTR لضمان ترتيب الحقول من اليسار لليمين (1-2-3-4)
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(4, (index) {
          return SizedBox(
            width: 64.w,
            height: 64.w,
            child: TextFormField(
              controller: cubit.controllers[index],
              focusNode: cubit.focusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1, // رقم واحد فقط في كل حقل
              style: AppTextStyle.font32.copyWith(
                color: AppColors.textMain,
                fontWeight: FontWeight.bold,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // السماح بالأرقام فقط
              ],
              decoration: InputDecoration(
                counterText: "", // إخفاء عداد الحروف (0/1)
                filled: true,
                fillColor: AppColors.white,
                contentPadding: EdgeInsets.zero,

                // الحدود في الحالة العادية
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: const BorderSide(
                    color: AppColors.formBorder,
                    width: 1,
                  ),
                ),
                // الحدود عند التركيز (Focus) باللون الأحمر كما في التصميم
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
              onChanged: (value) => cubit.onOtpInputChanged(value, index),
            ),
          );
        }),
      ),
    );
  }
}
