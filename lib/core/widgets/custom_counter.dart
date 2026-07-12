import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class CustomCounter extends StatelessWidget {
  final double? width;
  final double? horizontalPadding;
  final double? verticalPadding;
  final int count;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  const CustomCounter({
    super.key,
    this.width,
    this.horizontalPadding,
    this.verticalPadding,
    this.count = 1,
    this.onIncrement,
    this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 1.sw,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding ?? 24.w,
        vertical: verticalPadding ?? 18.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.formBorder,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.quantityBackground),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onIncrement,
            child: Icon(Icons.add, color: AppColors.primary),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) => ScaleTransition(
              scale: animation,
              child: FadeTransition(opacity: animation, child: child),
            ),
            child: Text(
              "$count",
              key: ValueKey<int>(count),
              style: AppTextStyle.font20,
            ),
          ),
          GestureDetector(
            onTap: onDecrement,
            child: Center(child: Icon(Icons.remove)),
          ),
        ],
      ),
    );
  }
}
