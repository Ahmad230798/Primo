import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class SuggestionsFilterTabs extends StatelessWidget {
  final String currentTab;
  final Function(String) onTabChanged;

  const SuggestionsFilterTabs({
    super.key,
    required this.currentTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = [
      {"title": "الجديدة", "key": "new"},
      {"title": "المقبولة", "key": "approved"},
      {"title": "المرفوضة", "key": "rejected"},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        children: tabs.map((tab) {
          final tabKey = tab["key"] as String;
          final isActive = currentTab == tabKey;
          return Padding(
            padding: EdgeInsets.only(left: 12.w),
            child: InkWell(
              onTap: () => onTabChanged(tabKey),
              borderRadius: BorderRadius.circular(99.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.textMain : AppColors.greyBackground,
                  borderRadius: BorderRadius.circular(99.r),
                ),
                child: Text(
                  tab["title"] as String,
                  style: AppTextStyle.font14.copyWith(
                    color: isActive ? AppColors.white : AppColors.greyMedium2,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
