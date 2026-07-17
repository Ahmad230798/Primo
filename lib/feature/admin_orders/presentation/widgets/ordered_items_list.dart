import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/models/order_model.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/app_cached_network_image.dart';

class OrderedItemsList extends StatelessWidget {
  final List<OrderItemModel>? items;
  const OrderedItemsList({super.key, this.items});

  @override
  Widget build(BuildContext context) {
    final list = items ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "المنتجات المطلوبة",
              style: AppTextStyle.font16.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textMain,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.greyBackground,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                "${list.length} منتج",
                style: AppTextStyle.font12.copyWith(
                  color: AppColors.textMain,
                ),
              ),
            ),
          ],
        ),
        16.verticalSpace,
        if (list.isEmpty)
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.formBorder),
            ),
            child: const Center(child: Text("لا توجد منتجات")),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: list.length,
            separatorBuilder: (context, index) => 12.verticalSpace,
            itemBuilder: (context, index) {
              final item = list[index];
              return Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: AppColors.formBorder),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 60.w,
                      height: 60.h,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: AppCachedNetworkImage(
                          imageUrl: item.fullImageUrl ?? "",
                          width: 60.w,
                          height: 60.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: AppTextStyle.font14.copyWith(
                              color: AppColors.textMain,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (item.property != null) ...[
                            4.verticalSpace,
                            Text(
                              item.property!,
                              style: AppTextStyle.font12.copyWith(
                                color: AppColors.greyMedium3,
                              ),
                            ),
                          ],
                          8.verticalSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.greyBackground,
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Text(
                                  "x${item.quantity}",
                                  style: AppTextStyle.font12.copyWith(
                                    color: AppColors.greyDark,
                                  ),
                                ),
                              ),
                              Text(
                                item.formatPrice(item.price),
                                style: AppTextStyle.font16.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}
