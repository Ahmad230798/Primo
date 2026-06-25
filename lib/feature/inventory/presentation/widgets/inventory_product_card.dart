// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

import 'custom_status_switch.dart';

class InventoryProductCard extends StatelessWidget {
  final String category;
  final String name;
  final String sku;
  final String price;
  final int quantity;
  final bool isAvailable;
  final String imagePath;

  const InventoryProductCard({
    super.key,
    required this.category,
    required this.name,
    required this.sku,
    required this.price,
    required this.quantity,
    required this.isAvailable,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.formBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Stack(
          children: [
            // الخط الأحمر العلوي في حال كان غير متوفر
            if (!isAvailable)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(height: 4.h, color: AppColors.primary),
              ),

            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  // الجزء العلوي: الصورة والتفاصيل
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // صورة المنتج
                      Container(
                        width: 80.w,
                        height: 80.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: AppColors.greyBackground,
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/images/product_image.png',
                            ),
                            fit: BoxFit.cover,
                            // تطبيق تأثير بهتان خفيف للصورة إذا كان غير متوفر
                            colorFilter: isAvailable
                                ? null
                                : ColorFilter.mode(
                                    Colors.black.withOpacity(0.2),
                                    BlendMode.dstATop,
                                  ),
                          ),
                        ),
                      ),
                      16.horizontalSpace,
                      // تفاصيل المنتج
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Text(
                                category,
                                style: AppTextStyle.font12.copyWith(
                                  color: AppColors.greyMedium3,
                                ),
                              ),
                            ),
                            8.verticalSpace,
                            Text(
                              name,
                              style: AppTextStyle.font16.copyWith(
                                color: AppColors.textMain,
                                fontWeight: FontWeight.w600,
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            4.verticalSpace,
                            Text(
                              sku,
                              style: AppTextStyle.font12.copyWith(
                                color: AppColors.greyMedium3,
                              ),
                            ),
                            12.verticalSpace,
                            // السعر والكمية
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      price,
                                      style: AppTextStyle.font20.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    4.horizontalSpace,
                                    Text(
                                      "ر.س",
                                      style: AppTextStyle.font12.copyWith(
                                        color: AppColors.greyMedium3,
                                      ),
                                    ),
                                  ],
                                ),
                                // شريحة الكمية (تتغير بناءً على التوفر)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isAvailable
                                        ? AppColors.white
                                        : const Color(0xFFFFDAD6),
                                    border: isAvailable
                                        ? Border.all(
                                            color: AppColors.formBorder,
                                          )
                                        : null,
                                    borderRadius: BorderRadius.circular(99.r),
                                  ),
                                  child: Text(
                                    "الكمية: $quantity",
                                    style: AppTextStyle.font12.copyWith(
                                      color: isAvailable
                                          ? AppColors.greyDark
                                          : AppColors.primary,
                                      fontWeight: isAvailable
                                          ? FontWeight.normal
                                          : FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  16.verticalSpace,
                  Divider(color: AppColors.formBorder, height: 1),
                  16.verticalSpace,
                  // الجزء السفلي: حالة الظهور
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "حالة الظهور في التطبيق",
                        style: AppTextStyle.font14.copyWith(
                          color: AppColors.greyMedium3,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            isAvailable ? "متوفر" : "غير متوفر",
                            style: AppTextStyle.font14.copyWith(
                              color: isAvailable
                                  ? AppColors.textMain
                                  : AppColors.primary,
                              fontWeight: isAvailable
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                            ),
                          ),
                          12.horizontalSpace,
                          CustomStatusSwitch(isAvailable: isAvailable),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
