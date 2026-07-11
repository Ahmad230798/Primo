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
  final VoidCallback? onReject;

  const OrderCard({
    super.key,
    required this.customerName,
    required this.orderId,
    required this.itemCount,
    required this.price,
    required this.onAccept,
    this.onReject,
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
          Expanded(
            child: Row(
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customerName,
                        style: AppTextStyle.font16.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textMain,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                ),
              ],
            ),
          ),

          // اليسار: السعر وزري القبول والرفض
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "$price ل.س",
                  style: AppTextStyle.font18.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              8.verticalSpace,
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (onReject != null) ...[
                    InkWell(
                      onTap: onReject,
                      borderRadius: BorderRadius.circular(10.r),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.shade700,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Text(
                          "رفض",
                          style: AppTextStyle.font12.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    6.horizontalSpace,
                  ],
                  InkWell(
                    onTap: onAccept,
                    borderRadius: BorderRadius.circular(10.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10.r),
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
                              fontWeight: FontWeight.bold,
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
        ],
      ),
    );
  }
}
