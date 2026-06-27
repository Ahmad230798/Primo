import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class PasswordInputField extends StatefulWidget {
  final String label;

  const PasswordInputField({super.key, required this.label});

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  // حالة الحقل (مخفي أم ظاهر)
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    // تنسيق الحدود الموحد
    final borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: const BorderSide(color: AppColors.formBorder, width: 1),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // عنوان الحقل (Label)
        Padding(
          padding: EdgeInsets.only(right: 8.w),
          child: Text(
            widget.label,
            style: AppTextStyle.font14.copyWith(
              color: AppColors.textMain,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        8.verticalSpace,

        // حقل الإدخال
        TextFormField(
          obscureText: _isObscured, // التحكم بالإخفاء
          obscuringCharacter: '•', // شكل النقاط
          textDirection: TextDirection
              .ltr, // لجعل النقاط تبدأ من اليسار لليمين كما في التصميم
          textAlign: TextAlign.right, // لكن النص يبدأ من اليمين
          style: AppTextStyle.font16.copyWith(
            color: AppColors.textMain,
            letterSpacing: _isObscured ? 2.0 : 0, // تباعد بين النقاط
          ),
          decoration: InputDecoration(
            hintText: "••••••••",
            hintStyle: AppTextStyle.font14.copyWith(
              color: AppColors.greyMedium3,
              letterSpacing: 2.0,
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

            // الأيقونة اليمنى (أيقونة القفل)
            // ملاحظة: في بيئة الـ RTL، الـ prefixIcon يكون على اليمين!
            prefixIcon: Icon(
              Icons.lock_outline_rounded,
              color: AppColors.greyMedium2,
              size: 22.sp,
            ),

            // الأيقونة اليسرى (زر الإظهار والإخفاء)
            // في بيئة الـ RTL، الـ suffixIcon يكون على اليسار!
            suffixIcon: IconButton(
              splashColor:
                  Colors.transparent, // إلغاء تأثير الضغط الدائري المزعج
              highlightColor: Colors.transparent,
              icon: Icon(
                _isObscured
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
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
