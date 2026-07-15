import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/widgets/app_empty_state.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';

class NotificationsHistoryScreen extends StatelessWidget {
  final bool isFromBottomNav;
  const NotificationsHistoryScreen({super.key, required this.isFromBottomNav});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: CustomAppBar(
                suffixsIcon: isFromBottomNav ? SizedBox() : null,
                title: "الإشعارات",
                showRightIcon: false,
              ),
            ),
            const Expanded(
              child: AppEmptyState(
                icon: Icons.notifications_none_rounded,
                message: "لا توجد إشعارات حالياً",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
