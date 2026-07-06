// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

import '../widgets/settings_link_item.dart';
import '../widgets/settings_toggle_item.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("حذف الحساب"),
        content: const Text(
          "هل أنت متأكد من رغبتك في حذف الحساب نهائياً؟ لا يمكن التراجع عن هذا الإجراء.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("إلغاء"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<ProfileCubit>().deleteAccount();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("حذف نهائياً"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is DeleteAccountSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.login,
              (route) => false,
            );
          } else if (state is DeleteAccountError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            // مسافة سفلية كبيرة لعدم تغطية الـ Bottom Nav Bar للعناصر السفلية
            padding: EdgeInsets.only(bottom: 120.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. شريط التنقل العلوي
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: CustomAppBar(
                    title: "Primo",
                    // أيقونة الإشعارات (يسار)
                    icon: Icon(
                      Icons.notifications_none_rounded,
                      color: AppColors.primary,
                      size: 26.sp,
                    ),
                    onRightIconTap: () => Navigator.pushNamed(context, Routes.notifications),
                    // أيقونة الموقع (يمين)
                    suffixsIcon: Icon(
                      Icons.location_on_outlined,
                      color: AppColors.primary,
                      size: 26.sp,
                    ),
                    onBackTap: () => Navigator.pushNamed(context, Routes.addresses),
                    showRightIcon: true,
                  ),
                ),

                32.verticalSpace,

                // 2. العناوين
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "الإعدادات",
                        style: AppTextStyle.font30.copyWith(
                          color: AppColors.textMain,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      4.verticalSpace,
                      Text(
                        "تحكم في تفضيلات حسابك وإشعاراتك",
                        style: AppTextStyle.font16.copyWith(
                          color: AppColors.greyDark,
                        ),
                      ),
                    ],
                  ),
                ),

                40.verticalSpace,

                // 3. قسم الإشعارات
                _buildSectionTitle("الإشعارات"),
                8.verticalSpace,
                _buildSectionCard([
                  SettingsToggleItem(
                    title: "إشعارات العروض",
                    icon: Icons.campaign_rounded,
                    iconColor: AppColors.primary,
                    iconBgColor: const Color(0xFFFFDAD6),
                    initialValue: true,
                    onChanged: (val) {},
                  ),
                  _buildDivider(),
                  SettingsToggleItem(
                    title: "إشعارات حالة الطلب",
                    icon: Icons.local_shipping_rounded,
                    iconColor: AppColors.primary,
                    iconBgColor: const Color(0xFFFFDAD6),
                    initialValue: true,
                    onChanged: (val) {},
                  ),
                ]),
                32.verticalSpace,

                // 4. قسم التفضيلات
                _buildSectionTitle("التفضيلات"),
                8.verticalSpace,
                _buildSectionCard([
                  SettingsLinkItem(
                    title: "لغة التطبيق",
                    icon: Icons.language_rounded,
                    trailingText: "العربية",
                    onTap: () {},
                  ),
                  _buildDivider(),
                  SettingsToggleItem(
                    title: "الوضع الداكن",
                    icon: Icons.dark_mode_outlined,
                    iconColor: AppColors.greyDark,
                    iconBgColor: AppColors.greyBackground,
                    initialValue: false,
                    onChanged: (val) {},
                  ),
                ]),
                32.verticalSpace,

                // 5. قسم الأمان والحساب
                _buildSectionTitle("الأمان والحساب"),
                8.verticalSpace,
                _buildSectionCard([
                  SettingsLinkItem(
                    title: "تغيير كلمة المرور",
                    icon: Icons.lock_outline_rounded,
                    onTap: () => Navigator.pushNamed(
                      context,
                      Routes.changePassword,
                      arguments: context.read<ProfileCubit>(),
                    ),
                  ),
                  _buildDivider(),
                  SettingsLinkItem(
                    title: "حذف الحساب نهائياً",
                    icon: Icons.delete_forever_rounded,
                    titleColor: Colors.red,
                    iconColor: Colors.red,
                    onTap: () => _showDeleteAccountDialog(context),
                  ),
                ]),
                32.verticalSpace,

                // 6. قسم حول التطبيق
                _buildSectionTitle("حول التطبيق"),
                8.verticalSpace,
                _buildSectionCard([
                  SettingsLinkItem(
                    title: "سياسة الخصوصية",
                    icon: Icons.privacy_tip_outlined,
                    onTap: () {},
                  ),
                  _buildDivider(),
                  SettingsLinkItem(
                    title: "شروط الاستخدام",
                    icon: Icons.gavel_rounded,
                    onTap: () {},
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- دوال مساعدة للتنسيق ---

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Text(
        title,
        style: AppTextStyle.font16.copyWith(
          color: AppColors.greyDark,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSectionCard(List<Widget> children) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(color: AppColors.formBorder, height: 1);
  }
}
