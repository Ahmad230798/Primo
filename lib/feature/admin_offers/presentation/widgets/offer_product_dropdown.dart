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

        if (cubit.availableVariants.isEmpty &&
            productsCubit.allProducts.isNotEmpty) {
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
                    key: ValueKey(cubit.selectedVariant?.id ?? 'empty'),
                    width: constraints.maxWidth,
                    enableSearch: true,
                    enableFilter: true,
                    requestFocusOnTap: true,
                    menuHeight: 300.h,
                    initialSelection: cubit.selectedVariant,
                    hintText: "اختر المنتج / النوع",
                    textStyle: AppTextStyle.font14.copyWith(
                      color: AppColors.textMain,
                    ),
                    inputDecorationTheme: InputDecorationTheme(
                      filled: true,
                      fillColor: AppColors.white,
                      hintStyle: AppTextStyle.font14.copyWith(
                        color: AppColors.greyDark,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: const BorderSide(
                          color: AppColors.formBorder,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: const BorderSide(
                          color: AppColors.formBorder,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                    ),
                    menuStyle: MenuStyle(
                      backgroundColor: WidgetStatePropertyAll(AppColors.white),
                      surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          side: const BorderSide(color: AppColors.formBorder),
                        ),
                      ),
                      elevation: const WidgetStatePropertyAll(6),
                    ),
                    onSelected: (variant) {
                      cubit.selectVariant(variant);
                    },
                    dropdownMenuEntries: cubit.availableVariants.map((variant) {
                      final parentProduct = productsCubit.allProducts
                          .where((p) => p.id == variant.productId)
                          .firstOrNull;

                      // 1. جلب اسم المنتج
                      final productName =
                          parentProduct?.name ?? parentProduct?.title ?? "منتج";

                      // 2. جلب الخاصية (مثل الحجم أو اللون)
                      final variantProp = variant.property ?? "";

                      // 3. جلب السعر
                      final price = variant.price ?? 0;

                      // 4. بناء النص الأساسي (الاسم والنوع)
                      String label = variantProp.isNotEmpty
                          ? "$productName - $variantProp"
                          : productName;

                      // 5. إضافة السعر داخل أقواس محمية بعلامة (RTL) لمنع انقلاب القوس
                      const rlm = '\u200F';
                      label += " $rlm($price ل.س)$rlm";

                      return DropdownMenuEntry<VariantModel>(
                        value: variant,
                        label: label,
                        labelWidget: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                productName,
                                style: AppTextStyle.font14.copyWith(
                                  color: AppColors.textMain,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                variantProp.isNotEmpty ? variantProp : "-",
                                style: AppTextStyle.font12.copyWith(
                                  color: AppColors.greyDark,
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              '$price ل.س',
                              textDirection: TextDirection.ltr,
                              style: AppTextStyle.font12.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
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
