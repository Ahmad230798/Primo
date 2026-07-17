import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class OrdersTabBar extends StatelessWidget {
  final String activeFilter;
  final Function(String) onFilterChanged;

  const OrdersTabBar({
    super.key,
    required this.activeFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.formBorder, width: 1),
        ),
      ),
      child: Row(
        children: [
          _buildTab(title: "الكل", filterKey: "all"),
          _buildTab(title: "قيد الانتظار", filterKey: "pending"),
          _buildTab(title: "قيد التجهيز", filterKey: "processing"),
          _buildTab(title: "مكتمل", filterKey: "completed"),
          _buildTab(title: "الطلبات الملغية", filterKey: "canceled"),
        ],
      ),
    );
  }

  Widget _buildTab({required String title, required String filterKey}) {
    final isActive = activeFilter == filterKey;
    return Expanded(
      child: InkWell(
        onTap: () => onFilterChanged(filterKey),
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
      ),
    );
  }
}
