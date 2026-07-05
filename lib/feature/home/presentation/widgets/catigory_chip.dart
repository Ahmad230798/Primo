// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class CatigoryChip extends StatelessWidget {
  final IconData? iconData;
  final String text;
  final Widget? icon;
  final String? imageUrl;
  final VoidCallback? onTap;

  const CatigoryChip({
    super.key,
    this.iconData,
    required this.text,
    this.icon,
    this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (imageUrl != null && imageUrl!.trim().isNotEmpty) {
      content = ClipOval(
        child: Image.network(
          imageUrl!,
          width: 64.w,
          height: 64.h,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              icon ??
              Icon(iconData ?? Icons.category, color: AppColors.greyMedium2),
        ),
      );
    } else {
      content =
          icon ??
          Icon(iconData ?? Icons.category, color: AppColors.greyMedium2);
    }

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64.w,
            height: 64.h,
            decoration: BoxDecoration(
              color: AppColors.greyBackground,
              shape: BoxShape.circle,
            ),
            child: Center(child: content),
          ),
          8.verticalSpace,
          Text(
            text,
            style: AppTextStyle.font14.copyWith(
              color: AppColors.textMain,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
