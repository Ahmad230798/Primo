import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';

class CustomStatusSwitch extends StatelessWidget {
  final bool isAvailable;

  const CustomStatusSwitch({super.key, required this.isAvailable});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 48.w,
      height: 24.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(99.r),
        color: isAvailable ? AppColors.greyLight : AppColors.primary,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            // اليمين واليسار معكوسين ليطابقوا تصميمك حرفياً
            left: isAvailable ? 4.w : 24.w,
            right: isAvailable ? 24.w : 4.w,
            child: Container(
              width: 16.w,
              height: 16.w,
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
