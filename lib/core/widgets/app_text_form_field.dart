import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class AppTextFormField extends StatelessWidget {
  final Color? fillColor;
  final Color? focusColor;
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final TextStyle? hintStyle;
  final String hinttText;
  final bool? isObscureText;
  final Widget? suffixIcone;
  final Widget? prefixIcone;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final int? linesCount;
  final bool? isFilled;
  final double? borderWidth;
  final bool? readOnly;
  final bool? enabled;
  final TextDirection? textDirection;
  final TextInputType? keyboardType;
  const AppTextFormField({
    super.key,
    required this.hinttText,
    this.isObscureText,
    this.suffixIcone,
    this.onChanged,
    this.contentPadding,
    this.focusedBorder,
    this.enabledBorder,
    this.hintStyle,
    this.controller,
    this.validator,
    this.linesCount,
    this.fillColor,
    this.focusColor,
    this.isFilled,
    this.prefixIcone,
    this.borderWidth,
    this.readOnly,
    this.enabled,
    this.textDirection,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAlwaysLtr =
        (isObscureText ?? false) ||
        keyboardType == TextInputType.phone ||
        keyboardType == TextInputType.number ||
        keyboardType == TextInputType.emailAddress;

    // 2. تحديد الاتجاه المبدئي بناءً على نوع الكيبورد
    final ValueNotifier<TextDirection> textDirectionNotifier =
        ValueNotifier<TextDirection>(
          isAlwaysLtr ? TextDirection.ltr : TextDirection.rtl,
        );
    return ValueListenableBuilder(
      valueListenable: textDirectionNotifier,
      builder: (context, textDirection, child) {
        return TextFormField(
          textDirection: textDirection,
          keyboardType: keyboardType,
          readOnly: readOnly ?? false,
          enabled: enabled ?? true,
          maxLines: (isObscureText ?? false) ? 1 : (linesCount ?? 1),
          onChanged: (text) {
            if (isAlwaysLtr) return;

            // 4. أما إذا كان نصاً عادياً، نطبق منطق الفحص الديناميكي
            if (text.trim().isEmpty) {
              textDirectionNotifier.value = TextDirection.rtl;
              return;
            }

            // فحص الحرف الأول ديناميكياً
            final isEnglishOrNumeric = RegExp(
              r'^[a-zA-Z0-9٠-٩]',
            ).hasMatch(text.trim());
            final newDirection = isEnglishOrNumeric
                ? TextDirection.ltr
                : TextDirection.rtl;

            // تحديث القيمة فقط إذا تغيرت لتجنب إعادة البناء غير الضرورية
            if (textDirectionNotifier.value != newDirection) {
              textDirectionNotifier.value = newDirection;
            }
          },
          validator: validator,
          controller: controller,
          decoration: InputDecoration(
            filled: isFilled,
            fillColor: fillColor,
            isDense: true,
            contentPadding:
                contentPadding ??
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
            focusedBorder:
                focusedBorder ??
                OutlineInputBorder(
                  borderSide: BorderSide(
                    color: focusColor ?? AppColors.quantityBackground,
                    width: borderWidth ?? 1.3,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                ),
            enabledBorder:
                enabledBorder ??
                OutlineInputBorder(
                  borderSide: BorderSide(
                    color: focusColor ?? AppColors.quantityBackground,
                    width: borderWidth ?? 1.3,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary, width: 1.3),
              borderRadius: BorderRadius.circular(16.r),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary, width: 1.3),
              borderRadius: BorderRadius.circular(16.r),
            ),
            hintStyle:
                hintStyle ??
                AppTextStyle.font16.copyWith(color: AppColors.greyMedium3),
            hintText: hinttText,
            suffixIcon: suffixIcone,
            prefixIcon: prefixIcone,
          ),
          obscureText: isObscureText ?? false,
          style: AppTextStyle.font16.copyWith(color: AppColors.greyMedium3),
        );
      },
    );
  }
}
