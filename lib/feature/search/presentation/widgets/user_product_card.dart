// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/models/product_model.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/app_cached_network_image.dart';

class UserProductCard extends StatelessWidget {
  final String title;
  final String weight;
  final String price;
  final String imageUrl;
  final bool isFavorite;
  final bool isOutOfStock;
  final ProductModel? product;
  final VoidCallback? onFavoriteTap;

  const UserProductCard({
    super.key,
    required this.title,
    required this.weight,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
    this.isOutOfStock = false,
    this.product,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final opacity = isOutOfStock ? 0.6 : 1.0;
    final isNet = !imageUrl.startsWith('assets/');

    return GestureDetector(
      onTap: () {
        if (product != null) {
          Navigator.pushNamed(
            context,
            Routes.productDetails,
            arguments: product,
          );
        }
      },
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.formBorder, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Opacity(
                    opacity: opacity,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.greyBackground,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Hero(
                        tag: 'product_image_${product?.id ?? title}',
                        child: isNet
                            ? AppCachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.cover,
                                errorWidget: Center(
                                  child: Icon(
                                    Icons.shopping_bag_outlined,
                                    color: AppColors.greyMedium2,
                                    size: 36.sp,
                                  ),
                                ),
                              )
                            : imageUrl.isNotEmpty
                            ? Image.asset(
                                imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Center(
                                  child: Icon(
                                    Icons.shopping_bag_outlined,
                                    color: AppColors.greyMedium2,
                                    size: 36.sp,
                                  ),
                                ),
                              )
                            : Center(
                                child: Icon(
                                  Icons.shopping_bag_outlined,
                                  color: AppColors.greyMedium2,
                                  size: 36.sp,
                                ),
                              ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 4.h,
                    left: 4.w,
                    child: GestureDetector(
                      onTap: onFavoriteTap,
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: EdgeInsets.all(4.w),
                        child: Icon(
                          isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: isFavorite
                              ? AppColors.primary
                              : AppColors.greyDark,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ),

                  if (isOutOfStock)
                    Positioned(
                      top: 4.h,
                      right: 4.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.textMain,
                          borderRadius: BorderRadius.circular(99.r),
                        ),
                        child: Text(
                          "نفد الكمية",
                          style: AppTextStyle.font12.copyWith(
                            color: AppColors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            12.verticalSpace,

            Opacity(
              opacity: opacity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyle.font14.copyWith(
                      color: AppColors.textMain,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  4.verticalSpace,
                  Text(
                    weight,
                    style: AppTextStyle.font12.copyWith(
                      color: AppColors.greyMedium3,
                    ),
                  ),
                ],
              ),
            ),
            12.verticalSpace,

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Opacity(
                    opacity: opacity,
                    child: Text(
                      price,
                      style: AppTextStyle.font16.copyWith(
                        color: isOutOfStock
                            ? AppColors.textMain
                            : AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),

                Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    color: isOutOfStock
                        ? AppColors.formBorder
                        : AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: isOutOfStock
                        ? null
                        : [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                  ),
                  child: Icon(
                    Icons.add_rounded,
                    color: isOutOfStock
                        ? AppColors.greyMedium3
                        : AppColors.white,
                    size: 20.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
