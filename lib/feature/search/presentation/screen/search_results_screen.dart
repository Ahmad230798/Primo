import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/feature/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:primo/feature/search/presentation/cubit/search_cubit.dart';
import 'package:primo/feature/search/presentation/cubit/search_state.dart';

import '../widgets/request_product_section.dart';
import '../widgets/search_filter_chips.dart';
import '../widgets/user_product_card.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<SearchCubit>();
      if (cubit.products.isNotEmpty) {
        // already searched
      } else {
        cubit.searchProducts("");
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // 1. شريط البحث العلوي (Header)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              decoration: BoxDecoration(color: AppColors.background),
              child: Row(
                children: [
                  // سهم الرجوع
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(99.r),
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Icon(
                        Icons.arrow_forward_rounded, // سهم لليمين لأن التطبيق RTL
                        color: AppColors.greyDark,
                        size: 26.sp,
                      ),
                    ),
                  ),
                  12.horizontalSpace,
                  // حقل البحث
                  Expanded(
                    child: Container(
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: AppColors.formBorder),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onSubmitted: (query) {
                                context.read<SearchCubit>().searchProducts(query);
                              },
                              onChanged: (query) {
                                context.read<SearchCubit>().searchProducts(query);
                              },
                              style: AppTextStyle.font14.copyWith(
                                color: AppColors.textMain,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: InputDecoration(
                                hintText: "ابحث عن منتج...",
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                ),
                                isDense: true,
                              ),
                            ),
                          ),
                          // زر مسح النص (X)
                          InkWell(
                            onTap: () {
                              _searchController.clear();
                              context.read<SearchCubit>().searchProducts("");
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Icon(
                                Icons.close_rounded,
                                color: AppColors.greyMedium3,
                                size: 20.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 2. محتوى الصفحة القابل للتمرير بـ CustomScrollView (Virtualization)
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  return CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            const SearchFilterChips(),
                            16.verticalSpace,
                          ],
                        ),
                      ),
                      if (state is SearchLoading)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 40.h),
                            child: const Center(
                              child: CircularProgressIndicator(color: AppColors.primary),
                            ),
                          ),
                        )
                      else if (state is SearchLoaded && state.products.isNotEmpty)
                        SliverPadding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          sliver: SliverGrid(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16.w,
                              mainAxisSpacing: 16.h,
                              childAspectRatio: 0.65,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final products = state.products;
                                final product = products[index];
                                final favCubit = context.watch<FavoritesCubit>();
                                final isFav = favCubit.isProductFavorited(product.id ?? 0, defaultVal: product.isFavorite);
                                return UserProductCard(
                                  title: product.title ?? product.name ?? "منتج",
                                  weight: product.unit ?? 'قطعة',
                                  price: "${product.displayPrice} ل.س",
                                  imageUrl: product.fullImageUrl ?? "",
                                  isFavorite: isFav,
                                  isOutOfStock: product.stock != null && product.stock! <= 0,
                                  product: product,
                                  onFavoriteTap: () {
                                    if (product.id != null) {
                                      favCubit.toggleFavorite(product.id!);
                                    }
                                  },
                                );
                              },
                              childCount: state.products.length,
                            ),
                          ),
                        )
                      else if (state is SearchError)
                        SliverToBoxAdapter(
                          child: Center(child: Text(state.errorMessage)),
                        )
                      else if (state is SearchLoaded && state.products.isEmpty)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 40.h),
                            child: Center(
                              child: Text(
                                "لم يتم العثور على منتجات مطابقة",
                                style: AppTextStyle.font16.copyWith(color: AppColors.greyMedium2),
                              ),
                            ),
                          ),
                        )
                      else
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 40.h),
                            child: Center(
                              child: Text(
                                "ابحث عن المنتجات المطلوبة",
                                style: AppTextStyle.font16.copyWith(color: AppColors.greyMedium2),
                              ),
                            ),
                          ),
                        ),
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            32.verticalSpace,
                            const RequestProductSection(),
                            40.verticalSpace,
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
