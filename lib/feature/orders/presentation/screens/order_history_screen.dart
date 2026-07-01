import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';
import 'package:primo/feature/orders/presentation/widgets/order_history_card.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // بيانات وهمية تحاكي الـ API
    final List<Map<String, dynamic>> orders = [
      {
        "orderNumber": "طلب #PRM-8492",
        "date": "15 أكتوبر 2023 • 02:30 م",
        "price": "245.50 ر.س",
        "isDelivery": true,
        "status": "تم التسليم",
        "isDelivered": true,
        "images": [
          "assets/images/coffe.png", // استبدلها بمساراتك الحقيقية
          "assets/images/coffe.png",
        ],
        "extraCount": 2,
      },
      {
        "orderNumber": "طلب #PRM-8321",
        "date": "10 أكتوبر 2023 • 10:15 ص",
        "price": "120.00 ر.س",
        "isDelivery": false,
        "status": "تم التسليم",
        "isDelivered": true,
        "images": ["assets/images/coffe.png"],
        "extraCount": 1,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // --- 1. AppBar المطابق للتصميم ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: CustomAppBar(
                title: "Primo",
                showRightIcon: true,
                icon: Icon(
                  Icons.notifications_none,
                  color: AppColors.textMain,
                  size: 26.sp,
                ),
              ),
            ),

            // --- 2. ترويسة الصفحة (العنوان وزر التصفية) ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "سجل الطلبات",
                    style: AppTextStyle.font24.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.textMain,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // TODO: إظهار نافذة فلترة الطلبات (حسب التاريخ أو الحالة)
                    },
                    child: Row(
                      children: [
                        Text(
                          "تصفية",
                          style: AppTextStyle.font14.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.greyMedium1,
                          ),
                        ),
                        4.horizontalSpace,
                        Icon(
                          Icons.filter_list,
                          color: AppColors.greyMedium1,
                          size: 20.sp,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // --- 3. قائمة الطلبات ---
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return OrderHistoryCard(
                    orderNumber: order["orderNumber"],
                    date: order["date"],
                    price: order["price"],
                    isDelivery: order["isDelivery"],
                    status: order["status"],
                    isDelivered: order["isDelivered"],
                    productImages: order["images"],
                    extraProductsCount: order["extraCount"],
                    onTap: () {
                      Navigator.pushNamed(context, Routes.orderDetailsScreen);
                    },
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
