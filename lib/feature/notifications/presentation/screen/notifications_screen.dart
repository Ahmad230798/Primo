import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/widgets/app_empty_state.dart';
import 'package:primo/core/widgets/app_error_widget.dart';
import 'package:primo/core/widgets/app_shimmer_skeletons.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';
import 'package:primo/feature/notifications/presentation/cubit/notificatins_state.dart';

import '../cubit/notifications_cubit.dart';
import '../widgets/notification_card.dart';

class NotificationsScreen extends StatelessWidget {
  final bool isFromBottomNav;
  const NotificationsScreen({super.key, required this.isFromBottomNav});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // 1. شريط التنقل العلوي
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: CustomAppBar(
                title: "الإشعارات",
                suffixsIcon: isFromBottomNav ? SizedBox() : null,
                showRightIcon: false,
                onBackTap: () => Navigator.pop(context),
              ),
            ),
        
            // 2. قائمة الإشعارات الديناميكية المربوطة بالكيوبت
            Expanded(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () async {
                      await context
                          .read<NotificationsCubit>()
                          .getNotifications();
                    },
                    child:
                        BlocBuilder<NotificationsCubit, NotificationsState>(
                          builder: (context, state) {
                            // --- حالة التحميل ---
                            if (state is NotificationsLoading) {
                              return ListView.separated(
                                physics:
                                    const AlwaysScrollableScrollPhysics(),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24.w,
                                  vertical: 24.h,
                                ),
                                itemCount: 6,
                                separatorBuilder: (context, index) =>
                                    16.verticalSpace,
                                itemBuilder: (context, index) =>
                                    const ListTileShimmer(),
                              );
                            }
                            // --- حالة الخطأ ---
                            // --- حالة الخطأ ---
                            else if (state is NotificationsError) {
                              return CustomScrollView(
                                physics:
                                    const AlwaysScrollableScrollPhysics(),
                                slivers: [
                                  SliverFillRemaining(
                                    hasScrollBody: false,
                                    child: AppErrorWidget(
                                      message: state.message,
                                      onRetry: () => context
                                          .read<NotificationsCubit>()
                                          .getNotifications(),
                                    ),
                                  ),
                                ],
                              );
                            }
                            // --- حالة النجاح ---
                            else if (state is NotificationsLoaded) {
                              final notifications = state.notifications;
        
                              if (notifications.isEmpty) {
                                return const AppEmptyState(
                                  icon: Icons.notifications_none_rounded,
                                  message: "لا توجد إشعارات حالياً",
                                );
                              }
        
                              return ListView.separated(
                                physics:
                                    const AlwaysScrollableScrollPhysics(),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24.w,
                                  vertical: 24.h,
                                ),
                                itemCount: notifications.length,
                                separatorBuilder: (context, index) =>
                                    16.verticalSpace,
                                itemBuilder: (context, index) {
                                  return NotificationCard(
                                    notification: notifications[index],
                                  );
                                },
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
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
