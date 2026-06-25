import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class OrdersTabBar extends StatelessWidget {
  const OrdersTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // تم نقل اللون ليكون داخل الـ BoxDecoration لتجنب خطأ الـ AssertionError
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.formBorder, width: 1),
        ),
      ),
      child: Row(
        children: [
          _buildTab(title: "قيد التجهيز", isActive: true),
          _buildTab(title: "قيد التوصيل / جاهز للاستلام", isActive: false),
          _buildTab(title: "مكتمل", isActive: false),
        ],
      ),
    );
  }

  Widget _buildTab({required String title, required bool isActive}) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? AppColors.primary : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: AppTextStyle.font14.copyWith(
              color: isActive ? AppColors.textMain : AppColors.greyMedium3,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
