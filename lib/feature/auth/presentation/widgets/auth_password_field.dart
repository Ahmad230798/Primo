import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class AuthPasswordField extends StatefulWidget {
  final String label;
  final String hintText;

  const AuthPasswordField({
    super.key,
    required this.label,
    required this.hintText,
  });

  @override
  State<AuthPasswordField> createState() => _AuthPasswordFieldState();
}

class _AuthPasswordFieldState extends State<AuthPasswordField> {
  bool _isObscured = true; // لإخفاء النص افتراضياً

  @override
  Widget build(BuildContext context) {
    // تنسيق الحدود
    final borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: const BorderSide(
        color: Color(0xFFE6BDB8),
        width: 1,
      ), // لون الحد كما في التصميم
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // عنوان الحقل
        Text(
          widget.label,
          style: AppTextStyle.font14.copyWith(
            color: AppColors.textMain,
            fontWeight: FontWeight.w600,
          ),
        ),
        8.verticalSpace,

        // حقل الإدخال
        TextFormField(
          obscureText: _isObscured,
          obscuringCharacter: '•',
          textAlign:
              TextAlign.right, // لضمان بقاء الـ Hint باللغة العربية على اليمين
          style: AppTextStyle.font16.copyWith(
            color: AppColors.textMain,
            letterSpacing: _isObscured ? 2.0 : 0, // تباعد النقاط
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: AppTextStyle.font14.copyWith(
              color: AppColors.greyLight, // لون النص الإرشادي باهت
              letterSpacing: 0, // لا نريد تباعد للنص الإرشادي
            ),
            filled: true,
            fillColor: AppColors.white,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),

            // الحدود
            border: borderStyle,
            enabledBorder: borderStyle,
            focusedBorder: borderStyle.copyWith(
              borderSide: BorderSide(color: AppColors.primary, width: 1.5),
            ),

            // أيقونة القفل (يمين الـ RTL)
            prefixIcon: Icon(
              Icons.lock_outline_rounded,
              color: AppColors.greyMedium2,
              size: 22.sp,
            ),

            // زر إظهار/إخفاء (يسار الـ RTL)
            suffixIcon: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: Icon(
                _isObscured
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.greyMedium2,
                size: 22.sp,
              ),
              onPressed: () {
                setState(() {
                  _isObscured = !_isObscured;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
