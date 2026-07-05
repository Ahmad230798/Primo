import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/models/order_model.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class OrderInfoCard extends StatelessWidget {
  final OrderModel order;

  const OrderInfoCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isCompleted = order.status.toLowerCase() == 'completed' ||
        order.status.toLowerCase() == 'delivered';

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.formBorder),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "تاريخ الطلب",
                    style: AppTextStyle.font12.copyWith(
                      color: AppColors.greyMedium3,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    order.formattedDate.isNotEmpty ? order.formattedDate : "الآن",
                    style: AppTextStyle.font14.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textMain,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "حالة الطلب",
                    style: AppTextStyle.font12.copyWith(
                      color: AppColors.greyMedium3,
                    ),
                  ),
                  4.verticalSpace,
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? const Color(0xFFE8F5E9)
                          : const Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Row(
                      children: [
                        Text(
                          order.statusArabic,
                          style: AppTextStyle.font12.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isCompleted
                                ? const Color(0xFF2E7D32)
                                : const Color(0xFFE65100),
                          ),
                        ),
                        4.horizontalSpace,
                        Icon(
                          isCompleted
                              ? Icons.check_circle
                              : Icons.schedule_rounded,
                          color: isCompleted
                              ? const Color(0xFF2E7D32)
                              : const Color(0xFFE65100),
                          size: 14.sp,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          16.verticalSpace,
          Divider(color: AppColors.formBorder, thickness: 1),
          16.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    order.isDelivery
                        ? Icons.local_shipping_outlined
                        : Icons.storefront_outlined,
                    color: AppColors.greyMedium1,
                    size: 20.sp,
                  ),
                  8.horizontalSpace,
                  Text(
                    order.isDelivery ? "توصيل للعنوان" : "استلام من المتجر",
                    style: AppTextStyle.font14.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.greyMedium1,
                    ),
                  ),
                ],
              ),
              if (order.address != null && order.address!.name != null)
                Text(
                  order.address!.name!,
                  style: AppTextStyle.font14.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
