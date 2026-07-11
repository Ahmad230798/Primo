// ignore_for_file: unnecessary_underscores, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/models/order_model.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/app_cached_network_image.dart';

class OrderInfo extends StatelessWidget {
  final OrderModel? order;
  const OrderInfo({super.key, this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(width: 1, color: AppColors.formBorder),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, 4),
            color: AppColors.textMain.withOpacity(0.04),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "رقم الطلب",
                style: AppTextStyle.font14.copyWith(
                  color: AppColors.greyMedium1,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 3.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999.r),
                  color: AppColors.formBorder,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      color: AppColors.greyDark,
                      size: 20,
                    ),
                    4.horizontalSpace,
                    Text(
                      order != null && order!.formattedDate.isNotEmpty
                          ? order!.formattedDate
                          : "الآن",
                      style: AppTextStyle.font12.copyWith(
                        color: AppColors.greyDark,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          4.verticalSpace,
          Text(
            order != null ? "#${order!.id}" : "#PRM-84920",
            style: AppTextStyle.font20,
          ),
          24.verticalSpace,
          const Divider(color: AppColors.greyLight),
          24.verticalSpace,
          Row(
            children: [
              Container(
                width: 94.w,
                height: 94.h,
                decoration: BoxDecoration(
                  color: AppColors.formBorder,
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                child:
                    order != null &&
                        order!.items.isNotEmpty &&
                        order!.items.first.fullImageUrl != null
                    ? AppCachedNetworkImage(
                        imageUrl: order!.items.first.fullImageUrl!,
                        fit: BoxFit.cover,
                        errorWidget: const Icon(
                          Icons.shopping_bag_outlined,
                          color: AppColors.greyMedium2,
                        ),
                      )
                    : const Icon(
                        Icons.shopping_bag_outlined,
                        color: AppColors.greyMedium2,
                      ),
              ),
              17.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order != null && order!.items.isNotEmpty
                          ? order!.items.first.name
                          : "طلب منتجات من Primo",
                      style: AppTextStyle.font16.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMain,
                      ),
                    ),
                    4.verticalSpace,
                    Row(
                      children: [
                        Text(
                          order != null
                              ? "${order!.items.length} عنصر • "
                              : "عنصر • ",
                          style: AppTextStyle.font14.copyWith(
                            color: AppColors.greyMedium2,
                          ),
                        ),
                        Text(
                          order != null ? "${order!.totalAmount} ل.س" : "0 ل.س",
                          style: AppTextStyle.font14.copyWith(
                            color: AppColors.greyMedium2,
                          ),
                        ),
                      ],
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
}
