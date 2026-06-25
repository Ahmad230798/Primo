// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class AdminDrawer extends StatelessWidget {
  final String currentRoute; // لمعرفة أي صفحة نشطة حالياً لتمييزها

  const AdminDrawer({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- بيانات المدير ---
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30.r,
                    backgroundColor: AppColors.greyBackground,
                    backgroundImage: const NetworkImage(
                      "https://lh3.googleusercontent.com/aida-public/AB6AXuBXXnftMUVM8RLpgQ7IhugjdJYj3Wu-mjS5jBYUbyc9NsHLYFl0iCCQf47j7flikfgdMbLmLe8aD3gzFlrK-MiKvLTEG7pbEviejLMy3YzSUEvBf6I_mQ4XUPvULG5wGlvnOgGtPnFXyUl9qv7VxIHeZ995OSMD3qvTWITREsRFXdQJeqi7tDHwP6kThM6JH0O0-P9HdtwcORzvpLk6Qet67GPmdcJWb1txTgbjjjNx9ly7ajJyWVODeyj-0BDdWoQC1Y1BjAJ83C6J",
                    ), // مسار الصورة
                  ),
                  12.horizontalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "أحمد المحمد",
                        style: AppTextStyle.font18.copyWith(
                          color: AppColors.textMain,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "مدير النظام",
                        style: AppTextStyle.font14.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(color: AppColors.formBorder, height: 1),
            16.verticalSpace,

            // --- روابط التنقل ---
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildDrawerItem(
                      context,
                      title: "لوحة التحكم",
                      icon: Icons.dashboard_rounded,
                      route: Routes.adminHome,
                    ),
                    _buildDrawerItem(
                      context,
                      title: "إدارة المخزون",
                      icon: Icons.inventory_2_rounded,
                      route: Routes.adminInventory,
                    ),
                    _buildDrawerItem(
                      context,
                      title: "إدارة الطلبات",
                      icon: Icons.shopping_cart_rounded,
                      route: Routes.adminOrders,
                    ),
                    _buildDrawerItem(
                      context,
                      title: "إدارة الأقسام",
                      icon: Icons.category_rounded,
                      route: Routes.adminCategories,
                    ),
                    _buildDrawerItem(
                      context,
                      title: "العروض والخصومات",
                      icon: Icons.campaign_rounded,
                      route: Routes.adminOffers,
                    ),
                    _buildDrawerItem(
                      context,
                      title: "مقترحات الزبائن",
                      icon: Icons.lightbulb_outline_rounded,
                      route: Routes.adminSuggestions,
                    ),
                  ],
                ),
              ),
            ),

            // --- زر تسجيل الخروج ---
            Divider(color: AppColors.formBorder, height: 1),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: ListTile(
                onTap: () {
                  // TODO: إضافة منطق تسجيل الخروج
                },
                leading: Icon(
                  Icons.logout_rounded,
                  color: AppColors.primary,
                  size: 24.sp,
                ),
                title: Text(
                  "تسجيل الخروج",
                  style: AppTextStyle.font16.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                hoverColor: AppColors.primary.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ودجت مساعد لبناء عناصر القائمة وتلوين العنصر النشط
  Widget _buildDrawerItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String route,
  }) {
    final isActive = currentRoute == route;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: ListTile(
        onTap: () {
          // إغلاق القائمة الجانبية أولاً
          Navigator.pop(context);
          // الانتقال للصفحة المطلوبة إذا لم نكن فيها بالفعل
          if (!isActive) {
            Navigator.pushReplacementNamed(context, route);
          }
        },
        leading: Icon(
          icon,
          color: isActive ? AppColors.white : AppColors.greyDark,
          size: 24.sp,
        ),
        title: Text(
          title,
          style: AppTextStyle.font16.copyWith(
            color: isActive ? AppColors.white : AppColors.textMain,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        tileColor: isActive ? AppColors.primary : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}
