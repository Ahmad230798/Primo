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
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: (isObscureText ?? false) ? 1 : (linesCount ?? 1),
      onChanged: onChanged,
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
  }
}
