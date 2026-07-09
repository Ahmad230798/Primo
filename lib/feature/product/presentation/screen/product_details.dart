// ignore_for_file: unnecessary_underscores, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/helper/snack_bar_helper.dart';
import 'package:primo/core/models/product_model.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/app_button.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';
import 'package:primo/core/widgets/custom_counter.dart';
import 'package:primo/core/di/service_locator.dart';
import 'package:primo/feature/cart/presentation/cubit/cart_cubit.dart';
import 'package:primo/feature/cart/presentation/cubit/cart_state.dart';
import 'package:primo/feature/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:primo/feature/product/presentation/cubit/product_cubit.dart';
import 'package:primo/feature/product/presentation/cubit/product_state.dart';
import 'package:primo/feature/product/presentation/widgets/description_section.dart';

class ProductDetails extends StatefulWidget {
  final ProductModel? initialProduct;
  const ProductDetails({super.key, this.initialProduct});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int currentQuantity = 1; // المتغير المحلي للعداد

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            ProductModel? product = widget.initialProduct;
            if (state is ProductLoaded) {
              product = state.product;
            }

            if (state is ProductLoading && product == null) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            } else if (state is ProductError && product == null) {
              return Center(child: Text(state.errorMessage));
            }

            final favCubit = context.watch<FavoritesCubit>();
            final isFav = product != null && product.id != null
                ? favCubit.isProductFavorited(
                    product.id!,
                    defaultVal: product.isFavorite,
                  )
                : false;

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomAppBar(
                      title: "Primo",
                      showRightIcon: true,
                      onRightIconTap: () {
                        if (product != null && product.id != null) {
                          favCubit.toggleFavorite(product.id!);
                        }
                      },
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border_outlined,
                        color: AppColors.primary,
                      ),
                    ),
                    Center(
                      child: product?.fullImageUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16.r),
                              child: Image.network(
                                product!.fullImageUrl!,
                                height: 250.h,
                                width: 1.sw,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  height: 250.h,
                                  width: 1.sw,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: AppColors.greyBackground,
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    size: 80,
                                    color: AppColors.greyMedium2,
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              height: 250.h,
                              width: 1.sw,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.greyBackground,
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: const Icon(
                                Icons.image_not_supported,
                                size: 80,
                                color: AppColors.greyMedium2,
                              ),
                            ),
                    ),
                    16.verticalSpace,
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product?.title ?? product?.name ?? "منتج",
                            style: AppTextStyle.font32.copyWith(
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                        5.horizontalSpace,
                        Text(
                          "${product?.displayPrice ?? '0'} ل.س",
                          style: AppTextStyle.font24.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    8.verticalSpace,
                    Row(
                      children: [
                        const Icon(Icons.star_rate, color: AppColors.primary),
                        8.horizontalSpace,
                        Text(
                          "${product?.ratings ?? '5.0'} (${product?.ratingsCount ?? 0} تقييم)",
                          style: AppTextStyle.font14.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.greyMedium1,
                          ),
                        ),
                      ],
                    ),
                    DescriptionSection(description: product?.description),
                    24.verticalSpace,
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          final cubit = context.read<ProductCubit>();
          return Container(
            width: 1.sw,
            padding: EdgeInsets.only(
              left: 24.w,
              right: 24.w,
              top: 16.h,
              bottom: MediaQuery.of(context).padding.bottom > 0
                  ? MediaQuery.of(context).padding.bottom
                  : 16.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomCounter(
                  count: currentQuantity,
                  onIncrement: () {
                    setState(() {
                      currentQuantity++;
                    });
                  },
                  onDecrement: () {
                    if (currentQuantity > 1) {
                      setState(() {
                        currentQuantity--;
                      });
                    }
                  },
                ),
                16.verticalSpace,
                BlocConsumer<CartCubit, CartState>(
                  bloc: getIt<CartCubit>(),
                  listener: (context, cartState) {
                    // عرض رسالة النجاح القادمة من السيرفر
                    if (cartState is CartLoaded &&
                        cartState.actionMessage != null) {
                      context.showSuccess(cartState.actionMessage!);
                    }
                    // عرض رسالة الخطأ
                    else if (cartState is CartError) {
                      context.showError(cartState.errorMessage);
                    }
                  },
                  builder: (context, cartState) {
                    return AppButton(
                      text: "أضف إلى السلة",
                      icon: Icons.shopping_cart,
                      isLoading: cartState is CartLoading,
                      onPressed: () {
                        if (cartState is CartLoading) return;
                        if (cubit.selectedVariant != null &&
                            cubit.selectedVariant!.id != null) {
                          getIt<CartCubit>().addToCart(
                            cubit.selectedVariant!.id!,
                            currentQuantity,
                          );
                          // // تحديث السلة إجبارياً بعد الإضافة
                          // getIt<CartCubit>().getCart(showLoading: true);
                        }
                      },
                    );
                  },
                ),
                24.verticalSpace,
              ],
            ),
          );
        },
      ),
    );
  }
}
