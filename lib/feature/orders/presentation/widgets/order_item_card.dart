// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/models/order_model.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/app_cached_network_image.dart';

class OrderItemCard extends StatelessWidget {
  final OrderItemModel item;
  final bool showRating;
  final Function(int rating)? onRate;

  const OrderItemCard({
    super.key,
    required this.item,
    this.showRating = false,
    this.onRate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.formBorder.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: AppColors.formBorder,
              borderRadius: BorderRadius.circular(12.r),
            ),
            clipBehavior: Clip.antiAlias,
            child: item.fullImageUrl != null
                ? AppCachedNetworkImage(
                    imageUrl: item.fullImageUrl!,
                    fit: BoxFit.cover,
                    errorWidget: Icon(
                      Icons.image_not_supported_outlined,
                      color: AppColors.greyMedium2,
                      size: 24.sp,
                    ),
                  )
                : Icon(
                    Icons.shopping_bag_outlined,
                    color: AppColors.greyMedium2,
                    size: 24.sp,
                  ),
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: AppTextStyle.font16.copyWith(
                          fontWeight: FontWeight.w500,
                          height: 20 / 16,
                          color: AppColors.textMain,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    8.horizontalSpace,
                    Text(
                      "${item.price} ل.س",
                      style: AppTextStyle.font14.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textMain,
                      ),
                    ),
                  ],
                ),
                if (item.property != null && item.property!.isNotEmpty) ...[
                  4.verticalSpace,
                  Text(
                    item.property!,
                    style: AppTextStyle.font14.copyWith(
                      color: AppColors.greyMedium2,
                    ),
                  ),
                ],
                12.verticalSpace,
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        "الكمية: ${item.quantity}",
                        style: AppTextStyle.font14.copyWith(
                          fontWeight: FontWeight.w400,
                          color: AppColors.greyMedium2,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (showRating && onRate != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "قيّم المنتج",
                            style: AppTextStyle.font12.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          4.verticalSpace,
                          Row(
                            children: List.generate(
                              5,
                              (index) => GestureDetector(
                                onTap: () => onRate!(index + 1),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 2.w),
                                  child: Icon(
                                    Icons.star_border,
                                    color: AppColors.primary,
                                    size: 20.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
