// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/models/order_model.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class OrderHistoryCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onTap;

  const OrderHistoryCard({super.key, required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDelivered =
        order.status.toLowerCase() == 'completed' ||
        order.status.toLowerCase() == 'delivered';

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.formBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  order.isDelivery
                      ? Icons.shopping_bag_outlined
                      : Icons.storefront_outlined,
                  color: AppColors.primary,
                  size: 20.sp,
                ),
              ),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "طلب #${order.id}",
                      style: AppTextStyle.font20.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMain,
                      ),
                    ),
                    4.verticalSpace,
                    Text(
                      order.formattedDate.isNotEmpty
                          ? order.formattedDate
                          : "الآن",
                      style: AppTextStyle.font12.copyWith(
                        color: AppColors.greyMedium3,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "${order.totalAmount} ل.س",
                style: AppTextStyle.font20.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          16.verticalSpace,
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.greyBackground,
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      order.isDelivery
                          ? Icons.local_shipping_outlined
                          : Icons.storefront_outlined,
                      color: AppColors.greyDark,
                      size: 14.sp,
                    ),
                    4.horizontalSpace,
                    Text(
                      order.isDelivery ? "توصيل" : "استلام من المتجر",
                      style: AppTextStyle.font12.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.greyDark,
                      ),
                    ),
                  ],
                ),
              ),
              8.horizontalSpace,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isDelivered
                      ? const Color(0xFFE8F5E9)
                      : const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      isDelivered
                          ? Icons.check_circle_outline
                          : Icons.schedule_rounded,
                      color: isDelivered
                          ? const Color(0xFF2E7D32)
                          : const Color(0xFFE65100),
                      size: 14.sp,
                    ),
                    4.horizontalSpace,
                    Text(
                      order.statusArabic,
                      style: AppTextStyle.font12.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDelivered
                            ? const Color(0xFF2E7D32)
                            : const Color(0xFFE65100),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          16.verticalSpace,
          Divider(color: AppColors.formBorder, thickness: 1, height: 1),
          16.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildOverlappingImages(),
              InkWell(
                onTap: onTap,
                child: Row(
                  children: [
                    Text(
                      "عرض التفاصيل",
                      style: AppTextStyle.font14.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                    4.horizontalSpace,
                    Icon(
                      Icons.arrow_forward,
                      color: AppColors.primary,
                      size: 20.sp,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverlappingImages() {
    double imageSize = 32.w;
    double overlap = 12.w;
    final items = order.items;
    int visibleCount = items.length > 3 ? 3 : items.length;
    int extraCount = items.length > 3 ? items.length - 3 : 0;

    double stackWidth =
        (imageSize * visibleCount) -
        (overlap * (visibleCount - 1 > 0 ? visibleCount - 1 : 0));
    if (extraCount > 0) {
      stackWidth += (imageSize - overlap);
    }

    if (items.isEmpty) {
      return SizedBox(
        width: imageSize,
        height: imageSize,
        child: Icon(Icons.shopping_bag_outlined, color: AppColors.greyMedium2),
      );
    }

    return SizedBox(
      width: stackWidth,
      height: imageSize,
      child: Stack(
        children: [
          for (int i = 0; i < visibleCount; i++)
            Positioned(
              right: i * (imageSize - overlap),
              child: Container(
                width: imageSize,
                height: imageSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.formBorder,
                  border: Border.all(color: AppColors.white, width: 2),
                ),
                clipBehavior: Clip.antiAlias,
                child: items[i].fullImageUrl != null
                    ? Image.network(
                        items[i].fullImageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.shopping_bag_outlined,
                          size: 16.sp,
                          color: AppColors.greyMedium2,
                        ),
                      )
                    : Icon(
                        Icons.shopping_bag_outlined,
                        size: 16.sp,
                        color: AppColors.greyMedium2,
                      ),
              ),
            ),
          if (extraCount > 0)
            Positioned(
              right: visibleCount * (imageSize - overlap),
              child: Container(
                width: imageSize,
                height: imageSize,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 2),
                ),
                child: Center(
                  child: Text(
                    "+$extraCount",
                    style: AppTextStyle.font12.copyWith(
                      color: AppColors.textMain,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
