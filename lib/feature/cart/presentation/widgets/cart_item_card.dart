// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/app_cached_network_image.dart';
import 'package:primo/core/widgets/custom_counter.dart';
import 'package:primo/feature/cart/data/models/cart_item_model.dart';
import 'package:primo/feature/cart/presentation/cubit/cart_cubit.dart';

class CartItemCard extends StatelessWidget {
  final CartItemModel item;

  const CartItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.startToEnd,
      background: Container(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Icon(Icons.delete_outline, color: AppColors.white, size: 30.sp),
      ),
      onDismissed: (direction) {
        context.read<CartCubit>().deleteFromCart(item.id);
      },
      confirmDismiss: (direction) async {
        return true;
      },
      child: Container(
        width: 1.sw,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 94.w,
              height: 94.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.formBorder,
              ),
              clipBehavior: Clip.antiAlias,
              child: item.fullImageUrl != null
                  ? AppCachedNetworkImage(
                      imageUrl: item.fullImageUrl!,
                      fit: BoxFit.cover,
                      errorWidget: Icon(
                        Icons.image_not_supported_outlined,
                        color: AppColors.greyMedium2,
                        size: 30.sp,
                      ),
                    )
                  : Icon(
                      Icons.shopping_bag_outlined,
                      color: AppColors.greyMedium2,
                      size: 30.sp,
                    ),
            ),
            17.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: AppTextStyle.font20.copyWith(
                      color: AppColors.textMain,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (item.variantProperty.trim().isNotEmpty) ...[
                    4.verticalSpace,
                    Text(
                      item.variantProperty,
                      style: AppTextStyle.font12.copyWith(
                        color: AppColors.greyMedium2,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  8.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          "${item.newPrice} ل.س",
                          style: AppTextStyle.font20.copyWith(
                            color: AppColors.textMain,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: CustomCounter(
                          horizontalPadding: 12.w,
                          verticalPadding: 8.h,
                          count: item.quantity,
                          onIncrement: () {
                            context.read<CartCubit>().updateQuantity(
                              item.id,
                              item.quantity + 1,
                            );
                          },
                          onDecrement: () {
                            if (item.quantity > 1) {
                              context.read<CartCubit>().updateQuantity(
                                item.id,
                                item.quantity - 1,
                              );
                            } else {
                              context.read<CartCubit>().deleteFromCart(item.id);
                            }
                          },
                        ),
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
