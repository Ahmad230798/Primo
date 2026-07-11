import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class AppButton extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? backGroundColor;
  final TextStyle? textStyle;
  final List<BoxShadow>? boxShadow;
  final void Function()? onPressed;
  final bool? isLoading;
  final IconData? icon;
  final Color? textcolor;
  final bool? isIconExist;
  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.color,
    this.textStyle,
    this.backGroundColor,
    this.boxShadow,
    this.icon,
    this.textcolor,
    this.isLoading,
    this.isIconExist,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(32)),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backGroundColor ?? AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 15.h),
        ),
        onPressed: (isLoading == true) ? null : onPressed,
        child: isLoading == true
            ? SizedBox(
                width: 24.w,
                height: 24.h,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: textStyle ?? AppTextStyle.font20.copyWith(),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(width: 8.w),
                  isIconExist ?? true
                      ? Icon(
                          icon ?? Icons.arrow_forward,
                          size: 25,
                          color: color ?? Colors.white,
                        )
                      : SizedBox(),
                ],
              ),
      ),
    );
  }
}
