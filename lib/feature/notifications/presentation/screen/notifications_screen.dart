import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';

import '../widgets/notification_card.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

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
                // سهم الرجوع في اليمين (RTL)
                suffixsIcon: Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.textMain,
                  size: 26.sp,
                ),
                showRightIcon: false, // لا يوجد أيقونة على اليسار
                onBackTap: () => Navigator.pop(context),
              ),
            ),

            // 2. قائمة الإشعارات
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                children: [
                  // إشعار غير مقروء
                  NotificationCard(
                    title: "طلبك في الطريق!",
                    description:
                        "مندوب Primo في طريقه إليك، استعد لاستلام طلبك.",
                    time: "منذ 10 دقائق",
                    icon: Icons.notifications_active_rounded,
                    isUnread: true,
                  ),
                  16.verticalSpace,

                  // إشعار مقروء (عرض)
                  NotificationCard(
                    title: "خصم 20% على القهوة الفاخرة",
                    description:
                        "تسوق الآن واستفد من عروض Primo المميزة لنهاية الأسبوع.",
                    time: "أمس",
                    icon: Icons.local_offer_outlined,
                    isUnread: false,
                  ),
                  16.verticalSpace,

                  // إشعار مقروء (طلب)
                  NotificationCard(
                    title: "تم تأكيد طلبك #8492",
                    description:
                        "شكراً لتسوقك مع Primo، تم البدء في تجهيز طلبك.",
                    time: "منذ يومين",
                    icon: Icons.inventory_2_outlined,
                    isUnread: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
