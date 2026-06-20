import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class CustomCounter extends StatelessWidget {
  final double? width;
  const CustomCounter({super.key, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
      width: width ?? 1.sw,

      decoration: BoxDecoration(
        color: AppColors.formBorder,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.quantityBackground),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.add),
          Text("1", style: AppTextStyle.font20),
          Center(child: Icon(Icons.remove)),
        ],
      ),
    );
  }
}
