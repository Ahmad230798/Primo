// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

import 'package:primo/core/widgets/app_cached_network_image.dart';

import 'custom_status_switch.dart';

class InventoryProductCard extends StatelessWidget {
  final String category;
  final String name;
  final String sku;
  final String price;
  final int quantity;
  final bool isAvailable;
  final String imagePath;
  final bool isDollar;
  final VoidCallback? onToggle;
  final VoidCallback? onTap;

  const InventoryProductCard({
    super.key,
    required this.category,
    required this.name,
    required this.sku,
    required this.price,
    required this.quantity,
    required this.isAvailable,
    required this.imagePath,
    this.isDollar = false,
    this.onToggle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
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
                      // صورة المنتج مع شارة الدولار
                      SizedBox(
                        width: 80.w,
                        height: 80.w,
                        child: Stack(
                          children: [
                            Opacity(
                              opacity: isAvailable ? 1.0 : 0.5,
                              child: AppCachedNetworkImage(
                                imageUrl: imagePath,
                                width: 80.w,
                                height: 80.w,
                                fit: BoxFit.cover,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            if (isDollar)
                              Positioned(
                                top: 4.w,
                                right: 4.w,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 5.w,
                                    vertical: 2.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2E7D32), // Dark green
                                    borderRadius: BorderRadius.circular(4.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 4,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.attach_money_rounded,
                                        color: Colors.white,
                                        size: 11.sp,
                                      ),
                                      Text(
                                        "USD",
                                        style: AppTextStyle.font10.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
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
                                Flexible(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Row(
                                      children: [
                                        Text(
                                          isDollar ? "\$ $price" : "$price ل.س",
                                          style: AppTextStyle.font20.copyWith(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
                          CustomStatusSwitch(
                            isAvailable: isAvailable,
                            onChanged: (_) => onToggle?.call(),
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
      ),
    ),
    );
  }
}
