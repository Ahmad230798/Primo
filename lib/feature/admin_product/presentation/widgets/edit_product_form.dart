import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/app_text_form_field.dart';
import '../cubit/admin_product_cubit.dart';
import '../cubit/admin_product_state.dart';
import 'product_variants_section.dart';

class EditProductForm extends StatelessWidget {
  const EditProductForm({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AdminProductCubit>();
    final borderStyle = OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.formBorder, width: 1),
      borderRadius: BorderRadius.circular(12.r),
    );

    return BlocBuilder<AdminProductCubit, AdminProductState>(
      buildWhen: (prev, current) => current is AdminProductUIChanged,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("الاسم"),
            8.verticalSpace,
            AppTextFormField(
              controller: cubit.nameController,
              hinttText: "اسم المنتج",
              isFilled: true,
              fillColor: AppColors.greyBackground,
              enabledBorder: borderStyle,
              focusedBorder: borderStyle.copyWith(
                borderSide: const BorderSide(color: AppColors.primary, width: 1),
              ),
            ),
            16.verticalSpace,

            _buildLabel("القسم"),
            8.verticalSpace,
            DropdownButtonFormField<String>(
              initialValue: cubit.selectedCategoryId,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.greyBackground,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 14.h,
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
              hint: Text(
                "اختر القسم",
                style: AppTextStyle.font14.copyWith(color: AppColors.greyDark),
              ),
              icon: Icon(
                Icons.expand_more_rounded,
                color: AppColors.textMain,
                size: 24.sp,
              ),
              items: cubit.categories.map((cat) {
                return DropdownMenuItem<String>(
                  value: cat.id?.toString(),
                  child: Text(
                    cat.name ?? "",
                    style: AppTextStyle.font14.copyWith(
                      color: AppColors.textMain,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (val) {
                cubit.selectedCategoryId = val;
              },
            ),
            16.verticalSpace,

            _buildLabel("الوصف"),
            8.verticalSpace,
            AppTextFormField(
              controller: cubit.descController,
              hinttText: "وصف المنتج",
              isFilled: true,
              fillColor: AppColors.greyBackground,
              enabledBorder: borderStyle,
              focusedBorder: borderStyle.copyWith(
                borderSide: const BorderSide(color: AppColors.primary, width: 1),
              ),
            ),
            24.verticalSpace,

            const ProductVariantsSection(),
          ],
        );
      },
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
