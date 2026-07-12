import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

// استدعاءات إضافية هامة لعمل الشاشة
import 'package:primo/core/helper/snack_bar_helper.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/di/service_locator.dart';
import 'package:primo/feature/cart/presentation/cubit/cart_cubit.dart';
import 'package:primo/feature/cart/presentation/cubit/cart_state.dart';

import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/widgets/app_button.dart';
import 'package:primo/core/widgets/app_empty_state.dart';
import 'package:primo/core/widgets/app_error_widget.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';
import 'package:primo/feature/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:primo/feature/favorites/presentation/cubit/favorites_state.dart';
import 'package:primo/feature/favorites/presentation/widgets/favorite_product_card.dart';

class FavoritesPage extends StatelessWidget {
  final bool isFromBottomNav;
  const FavoritesPage({super.key, required this.isFromBottomNav});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        // 💡 1. تغليف الواجهة بـ Listener للسلة لإظهار رسائل النجاح والخطأ عند الإضافة
        child: BlocListener<CartCubit, CartState>(
          bloc: getIt<CartCubit>(), // نراقب السلة المشتركة (Singleton)
          listener: (context, cartState) {
            if (cartState is CartLoaded && cartState.actionMessage != null) {
              context.showSuccess(cartState.actionMessage!);
            } else if (cartState is CartError) {
              context.showError(cartState.errorMessage);
            }
          },
          child: Column(
            children: [
              CustomAppBar(
                title: "المفضلة",
                showRightIcon: false,
                suffixsIcon: isFromBottomNav ? const SizedBox() : null,
              ),
              Expanded(
                child: BlocBuilder<FavoritesCubit, FavoritesState>(
                  builder: (context, state) {
                    if (state is FavoritesLoading ||
                        state is FavoritesInitial) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    } else if (state is FavoritesLoaded) {
                      if (state.favorites.isEmpty) {
                        return AppEmptyState(
                          icon: Icons.favorite_border_rounded,
                          message: "قائمة المفضلة فارغة",
                          onRetry: () =>
                              context.read<FavoritesCubit>().fetchFavorites(),
                        );
                      }
                      return RefreshIndicator(
                        color: AppColors.primary,
                        onRefresh: () async {
                          await context.read<FavoritesCubit>().fetchFavorites();
                        },
                        child: GridView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 20.h,
                        ),
                        itemCount: state.favorites.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16.w,
                          mainAxisSpacing: 16.h,
                          childAspectRatio: 0.68,
                        ),
                        itemBuilder: (context, index) {
                          final item = state.favorites[index];

                          // 💡 2. حساب السعر وتجنب ظهوره كصفر
                          // نأخذ السعر الأساسي إذا كان الـ displayPrice صفراً أو فارغاً
                          final String displayPrice = (item.displayPrice != '0')
                              ? item.displayPrice
                              : (item.price?.toString() ?? '0');

                          return Container(
                            key: ValueKey(item.id),
                            // 💡 3. تمكين النقر على الكرت للذهاب لتفاصيل المنتج
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  Routes.productDetails,
                                  arguments:
                                      item, // نمرر المنتج ليفتح في التفاصيل
                                );
                              },
                              child: FavoriteProductCard(
                                title: item.title ?? item.name ?? "منتج",
                                weight: item.unit ?? 'قطعة',
                                price: "$displayPrice ل.س",
                                imagePath: item.fullImageUrl ?? "",
                                product: item,
                                onFavoriteTap: () {
                                  if (item.id != null) {
                                    context
                                        .read<FavoritesCubit>()
                                        .toggleFavorite(item.id!);
                                  }
                                },
                                onAddTap: () {
                                  // 💡 4. برمجة زر الإضافة للسلة من داخل المفضلة
                                  // السلة تتطلب variantId، إذا لم يكن له خصائص نرسل id المنتج
                                  final variantId =
                                      (item.variants != null &&
                                          item.variants!.isNotEmpty)
                                      ? item.variants!.first.id
                                      : item.id;

                                  if (variantId != null) {
                                    getIt<CartCubit>().addToCart(variantId, 1);
                                  } else {
                                    context.showError(
                                      "لا يمكن إضافة هذا المنتج حالياً",
                                    );
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      );
                    } else if (state is FavoritesError) {
                      return AppErrorWidget(
                        message: state.errorMessage,
                        onRetry: () =>
                            context.read<FavoritesCubit>().fetchFavorites(),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
              BlocBuilder<FavoritesCubit, FavoritesState>(
                builder: (context, state) {
                  if (state is FavoritesLoaded && state.favorites.isNotEmpty) {
                    return Container(
                      padding: EdgeInsets.only(
                        left: 24.w,
                        right: 24.w,
                        bottom: 24.h,
                        top: 16.h,
                      ),
                      decoration: const BoxDecoration(
                        color: AppColors.background,
                      ),
                      child: BlocBuilder<CartCubit, CartState>(
                        bloc: getIt<CartCubit>(),
                        builder: (context, cartState) {
                          return AppButton(
                            isLoading: cartState is CartLoading,
                            text: "إضافة الكل إلى السلة",
                            icon: Icons.add_shopping_cart,
                            onPressed: () async {
                              if (cartState is CartLoading) return;
                              // 💡 5. برمجة زر "إضافة الكل" ليمر على كل المنتجات ويضيفها

                              for (var item in state.favorites) {
                                final variantId =
                                    (item.variants != null &&
                                        item.variants!.isNotEmpty)
                                    ? item.variants!.first.id
                                    : item.id;

                                if (variantId != null) {
                                  await getIt<CartCubit>().addToCart(
                                    variantId,
                                    1,
                                  );
                                }
                              }
                            },
                          );
                        },
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
