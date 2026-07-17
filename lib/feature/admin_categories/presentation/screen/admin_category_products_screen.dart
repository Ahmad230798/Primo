import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/helper/snack_bar_helper.dart';
import 'package:primo/core/models/category_model.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/app_empty_state.dart';
import 'package:primo/core/widgets/custom_error_retry_widget.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';
import 'package:primo/feature/admin_product/presentation/cubit/admin_products_list_cubit.dart';
import 'package:primo/feature/admin_product/presentation/cubit/admin_products_list_state.dart';
import 'package:primo/feature/inventory/presentation/widgets/inventory_product_card.dart';
import 'package:primo/core/widgets/app_shimmer_skeletons.dart';

class AdminCategoryProductsScreen extends StatefulWidget {
  final CategoryModel category;

  const AdminCategoryProductsScreen({super.key, required this.category});

  @override
  State<AdminCategoryProductsScreen> createState() =>
      _AdminCategoryProductsScreenState();
}

class _AdminCategoryProductsScreenState
    extends State<AdminCategoryProductsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<AdminProductsListCubit>();
      cubit.getProducts().then((_) {
        if (mounted) {
          cubit.filterByCategory(widget.category.id);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: CustomAppBar(
                title: widget.category.name ?? "منتجات القسم",
                showRightIcon: false,
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async {
                  final cubit = context.read<AdminProductsListCubit>();
                  await cubit.getProducts();
                  if (mounted) {
                    cubit.filterByCategory(widget.category.id);
                  }
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      16.verticalSpace,
                      Text(
                        "منتجات قسم ${widget.category.name ?? ''}",
                        style: AppTextStyle.font24.copyWith(
                          color: AppColors.textMain,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      4.verticalSpace,
                      Text(
                        "عرض وتعديل منتجات هذا القسم فقط.",
                        style: AppTextStyle.font14.copyWith(
                          color: AppColors.greyMedium3,
                        ),
                      ),
                      20.verticalSpace,
                      Container(
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(99.r),
                          border: Border.all(color: AppColors.formBorder),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search_rounded,
                              color: AppColors.greyMedium3,
                              size: 24.sp,
                            ),
                            12.horizontalSpace,
                            Expanded(
                              child: TextField(
                                onChanged: (val) {
                                  context.read<AdminProductsListCubit>().searchProducts(val);
                                },
                                decoration: InputDecoration(
                                  hintText: "البحث برقم المنتج أو الاسم...",
                                  hintStyle: AppTextStyle.font14.copyWith(
                                    color: AppColors.greyMedium3,
                                  ),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                ),
                                style: AppTextStyle.font14.copyWith(
                                  color: AppColors.textMain,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      24.verticalSpace,
                      BlocConsumer<
                        AdminProductsListCubit,
                        AdminProductsListState
                      >(
                        listener: (context, state) {
                          if (state is AdminProductsListActionSuccess) {
                            context.showSuccess(state.message);
                          } else if (state is AdminProductsListError &&
                              context.read<AdminProductsListCubit>().currentProducts.isNotEmpty) {
                            context.showError(state.message);
                          }
                        },
                        builder: (context, state) {
                          if (state is AdminProductsListLoading) {
                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 5,
                              separatorBuilder: (context, index) => 16.verticalSpace,
                              itemBuilder: (context, index) => const AdminInventoryCardShimmer(),
                            );
                          } else if (state is AdminProductsListError &&
                              context.read<AdminProductsListCubit>().currentProducts.isEmpty) {
                            return CustomErrorRetryWidget(
                              message: state.message,
                              onRetry: () {
                                final cubit = context.read<AdminProductsListCubit>();
                                cubit.getProducts().then((_) {
                                  if (mounted) {
                                    cubit.filterByCategory(widget.category.id);
                                  }
                                });
                              },
                            );
                          }

                          final products =
                              context
                                  .read<AdminProductsListCubit>()
                                  .currentProducts;

                          if (products.isEmpty) {
                            return AppEmptyState(
                              icon: Icons.inventory_2_outlined,
                              title: "لا توجد بيانات",
                              subtitle: "كل شيء هادئ هنا في الوقت الحالي",
                              onRetry: () {
                                final cubit = context.read<AdminProductsListCubit>();
                                cubit.getProducts().then((_) {
                                  if (mounted) {
                                    cubit.filterByCategory(widget.category.id);
                                  }
                                });
                              },
                            );
                          }

                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: products.length,
                            separatorBuilder:
                                (context, index) => 16.verticalSpace,
                            itemBuilder: (context, index) {
                              final product = products[index];
                              final priceStr = product.lowestPrice;
                              final totalStock = product.totalStock;

                              return InventoryProductCard(
                                category: product.category?.name ??
                                    widget.category.name ??
                                    "عام",
                                name: product.name ?? "منتج",
                                sku: product.skuCode?.isNotEmpty == true
                                    ? product.skuCode!
                                    : "SKU-#${product.id ?? ''}",
                                price: priceStr,
                                quantity: totalStock,
                                isAvailable: product.isActiveBool,
                                isDollar: product.isDollarBool,
                                imagePath: product.image ??
                                    "assets/images/honey.png",
                                onToggle: () {
                                  if (product.id != null) {
                                    context
                                        .read<AdminProductsListCubit>()
                                        .toggleProductStatus(product.id!);
                                  }
                                },
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    Routes.editProduct,
                                    arguments: product,
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                      100.verticalSpace,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
