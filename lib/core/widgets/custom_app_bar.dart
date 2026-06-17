// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final Widget? suffixsIcon;
  final void Function()? onTap;
  final void Function()? onBackTap;
  final IconData? icon;
  final bool showRightIcon;

  const CustomAppBar({
    super.key,
    required this.title,
    this.suffixsIcon,
    this.icon,
    this.showRightIcon = true,
    this.onTap,
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(
          style: BorderStyle.solid,
          width: 1,
          strokeAlign: BorderSide.strokeAlignInside,
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 22.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 1. زر الرجوع (اليسار)
            InkWell(
              onTap:
                  onBackTap ??
                  () {
                    Navigator.pop(context);
                  },
              child:
                  suffixsIcon ??
                  Icon(
                    Icons.arrow_back_rounded,
                    color: AppColors.textMain,
                    size: 30,
                  ),
            ),

            // 2. العنوان (في المنتصف)
            Text(
              title,
              style: AppTextStyle.font24.copyWith(color: AppColors.primary),
            ),

            // 3. الأيقونة اليمنى (مدمجة مع الـ InkWell والشرط)
            showRightIcon
                ? Icon(icon ?? Icons.shield_outlined, color: Colors.white)
                : SizedBox(width: 40.w), // صندوق فارغ للحفاظ على توسيط العنوان
          ],
        ),
      ),
    );
  }
}
