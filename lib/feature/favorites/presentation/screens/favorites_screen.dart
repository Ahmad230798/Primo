import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/app_button.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';
import 'package:primo/feature/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:primo/feature/favorites/presentation/cubit/favorites_state.dart';
import 'package:primo/feature/favorites/presentation/widgets/favorite_product_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(title: "المفضلة", showRightIcon: false),
            Expanded(
              child: BlocBuilder<FavoritesCubit, FavoritesState>(
                builder: (context, state) {
                  if (state is FavoritesLoading || state is FavoritesInitial) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    );
                  } else if (state is FavoritesLoaded) {
                    if (state.favorites.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.favorite_border_rounded, size: 64.sp, color: AppColors.greyMedium2),
                            16.verticalSpace,
                            Text(
                              "قائمة المفضلة فارغة",
                              style: AppTextStyle.font16.copyWith(color: AppColors.greyMedium2),
                            ),
                          ],
                        ),
                      );
                    }
                    return GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                      itemCount: state.favorites.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.w,
                        mainAxisSpacing: 16.h,
                        childAspectRatio: 0.68,
                      ),
                      itemBuilder: (context, index) {
                        final item = state.favorites[index];
                        return FavoriteProductCard(
                          title: item.title ?? item.name ?? "منتج",
                          weight: item.unit ?? 'قطعة',
                          price: "${item.displayPrice} ل.س",
                          imagePath: item.fullImageUrl ?? "",
                          product: item,
                          onFavoriteTap: () {
                            if (item.id != null) {
                              context.read<FavoritesCubit>().toggleFavorite(item.id!);
                            }
                          },
                          onAddTap: () {
                            // TODO: إضافة هذا المنتج المحدد فقط إلى السلة
                          },
                        );
                      },
                    );
                  } else if (state is FavoritesError) {
                    return Center(child: Text(state.errorMessage));
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
                    decoration: const BoxDecoration(color: AppColors.background),
                    child: AppButton(
                      text: "إضافة الكل إلى السلة",
                      icon: Icons.add_shopping_cart,
                      onPressed: () {
                        // TODO: إضافة القائمة كاملة للسلة
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
    );
  }
}
