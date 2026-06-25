import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class OrderedItemsList extends StatelessWidget {
  const OrderedItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    // بيانات وهمية للبطاقات
    final items = [
      {
        "name": "قهوة إثيوبية مختصة",
        "weight": "250 جرام",
        "qty": "x2",
        "price": "90 ر.س",
        "image":
            "https://lh3.googleusercontent.com/aida-public/AB6AXuDXlikkmx_tAK1Ugh9RNurl-GAbo7UR0-Px8WLc1dyXqXMvpDtGFDNz3joxyrmRXAjcIq8efZYh1gpNHmx0c51MX28tYwE7rRQmVN4UjI-gIfpYUWw9Xr--61bqzZDv0v8UGu9u22kggz4HBUnPF6-YO7Df8Dg1VAqjxKFpWYUUUVvD07IedEQE3bUFTnZAPJjta0X9AWgc8hragEc3KvIvqITHLIWiBBPq9R0Bnk02sRYQYYM_ttdsFZB7XgezNWL-dVoyVJcSNgkY",
      },
      {
        "name": "شوكولاتة داكنة فاخرة",
        "weight": "علبة 12 قطعة",
        "qty": "x1",
        "price": "120 ر.س",
        "image":
            "https://lh3.googleusercontent.com/aida-public/AB6AXuDDnDD_UoqM6Objym8_5O-ZYCzWyMZjoGVXI4epO2Na6fVjTpy8F7l8WxDkG_QzzXbTahLL3hPjcFkVF9iL5S4XwmjDpE8iKqTQbIQ9FlO4jYjjIACP6VEA4Hruy9HXYd4hQppsVMPp7JAdEXKEnQEBEP57I0ZN3VRUrN_HD4VdfFRPWL3aSsN8mrfgFF58NWjuv2DfITNrTtUWc0RU_BLptQVLuQw72NThVNtSu3EPVjT7aeZ_gtRSOJbimMZKGxxDgWBo1OXdxFMz",
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "المنتجات المطلوبة",
              style: AppTextStyle.font18.copyWith(
                color: AppColors.textMain,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.greyBackground,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                "3 عناصر",
                style: AppTextStyle.font12.copyWith(color: AppColors.greyDark),
              ),
            ),
          ],
        ),
        12.verticalSpace,
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (context, index) => 12.verticalSpace,
          itemBuilder: (context, index) {
            final item = items[index];
            return Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.formBorder),
              ),
              child: Row(
                children: [
                  // صورة المنتج
                  Container(
                    width: 72.w,
                    height: 72.w,
                    decoration: BoxDecoration(
                      color: AppColors.greyBackground,
                      borderRadius: BorderRadius.circular(12.r),
                      image: DecorationImage(
                        image: NetworkImage(item["image"]!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  12.horizontalSpace,
                  // تفاصيل المنتج
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item["name"]!,
                          style: AppTextStyle.font14.copyWith(
                            color: AppColors.textMain,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        4.verticalSpace,
                        Text(
                          item["weight"]!,
                          style: AppTextStyle.font12.copyWith(
                            color: AppColors.greyMedium3,
                          ),
                        ),
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
                                item["qty"]!,
                                style: AppTextStyle.font12.copyWith(
                                  color: AppColors.greyDark,
                                ),
                              ),
                            ),
                            Text(
                              item["price"]!,
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
