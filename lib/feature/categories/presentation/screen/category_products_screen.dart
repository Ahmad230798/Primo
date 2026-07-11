import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';
import 'package:primo/feature/categories/presentation/cubit/category_products_cubit.dart';
import 'package:primo/feature/categories/presentation/cubit/category_products_state.dart';
import 'package:primo/feature/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:primo/feature/search/presentation/widgets/user_product_card.dart';

class CategoryProductsScreen extends StatelessWidget {
  final String categoryName;

  const CategoryProductsScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: CustomAppBar(title: categoryName, showRightIcon: false),
            ),
            Expanded(
              child: BlocBuilder<CategoryProductsCubit, CategoryProductsState>(
                builder: (context, state) {
                  if (state is CategoryProductsLoading ||
                      state is CategoryProductsInitial) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  } else if (state is CategoryProductsError) {
                    return Center(
                      child: Text(
                        state.errorMessage,
                        style: AppTextStyle.font14.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    );
                  } else if (state is CategoryProductsLoaded) {
                    final products = state.products;
                    if (products.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox_rounded,
                              size: 64.sp,
                              color: AppColors.greyMedium2,
                            ),
                            16.verticalSpace,
                            Text(
                              "سيتم إضافة منتجات قريباً",
                              style: AppTextStyle.font16.copyWith(
                                color: AppColors.greyMedium2,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 20.h,
                      ),
                      itemCount: products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.w,
                        mainAxisSpacing: 16.h,
                        childAspectRatio: 0.65,
                      ),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        final favCubit = context.watch<FavoritesCubit>();
                        final isFav = favCubit.isProductFavorited(
                          product.id ?? 0,
                          defaultVal: product.isFavorite,
                        );
                        return UserProductCard(
                          title: product.title ?? product.name ?? "منتج",
                          weight: product.unit ?? 'قطعة',
                          price: "${product.displayPrice} ل.س",
                          imageUrl: product.fullImageUrl ?? "",
                          isFavorite: isFav,
                          isOutOfStock:
                              product.stock != null && product.stock! <= 0,
                          product: product,
                          onFavoriteTap: () {
                            if (product.id != null) {
                              favCubit.toggleFavorite(product.id!);
                            }
                          },
                        );
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
