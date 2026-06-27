import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

import '../widgets/cost_summary_card.dart';
import '../widgets/customer_info_card.dart';
import '../widgets/order_status_tracker.dart';
import '../widgets/ordered_items_list.dart';

class AdminOrderDetailsScreen extends StatelessWidget {
  const AdminOrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // 1. شريط التنقل العلوي (AppBar)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: AppColors.background,
                border: Border(
                  bottom: BorderSide(color: AppColors.formBorder, width: 1),
                ),
              ),
              child: Row(
                children: [
                  // أيقونة الرجوع (RTL)
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(99.r),
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        color: AppColors.primary,
                        size: 24.sp,
                      ),
                    ),
                  ),
                  8.horizontalSpace,
                  Text(
                    "تفاصيل الطلب #8492",
                    style: AppTextStyle.font18.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // 2. محتوى الشاشة
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // بيانات العميل
                    const CustomerInfoCard(),
                    24.verticalSpace,

                    // تحديث حالة الطلب
                    const OrderStatusTracker(),
                    24.verticalSpace,

                    // المنتجات المطلوبة
                    const OrderedItemsList(),
                    24.verticalSpace,

                    // ملخص الدفع (المجموع والإجمالي)
                    const CostSummaryCard(),
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
}
