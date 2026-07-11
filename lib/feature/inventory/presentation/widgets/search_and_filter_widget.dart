import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/feature/admin_product/presentation/cubit/admin_products_list_cubit.dart';

class SearchAndFilterWidget extends StatelessWidget {
  const SearchAndFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
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
        ),
        12.horizontalSpace,
        // زر الفلترة
        Container(
          width: 48.w,
          height: 48.h,
          decoration: BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.formBorder),
          ),
          child: IconButton(
            onPressed: () => _showFilterSheet(context),
            icon: Icon(
              Icons.filter_list_rounded,
              color: AppColors.greyDark,
              size: 24.sp,
            ),
          ),
        ),
      ],
    );
  }

  void _showFilterSheet(BuildContext context) {
    final cubit = context.read<AdminProductsListCubit>();
    final categoriesMap = <int, String>{};
    for (final p in cubit.allProducts) {
      final catId = p.categoryId ?? p.category?.id;
      final catName = p.categoryName ?? p.category?.name ?? "تصنيف #$catId";
      if (catId != null) {
        categoriesMap[catId] = catName;
      }
    }

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (bottomSheetContext) {
        return Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "فلترة حسب التصنيف",
                style: AppTextStyle.font18.copyWith(
                  color: AppColors.textMain,
                  fontWeight: FontWeight.bold,
                ),
              ),
              16.verticalSpace,
              ListTile(
                title: const Text("الكل (بدون فلترة)"),
                leading: Icon(
                  cubit.selectedCategoryIdFilter == null
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: AppColors.primary,
                ),
                onTap: () {
                  cubit.filterByCategory(null);
                  Navigator.pop(bottomSheetContext);
                },
              ),
              ...categoriesMap.entries.map((entry) {
                final isSelected = cubit.selectedCategoryIdFilter == entry.key;
                return ListTile(
                  title: Text(entry.value),
                  leading: Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: AppColors.primary,
                  ),
                  onTap: () {
                    cubit.filterByCategory(entry.key);
                    Navigator.pop(bottomSheetContext);
                  },
                );
              }),
              16.verticalSpace,
            ],
          ),
        );
      },
    );
  }
}
