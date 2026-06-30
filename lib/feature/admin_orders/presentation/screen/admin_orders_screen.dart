// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/admin_drawer.dart';

// تأكد من مسار استدعاء الـ AdminDrawer حسب مشروعك
import '../widgets/incoming_order_card.dart';
import '../widgets/orders_tab_bar.dart';

class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // ربط القائمة الجانبية وتمرير المسار الحالي لتمييزه باللون
      drawer: const AdminDrawer(currentRoute: Routes.adminOrders),

      body: SafeArea(
        child: Column(
          children: [
            // 1. الهيدر المخصص
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border(
                  bottom: BorderSide(color: AppColors.formBorder, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // شارة الطلبات النشطة (يمين)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(99.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      "12 نشط",
                      style: AppTextStyle.font12.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),

                  // العنوان (في المنتصف)
                  Text(
                    "إدارة الطلبات",
                    style: AppTextStyle.font18.copyWith(
                      color: AppColors.textMain,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // أيقونة القائمة / Drawer (يسار)
                  // استخدمنا Builder لضمان عمل Scaffold.of(context) بنجاح
                  Builder(
                    builder: (innerContext) => InkWell(
                      onTap: () => Scaffold.of(innerContext).openDrawer(),
                      borderRadius: BorderRadius.circular(99.r),
                      child: Padding(
                        padding: EdgeInsets.all(4.w),
                        child: Icon(
                          Icons.menu_rounded,
                          color: AppColors.textMain,
                          size: 28.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 2. شريط التبويبات (Tabs)
            const OrdersTabBar(),

            // 3. قائمة الطلبات
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                children: [
                  // الطلب العادي
                  GestureDetector(
                    onTap: () {
                      // الانتقال لتفاصيل الطلب
                      Navigator.pushNamed(context, Routes.orderDetails);
                    },
                    child: IncomingOrderCard(
                      isDelayed: false,
                      orderId: "طلب #1042",
                      timeText: "15 دقيقة مضت",
                      customerName: "أحمد محمود",
                      customerAvatarLetter: "أ",
                      orderType: "طلب توصيل",
                      totalPrice: "120 ج.م",
                      onStatusUpdate: () {},
                      onActionTap: () {},
                    ),
                  ),
                  16.verticalSpace,
                  // الطلب المتأخر
                  GestureDetector(
                    onTap: () {
                      // الانتقال لتفاصيل الطلب
                      Navigator.pushNamed(context, Routes.orderDetails);
                    },
                    child: IncomingOrderCard(
                      isDelayed: true,
                      orderId: "طلب #1038",
                      timeText: "45 دقيقة مضت",
                      customerName: "سارة محمد",
                      customerAvatarLetter: "س",
                      orderType: "استلام من الفرع",
                      totalPrice: "85 ج.م",
                      onStatusUpdate: () {},
                      onActionTap: () {},
                    ),
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
