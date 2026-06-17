import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class CatigoryChip extends StatelessWidget {
  final IconData? iconData;
  final String text;
  final Widget? icon;
  const CatigoryChip({super.key, this.iconData, required this.text, this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64.w,
          height: 64.h,
          decoration: BoxDecoration(
            color: AppColors.greyBackground,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: icon ?? Icon(iconData, color: AppColors.greyMedium2),
          ),
        ),
        8.verticalSpace,
        Text(
          text,
          style: AppTextStyle.font14.copyWith(
            color: AppColors.textMain,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
