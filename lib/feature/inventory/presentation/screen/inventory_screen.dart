import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/helper/snack_bar_helper.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/admin_drawer.dart';
import 'package:primo/core/widgets/app_empty_state.dart';
import 'package:primo/core/widgets/custom_error_retry_widget.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';
import 'package:primo/feature/admin_product/presentation/cubit/admin_products_list_cubit.dart';
import 'package:primo/feature/admin_product/presentation/cubit/admin_products_list_state.dart';

import '../widgets/inventory_product_card.dart';
import '../widgets/search_and_filter_widget.dart';
import 'package:primo/core/widgets/app_shimmer_skeletons.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProductsListCubit>().getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const AdminDrawer(currentRoute: Routes.adminInventory),
      floatingActionButton: SizedBox(
        height: 56.h,
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, Routes.addProducts);
          },
          backgroundColor: AppColors.primary,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          icon: Icon(Icons.add, color: AppColors.white, size: 24.sp),
          label: Text(
            "إضافة منتج جديد",
            style: AppTextStyle.font14.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: CustomAppBar(
                title: "Primo",
                suffixsIcon: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.adminNotificationsHistory);
                  },
                  borderRadius: BorderRadius.circular(99.r),
                  child: Container(
                    width: 44.w,
                    height: 44.h,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.notifications_none_rounded,
                        color: AppColors.textMain,
                        size: 28.sp,
                      ),
                    ),
                  ),
                ),
                icon: Icon(
                  Icons.menu_rounded,
                  color: AppColors.textMain,
                  size: 28.sp,
                ),
                showRightIcon: true,
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async {
                  await context.read<AdminProductsListCubit>().getProducts();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      16.verticalSpace,
                      Text(
                        "إدارة المخزون",
                        style: AppTextStyle.font30.copyWith(
                          color: AppColors.textMain,
                        ),
                      ),
                      4.verticalSpace,
                      Text(
                        "تحكم في توافر المنتجات وتحديث الكميات",
                        style: AppTextStyle.font14.copyWith(
                          color: AppColors.greyMedium3,
                        ),
                      ),
                      24.verticalSpace,
                      const SearchAndFilterWidget(),
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
                              onRetry: () => context.read<AdminProductsListCubit>().getProducts(),
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
                              onRetry: () => context.read<AdminProductsListCubit>().getProducts(),
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
                              category: product.category?.name ?? "عام",
                              name: product.name ?? "منتج",
                              sku: product.skuCode?.isNotEmpty == true
                                  ? product.skuCode!
                                  : "SKU-#${product.id ?? ''}",
                              price: priceStr,
                              quantity: totalStock,
                              isAvailable: product.isActiveBool,
                              isDollar: product.isDollarBool,
                              imagePath: product.image ?? "assets/images/honey.png",
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
