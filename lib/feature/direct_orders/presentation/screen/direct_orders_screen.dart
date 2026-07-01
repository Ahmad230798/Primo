import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';

import '../widgets/active_order_card.dart';
import '../widgets/order_filter_tabs.dart';

class DirectOrdersScreen extends StatelessWidget {
  const DirectOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // 1. شريط التنقل العلوي (يتطابق مع الصورة 100%)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: CustomAppBar(
                title: "Primo",
                // 2. عكسنا الأيقونات (suffixsIcon تظهر على اليمين في الـ RTL)
                suffixsIcon: InkWell(
                  onTap: () {
                    // الانتقال لصفحة الإشعارات
                    Navigator.pushNamed(context, Routes.notifications);
                  },
                  borderRadius: BorderRadius.circular(99.r),
                  child: Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Icon(
                      Icons.notifications_none_rounded,
                      color: AppColors.textMain,
                      size: 28.sp,
                    ),
                  ),
                ),
                // (icon تظهر على اليسار)
                icon: Icon(
                  Icons.menu_rounded,
                  color: AppColors.textMain,
                  size: 28.sp,
                ),
                showRightIcon: true,
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    24.verticalSpace,

                    // 2. العناوين المتوسطة
                    Text(
                      "إدارة الطلبات المباشرة",
                      style: AppTextStyle.font30.copyWith(
                        color: AppColors.textMain,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    4.verticalSpace,
                    Text(
                      "متابعة وتحديث حالة الطلبات النشطة",
                      style: AppTextStyle.font14.copyWith(
                        color: AppColors.greyMedium3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    16.verticalSpace,

                    // 3. أزرار (تصفية / تحديث)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildActionChip(Icons.filter_list_rounded, "تصفية"),
                        8.horizontalSpace,
                        _buildActionChip(Icons.sync_rounded, "تحديث"),
                      ],
                    ),
                    32.verticalSpace,

                    // 4. شريط علامات التبويب (Tabs)
                    const OrderFilterTabs(),
                    24.verticalSpace,

                    // 5. قائمة الطلبات (البطاقات)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 1, // بطاقة واحدة للتوضيح كما في الصورة
                        separatorBuilder: (context, index) => 24.verticalSpace,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              // الذهاب لتفاصيل الطلب في الأدمن
                              Navigator.pushNamed(context, Routes.orderDetails);
                            },
                            child: GestureDetector(
                              onTap: () {
                                // الانتقال لتفاصيل الطلب
                                Navigator.pushNamed(
                                  context,
                                  Routes.orderDetails,
                                );
                              },
                              child: const ActiveOrderCard(
                                orderId: "#ORD-8924",
                                timeAgo: "منذ 5 دقائق",
                                price: "245.50",
                                paymentMethod: "دفع إلكتروني",
                                customerName: "خالد عبدالله",
                                customerType: "عميل مميز",
                                distance: "3.2 كم",
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    40.verticalSpace, // مساحة سفلية
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ودجت مساعد لأزرار (تصفية / تحديث) لتطابق التصميم بدقة
  Widget _buildActionChip(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.greyBackground,
        borderRadius: BorderRadius.circular(99.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18.sp, color: AppColors.greyDark),
          4.horizontalSpace,
          Text(
            text,
            style: AppTextStyle.font14.copyWith(
              color: AppColors.greyDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
