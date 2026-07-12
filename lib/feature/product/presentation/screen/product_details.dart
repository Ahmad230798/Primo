// ignore_for_file: unnecessary_underscores, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/helper/snack_bar_helper.dart';
import 'package:primo/core/models/offer_model.dart';
import 'package:primo/core/models/product_model.dart';
import 'package:primo/core/models/variant_model.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/app_cached_network_image.dart';
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
  final OfferModel? initialOffer;
  const ProductDetails({super.key, this.initialProduct, this.initialOffer});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int currentQuantity = 1;
  VariantModel? selectedVariant;

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

            final cubit = context.read<ProductCubit>();
            VariantModel? activeVariant = selectedVariant ??
                cubit.selectedVariant ??
                (product?.variants != null && product!.variants!.isNotEmpty
                    ? (widget.initialOffer?.variantId != null
                        ? product.variants!.firstWhere(
                            (v) => v.id == widget.initialOffer!.variantId,
                            orElse: () => product!.variants!.first,
                          )
                        : product.variants!.first)
                    : null);

            final favCubit = context.watch<FavoritesCubit>();
            final isFav = product != null && product.id != null
                ? favCubit.isProductFavorited(
                    product.id!,
                    defaultVal: product.isFavorite,
                  )
                : false;

            final bool hasOffer = widget.initialOffer != null ||
                (activeVariant?.hasActiveOffer == true) ||
                (activeVariant?.discountAmount != null &&
                    activeVariant?.discountAmount != 0);

            String? oldPrice;
            String currentPrice = product?.displayPrice ?? "0";

            if (widget.initialOffer != null) {
              oldPrice = widget.initialOffer!.variantPrice?.toString() ??
                  activeVariant?.price?.toString();
              currentPrice = widget.initialOffer!.discountValue?.toString() ??
                  widget.initialOffer!.variantPrice?.toString() ??
                  activeVariant?.newPrice?.toString() ??
                  activeVariant?.price?.toString() ??
                  currentPrice;
            } else if (activeVariant != null) {
              if (activeVariant.hasActiveOffer == true ||
                  (activeVariant.discountAmount != null &&
                      activeVariant.discountAmount != 0)) {
                oldPrice = activeVariant.price?.toString();
                currentPrice = activeVariant.newPrice?.toString() ??
                    activeVariant.price?.toString() ??
                    "0";
              } else {
                currentPrice = activeVariant.price?.toString() ??
                    product?.displayPrice ??
                    "0";
              }
            }

            Widget buildOfferBadge() {
              if (!hasOffer) return const SizedBox.shrink();
              final durationText = widget.initialOffer?.to != null
                  ? "صالح حتى: ${widget.initialOffer!.to}"
                  : "عرض محدود لفترة مؤقتة";
              return Container(
                margin: EdgeInsets.only(top: 16.h, bottom: 8.h),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withValues(alpha: 0.85),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.local_offer_rounded,
                        color: AppColors.white,
                        size: 20,
                      ),
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "عرض خاص حصري 🔥",
                            style: AppTextStyle.font14.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          4.verticalSpace,
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time_rounded,
                                color: AppColors.white,
                                size: 14,
                              ),
                              4.horizontalSpace,
                              Text(
                                durationText,
                                style: AppTextStyle.font12.copyWith(
                                  color: AppColors.white.withValues(alpha: 0.95),
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
            }

            Widget buildVariantSelector() {
              if (product?.variants == null || product!.variants!.isEmpty) {
                return const SizedBox.shrink();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.verticalSpace,
                  Text(
                    "الأحجام والخيارات المتاحة:",
                    style: AppTextStyle.font16.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                  ),
                  10.verticalSpace,
                  Wrap(
                    spacing: 10.w,
                    runSpacing: 10.h,
                    children: product.variants!.map((v) {
                      final isSelected = activeVariant?.id == v.id;
                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedVariant = v;
                          });
                          cubit.selectVariant(v);
                        },
                        borderRadius: BorderRadius.circular(12.r),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 10.h,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.greyBackground,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.formBorder,
                              width: 1.5,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary
                                          .withValues(alpha: 0.25),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                v.property ?? "خيار",
                                style: AppTextStyle.font14.copyWith(
                                  color: isSelected
                                      ? AppColors.white
                                      : AppColors.textMain,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              2.verticalSpace,
                              Text(
                                "${v.newPrice ?? v.price ?? 0} ل.س",
                                style: AppTextStyle.font12.copyWith(
                                  color: isSelected
                                      ? AppColors.white.withValues(alpha: 0.9)
                                      : AppColors.greyMedium2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              );
            }

            Widget buildSkuAndAvailabilityStrip() {
              final int stockCount =
                  activeVariant?.stock ?? product?.stock ?? 0;
              final bool isAvailable =
                  stockCount > 0 || (activeVariant?.isActiveBool ?? true);
              return Container(
                margin: EdgeInsets.only(top: 16.h),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppColors.greyBackground,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.qr_code_2_rounded,
                          color: AppColors.greyMedium2,
                          size: 20,
                        ),
                        6.horizontalSpace,
                        Text(
                          "SKU: ${activeVariant?.id != null ? 'SKU-${activeVariant!.id}' : (product?.skuCode ?? 'N/A')}",
                          style: AppTextStyle.font14.copyWith(
                            color: AppColors.greyMedium1,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 8.w,
                          height: 8.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isAvailable ? Colors.green : Colors.red,
                          ),
                        ),
                        6.horizontalSpace,
                        Text(
                          isAvailable ? "متوفر ($stockCount)" : "غير متوفر",
                          style: AppTextStyle.font14.copyWith(
                            color: isAvailable
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }

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
                      icon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                              scale: animation, child: child);
                        },
                        child: Icon(
                          isFav
                              ? Icons.favorite
                              : Icons.favorite_border_outlined,
                          key: ValueKey<bool>(isFav),
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    Center(
                      child: product?.fullImageUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16.r),
                              child: AppCachedNetworkImage(
                                imageUrl: product!.fullImageUrl!,
                                height: 250.h,
                                width: 1.sw,
                                fit: BoxFit.cover,
                                errorWidget: Container(
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
                    buildOfferBadge(),
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (oldPrice != null && oldPrice != currentPrice)
                              Text(
                                "$oldPrice ل.س",
                                style: AppTextStyle.font16.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                  color: AppColors.greyMedium2,
                                ),
                              ),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (child, animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: ScaleTransition(
                                    scale: animation,
                                    child: child,
                                  ),
                                );
                              },
                              child: Text(
                                "$currentPrice ل.س",
                                key: ValueKey<String>(currentPrice),
                                style: AppTextStyle.font24.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
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
                    buildVariantSelector(),
                    buildSkuAndAvailabilityStrip(),
                    16.verticalSpace,
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
                        final variantToAdd = selectedVariant ??
                            cubit.selectedVariant ??
                            (cubit.currentProduct?.variants?.isNotEmpty == true
                                ? cubit.currentProduct!.variants!.first
                                : (widget.initialProduct?.variants?.isNotEmpty ==
                                        true
                                    ? widget.initialProduct!.variants!.first
                                    : null));
                        if (variantToAdd != null && variantToAdd.id != null) {
                          getIt<CartCubit>().addToCart(
                            variantToAdd.id!,
                            currentQuantity,
                          );
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
