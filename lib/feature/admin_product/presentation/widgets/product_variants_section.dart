import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import '../cubit/admin_product_cubit.dart';
import '../cubit/admin_product_state.dart';

class ProductVariantsSection extends StatelessWidget {
  const ProductVariantsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminProductCubit, AdminProductState>(
      buildWhen: (prev, current) => current is AdminProductUIChanged,
      builder: (context, state) {
        final cubit = context.read<AdminProductCubit>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "أنواع وأحجام المنتج",
              style: AppTextStyle.font18.copyWith(
                color: AppColors.textMain,
                fontWeight: FontWeight.bold,
              ),
            ),
            16.verticalSpace,

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cubit.variants.length,
              separatorBuilder: (context, index) => 16.verticalSpace,
              itemBuilder: (context, index) {
                return _buildVariantCard(cubit.variants[index], index, cubit);
              },
            ),
            16.verticalSpace,

            InkWell(
              onTap: () => cubit.addVariant(),
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.textMain, width: 1.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_rounded,
                      color: AppColors.textMain,
                      size: 22.sp,
                    ),
                    8.horizontalSpace,
                    Text(
                      "إضافة حجم أو نوع آخر",
                      style: AppTextStyle.font16.copyWith(
                        color: AppColors.textMain,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildVariantCard(
    VariantItemController variant,
    int index,
    AdminProductCubit cubit,
  ) {
    final borderStyle = OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.formBorder, width: 1),
      borderRadius: BorderRadius.circular(12.r),
    );

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.formBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel("النوع / الحجم"),
          8.verticalSpace,
          TextFormField(
            controller: variant.propertyController,
            decoration: InputDecoration(
              hintText: "مثال: 4 كيلو لافندر",
              hintStyle: AppTextStyle.font14.copyWith(
                color: AppColors.greyMedium3,
              ),
              filled: true,
              fillColor: AppColors.white,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
              border: borderStyle,
              enabledBorder: borderStyle,
              focusedBorder: borderStyle.copyWith(
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1,
                ),
              ),
            ),
          ),
          16.verticalSpace,
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("السعر"),
                    8.verticalSpace,
                    TextFormField(
                      controller: variant.priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "0",
                        hintStyle: AppTextStyle.font14.copyWith(
                          color: AppColors.greyMedium3,
                        ),
                        filled: true,
                        fillColor: AppColors.white,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        border: borderStyle,
                        enabledBorder: borderStyle,
                        focusedBorder: borderStyle.copyWith(
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1,
                          ),
                        ),
                        prefixIcon: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "ر.س",
                              style: AppTextStyle.font12.copyWith(
                                color: AppColors.greyMedium3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("الكمية"),
                    8.verticalSpace,
                    TextFormField(
                      controller: variant.stockController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "0",
                        hintStyle: AppTextStyle.font14.copyWith(
                          color: AppColors.greyMedium3,
                        ),
                        filled: true,
                        fillColor: AppColors.white,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        border: borderStyle,
                        enabledBorder: borderStyle,
                        focusedBorder: borderStyle.copyWith(
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          16.verticalSpace,
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () => cubit.removeVariant(index), // استدعاء الحذف
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFDAD6),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.primary,
                  size: 22.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: AppTextStyle.font12.copyWith(
        color: AppColors.greyDark,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
