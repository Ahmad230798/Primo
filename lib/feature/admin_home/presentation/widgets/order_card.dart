// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class OrderCard extends StatelessWidget {
  final String customerName;
  final String orderId;
  final String itemCount;
  final String price;
  final VoidCallback onAccept;

  const OrderCard({
    super.key,
    required this.customerName,
    required this.orderId,
    required this.itemCount,
    required this.price,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // اليمين: الصورة الشخصية ومعلومات العميل
          Row(
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundColor: AppColors.greyBackground,
                child: Icon(
                  Icons.person_outline,
                  color: AppColors.greyMedium3,
                  size: 24.sp,
                ),
              ),
              12.horizontalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customerName,
                    style: AppTextStyle.font16.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMain,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    "طلب $orderId • $itemCount عناصر",
                    style: AppTextStyle.font12.copyWith(
                      color: AppColors.greyMedium3,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // اليسار: السعر وزر القبول
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "$price ر.س",
                style: AppTextStyle.font18.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              8.verticalSpace,
              InkWell(
                onTap: onAccept,
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(
                        "قبول الطلب",
                        style: AppTextStyle.font12.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                      4.horizontalSpace,
                      Icon(
                        Icons.check_circle_outline_rounded,
                        color: AppColors.white,
                        size: 16.sp,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
