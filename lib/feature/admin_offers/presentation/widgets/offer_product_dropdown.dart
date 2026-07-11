import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/models/variant_model.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/feature/admin_offers/presentation/cubit/admin_offers_cubit.dart';
import 'package:primo/feature/admin_offers/presentation/cubit/admin_offers_state.dart';
import 'package:primo/feature/admin_product/presentation/cubit/admin_products_list_cubit.dart';

class OfferProductDropdown extends StatelessWidget {
  const OfferProductDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminOffersCubit, AdminOffersState>(
      builder: (context, state) {
        final cubit = context.read<AdminOffersCubit>();
        final productsCubit = context.read<AdminProductsListCubit>();
        if (cubit.availableVariants.isEmpty && productsCubit.allProducts.isNotEmpty) {
          cubit.loadVariantsFromProducts(productsCubit.allProducts);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "اختر المنتج / النوع",
              style: AppTextStyle.font12.copyWith(
                color: AppColors.greyDark,
                fontWeight: FontWeight.w600,
              ),
            ),
            8.verticalSpace,
            LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  width: constraints.maxWidth,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: DropdownMenu<VariantModel>(
                    width: constraints.maxWidth,
                    enableSearch: true,
                    enableFilter: true,
                    initialSelection: cubit.selectedVariant,
                    hintText: "ابحث واختر منتجاً أو نوعاً لتطبيق العرض عليه...",
                    textStyle: AppTextStyle.font14.copyWith(color: AppColors.textMain),
                    inputDecorationTheme: InputDecorationTheme(
                      filled: true,
                      fillColor: AppColors.white,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSelected: (variant) {
                      cubit.selectVariant(variant);
                    },
                    dropdownMenuEntries: cubit.availableVariants.map((variant) {
                      final productName = variant.product?.name ?? "منتج #${variant.productId ?? ''}";
                      final sku = variant.product?.skuCode != null && variant.product!.skuCode!.isNotEmpty
                          ? " [SKU: ${variant.product!.skuCode}]"
                          : "";
                      final variantProp = variant.property ?? "قطعة";
                      final label = "$productName$sku - $variantProp (${variant.price ?? 0} ل.س)";
                      return DropdownMenuEntry<VariantModel>(
                        value: variant,
                        label: label,
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
