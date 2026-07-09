// ignore_for_file: unnecessary_underscores, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/di/service_locator.dart';
import 'package:primo/core/helper/navigation.dart';
import 'package:primo/core/helper/snack_bar_helper.dart';
import 'package:primo/core/models/product_model.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/feature/cart/presentation/cubit/cart_cubit.dart';

class ProductCard extends StatelessWidget {
  final ProductModel? product;
  const ProductCard({super.key, this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (product != null) {
          context.pushNamed(Routes.productDetails, arguments: product);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: AppColors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child:
                  product?.fullImageUrl != null &&
                      product!.fullImageUrl!.isNotEmpty
                  ? Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.network(
                          product!.fullImageUrl!,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            alignment: Alignment.center,
                            color: AppColors.greyBackground,
                            child: Icon(
                              Icons.shopping_bag_outlined,
                              color: AppColors.greyMedium2,
                              size: 36.sp,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Container(
                        alignment: Alignment.center,
                        color: AppColors.greyBackground,
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          color: AppColors.greyMedium2,
                          size: 36.sp,
                        ),
                      ),
                    ),
            ),
            7.verticalSpace,
            Text(
              product?.category?.name ?? product?.categoryName ?? "عام",
              style: AppTextStyle.font12,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            4.verticalSpace,
            Text(
              product?.title ?? product?.name ?? "منتج",
              style: AppTextStyle.font16,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            8.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: Text(
                    "${product?.displayPrice ?? '0'} ل.س",
                    style: AppTextStyle.font20.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.23),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                        spreadRadius: 0,
                      ),
                    ],
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add),
                    color: AppColors.white,
                    onPressed: () {
                      // 💡 3. الكود الحقيقي للإضافة إلى السلة
                      if (product != null) {
                        final variantId =
                            (product!.variants != null &&
                                product!.variants!.isNotEmpty)
                            ? product!.variants!.first.id
                            : product!.id;

                        if (variantId != null) {
                          // إرسال الطلب للكيوبت ليتخاطب مع السيرفر (الكمية 1)
                          getIt<CartCubit>().addToCart(variantId, 1);
                        } else {
                          context.showError("لا يمكن إضافة هذا المنتج حالياً");
                        }
                      }
                    },
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
