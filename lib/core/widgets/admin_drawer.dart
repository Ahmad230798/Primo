// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/helper/navigation.dart';
import 'package:primo/core/helper/snack_bar_helper.dart';
import 'package:primo/core/network/app_storage.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/app_cached_network_image.dart';
import 'package:primo/feature/profile/presentation/cubit/profile_cubit.dart';
import 'package:primo/feature/profile/presentation/cubit/profile_state.dart';

class AdminDrawer extends StatelessWidget {
  final String currentRoute; // لمعرفة أي صفحة نشطة حالياً لتمييزها

  const AdminDrawer({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    final adminName = AppStorage.getUserName();
    final adminSubtext = AppStorage.getUserPhone();
    final adminAvatar = AppStorage.getUserAvatar();

    return Theme(
      data: Theme.of(
        context,
      ).copyWith(splashColor: AppColors.primary.withValues(alpha: 0.1)),
      child: Drawer(
        backgroundColor: AppColors.white,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- بيانات المدير (Gradient Header) ---
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primary.withValues(alpha: 0.12),
                      Colors.transparent,
                    ],
                  ),
                ),
                padding: EdgeInsets.all(24.w),
                child: Row(
                  children: [
                    if (adminAvatar != null && adminAvatar.trim().isNotEmpty)
                      AppCachedNetworkImage(
                        imageUrl: adminAvatar,
                        width: 60.r,
                        height: 60.r,
                        borderRadius: BorderRadius.circular(30.r),
                      )
                    else
                      CircleAvatar(
                        radius: 30.r,
                        backgroundColor: AppColors.primary,
                        child: Text(
                          adminName.isNotEmpty ? adminName.trim()[0] : "م",
                          style: AppTextStyle.font20.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    12.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            adminName,
                            style: AppTextStyle.font18.copyWith(
                              color: AppColors.textMain,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            adminSubtext,
                            style: AppTextStyle.font14.copyWith(
                              color: AppColors.primary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
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
                      _buildDrawerItem(
                        context,
                        title: "إعدادات المتجر",
                        icon: Icons.storefront_rounded,
                        route: Routes.adminSettings,
                      ),
                    ],
                  ),
                ),
              ),

              // --- زر تسجيل الخروج ---
              Divider(color: AppColors.formBorder, height: 1),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: BlocListener<ProfileCubit, ProfileState>(
                  listener: (context, state) {
                    if (state is LogoutSuccess) {
                      // إغلاق الـ Drawer المفتوح أولاً
                      Navigator.pop(context);

                      // إظهار الرسالة الجميلة
                      context.showSuccess(state.message);

                      // الانتقال للوجن ومسح كل الشاشات السابقة
                      context.pushNamedAndRemoveUntil(Routes.login);
                    } else if (state is ProfileError) {
                      context.showError(state.message);
                    }
                  },
                  child: BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      // التحقق من حالة التحميل (تأكد أن اسم الحالة ProfileLoading يطابق ما لديك)
                      final isLoading = state is LogoutLoading;
                      return ListTile(
                        onTap: isLoading
                            ? null
                            : () async {
                                context.read<ProfileCubit>().logout();
                              },
                        leading: isLoading
                            ? SizedBox(
                                width: 24.sp,
                                height: 24.sp,
                                child: const CircularProgressIndicator(
                                  color: AppColors.primary,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Icon(
                                Icons.logout_rounded,
                                color: AppColors.primary,
                                size: 24.sp,
                              ),
                        // تغيير النص ليعطي تجربة مستخدم أفضل
                        title: Text(
                          isLoading ? "جاري تسجيل الخروج..." : "تسجيل الخروج",
                          style: AppTextStyle.font16.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // --- الإصدار Footer ---
              Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Text(
                    "v 1.0.2",
                    style: AppTextStyle.font12.copyWith(
                      color: AppColors.greyMedium2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ودجت مساعد لبناء عناصر القائمة وتلوين العنصر النشط مع حركة ناعمة
  Widget _buildDrawerItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String route,
  }) {
    final isActive = currentRoute == route;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: ListTile(
          onTap: () {
            Navigator.pop(context);
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }
}
