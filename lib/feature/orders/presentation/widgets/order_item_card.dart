import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class OrderItemCard extends StatelessWidget {
  final String title;
  final String weight;
  final int quantity;
  final String price;
  final String imagePath;

  const OrderItemCard({
    super.key,
    required this.title,
    required this.weight,
    required this.quantity,
    required this.price,
    required this.imagePath,
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
          // 1. الصورة (يمين)
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: AppColors.greyBackground,
              borderRadius: BorderRadius.circular(12.r),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          12.horizontalSpace,

          // 2. تفاصيل المنتج والتقييم (الوسط)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: AppTextStyle.font16.copyWith(
                        fontWeight: FontWeight.w500,
                        height: 20 / 16,
                        color: AppColors.textMain,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    16.horizontalSpace,
                    Text(
                      "SAR $price",
                      style: AppTextStyle.font14.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textMain,
                      ),
                    ),
                  ],
                ),
                4.verticalSpace,
                Text(
                  weight,
                  style: AppTextStyle.font16.copyWith(
                    color: AppColors.greyMedium2,
                  ),
                ),
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
                        "الكمية: $quantity",
                        style: AppTextStyle.font16.copyWith(
                          fontWeight: FontWeight.w400,
                          color: AppColors.greyMedium2,
                          height: 24 / 16,
                        ),
                      ),
                    ),
                    Spacer(),
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
                            (index) => Icon(
                              Icons.star_border,
                              color: AppColors.greyLight,
                              size: 20.sp,
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

          // 3. السعر والكمية (يسار)
          16.verticalSpace,
        ],
      ),
    );
  }
}
