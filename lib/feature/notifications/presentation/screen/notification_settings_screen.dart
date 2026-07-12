// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';
import 'package:primo/feature/notifications/presentation/cubit/notification_settings_cubit.dart';
import 'package:primo/feature/notifications/presentation/cubit/notification_settings_state.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

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
                title: "إعدادات الإشعارات",
                showRightIcon: false,
                suffixsIcon: Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.textMain,
                  size: 26.sp,
                ),
                onBackTap: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: BlocConsumer<NotificationSettingsCubit, NotificationSettingsState>(
                listener: (context, state) {
                  if (state is NotificationSettingsUpdateSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } else if (state is NotificationSettingsError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  final cubit = context.read<NotificationSettingsCubit>();
                  final settings = cubit.currentSettings;

                  if (state is NotificationSettingsLoading && settings == null) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    );
                  }

                  if (settings == null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "تعذر تحميل إعدادات الإشعارات",
                            style: AppTextStyle.font16.copyWith(color: AppColors.textMain),
                          ),
                          16.verticalSpace,
                          ElevatedButton(
                            onPressed: () => cubit.getSettings(),
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                            child: const Text("إعادة المحاولة", style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    );
                  }

                  final isUpdating = state is NotificationSettingsUpdating;

                  return ListView(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                    children: [
                      if (isUpdating)
                        Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: const LinearProgressIndicator(color: AppColors.primary),
                        ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: AppColors.formBorder),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                             SwitchListTile(
                              value: settings.notificationOffer,
                              onChanged: (val) {
                                cubit.updateSettings(
                                  offerEnabled: val,
                                  orderEnabled: settings.notificationOrder,
                                );
                              },
                              activeColor: AppColors.primary,
                              title: Text(
                                "إشعارات العروض والخصومات",
                                style: AppTextStyle.font16.copyWith(
                                  color: AppColors.textMain,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                "تلقي تنبيهات بأحدث العروض والخصومات الحصرية",
                                style: AppTextStyle.font12.copyWith(color: AppColors.greyMedium3),
                              ),
                              secondary: Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFDAD6),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.campaign_rounded, color: AppColors.primary, size: 24.sp),
                              ),
                            ),
                            Divider(color: AppColors.formBorder, height: 1),
                            SwitchListTile(
                              value: settings.notificationOrder,
                              onChanged: (val) {
                                cubit.updateSettings(
                                  offerEnabled: settings.notificationOffer,
                                  orderEnabled: val,
                                );
                              },
                              activeColor: AppColors.primary,
                              title: Text(
                                "إشعارات حالة الطلبات",
                                style: AppTextStyle.font16.copyWith(
                                  color: AppColors.textMain,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                "تلقي تحديثات فورية حول حالة تجهيز وتوصيل طلباتك",
                                style: AppTextStyle.font12.copyWith(color: AppColors.greyMedium3),
                              ),
                              secondary: Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFDAD6),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.local_shipping_rounded, color: AppColors.primary, size: 24.sp),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
