import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';

import '../widgets/admin_stats_section.dart';
import '../widgets/customer_suggestions_section.dart';
import '../widgets/incoming_orders_section.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(
                  title: "Primo",
                  suffixsIcon: Icon(
                    Icons.notifications_none_rounded,
                    color: AppColors.primary,
                    size: 28.sp,
                  ),
                  // أيقونة القائمة على اليمين
                  icon: Icon(
                    Icons.menu_rounded,
                    color: AppColors.greyDark,
                    size: 28.sp,
                  ),
                  showRightIcon: true,
                  onBackTap: () {
                    // TODO: فتح الإشعارات
                  },
                ),
                16.verticalSpace,
                const AdminStatsSection(),
                32.verticalSpace,
                const IncomingOrdersSection(),
                32.verticalSpace,
                const CustomerSuggestionsSection(),
                100.verticalSpace, // مساحة سفلية عشان الـ Bottom Nav Bar لاحقاً
              ],
            ),
          ),
        ),
      ),
    );
  }
}
