import 'dart:async'; // 💡 استيراد مكتبة الـ Timer
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/feature/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:primo/feature/favorites/presentation/cubit/favorites_state.dart'; // 💡 استيراد الـ State الخاص بالمفضلة
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
  Timer? _debounce; // 💡 متغير المؤقت لمنع ضغط السيرفر

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<SearchCubit>();
      if (cubit.products.isEmpty) {
        cubit.searchProducts("");
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel(); // 💡 تنظيف المؤقت عند الخروج من الشاشة
    _searchController.dispose();
    super.dispose();
  }

  // 💡 دالة ذكية للبحث مع تأخير زمني (Debouncing)
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        context.read<SearchCubit>().searchProducts(query);
      }
    });
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
              decoration: const BoxDecoration(color: AppColors.background),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(99.r),
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        color: AppColors.greyDark,
                        size: 26.sp,
                      ),
                    ),
                  ),
                  12.horizontalSpace,
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
                                _debounce?.cancel(); // إلغاء المؤقت إذا ضغط تم
                                context.read<SearchCubit>().searchProducts(
                                  query,
                                );
                              },
                              // 💡 استخدام دالة التأخير الذكية هنا
                              onChanged: _onSearchChanged,
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
                          InkWell(
                            onTap: () {
                              _searchController.clear();
                              _debounce?.cancel();
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

            // 2. محتوى الصفحة القابل للتمرير
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  return CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "ترتيب وحل الفلترة:",
                                    style: AppTextStyle.font12.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.greyDark,
                                    ),
                                  ),
                                  DropdownButton<String>(
                                    value: [
                                      "الأقل سعراً",
                                      "الأعلى سعراً",
                                      "الأعلى تقييماً",
                                      "وصل حديثاً"
                                    ].contains(context.read<SearchCubit>().activeFilter)
                                        ? context.read<SearchCubit>().activeFilter
                                        : null,
                                    hint: Text(
                                      "ترتيب حسب السعر / التقييم",
                                      style: AppTextStyle.font12.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    underline: const SizedBox(),
                                    icon: Icon(
                                      Icons.sort_rounded,
                                      size: 18.sp,
                                      color: AppColors.primary,
                                    ),
                                    items: [
                                      "الأقل سعراً",
                                      "الأعلى سعراً",
                                      "الأعلى تقييماً",
                                      "وصل حديثاً"
                                    ]
                                        .map((f) => DropdownMenuItem(
                                              value: f,
                                              child: Text(
                                                f,
                                                style: AppTextStyle.font12,
                                              ),
                                            ))
                                        .toList(),
                                    onChanged: (val) {
                                      if (val != null) {
                                        context.read<SearchCubit>().applyFilter(val);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            8.verticalSpace,
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
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        )
                      else if (state is SearchLoaded &&
                          state.products.isNotEmpty)
                        SliverPadding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          sliver: SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16.w,
                                  mainAxisSpacing: 16.h,
                                  childAspectRatio: 0.65,
                                ),
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final products = state.products;
                              final product = products[index];

                              // 💡 حصر التحديث في البطاقة الحالية فقط لحل مشكلة الأداء
                              return BlocBuilder<
                                FavoritesCubit,
                                FavoritesState
                              >(
                                builder: (context, favState) {
                                  final favCubit = context
                                      .read<FavoritesCubit>();
                                  final isFav = favCubit.isProductFavorited(
                                    product.id ?? 0,
                                    defaultVal: product.isFavorite,
                                  );

                                   return TweenAnimationBuilder<double>(
                                     duration: Duration(milliseconds: 300 + (index * 50).clamp(0, 400)),
                                     tween: Tween(begin: 0.0, end: 1.0),
                                     builder: (context, value, child) {
                                       return Transform.translate(
                                         offset: Offset(0, 20 * (1.0 - value)),
                                         child: Opacity(
                                           opacity: value,
                                           child: child,
                                         ),
                                       );
                                     },
                                     child: UserProductCard(
                                       title:
                                           product.title ?? product.name ?? "منتج",
                                       weight: product.unit ?? 'قطعة',
                                       price: "${product.displayPrice} ل.س",
                                       imageUrl: product.fullImageUrl ?? "",
                                       isFavorite: isFav,
                                       isOutOfStock:
                                           product.stock != null &&
                                           product.stock! <= 0,
                                       product: product,
                                       onFavoriteTap: () {
                                         if (product.id != null) {
                                           favCubit.toggleFavorite(product.id!);
                                         }
                                       },
                                     ),
                                   );
                                },
                              );
                            }, childCount: state.products.length),
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
                                style: AppTextStyle.font16.copyWith(
                                  color: AppColors.greyMedium2,
                                ),
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
                                style: AppTextStyle.font16.copyWith(
                                  color: AppColors.greyMedium2,
                                ),
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
