import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/helper/snack_bar_helper.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/app_text_form_field.dart';
import '../cubit/admin_category_cubit.dart';
import '../cubit/admin_category_state.dart';
import '../cubit/admin_categories_list_cubit.dart';
import '../widgets/category_image_upload.dart';

class AddCategoryScreen extends StatelessWidget {
  const AddCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AdminCategoryCubit>();
    final isEditing = cubit.editingCategoryId != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<AdminCategoryCubit, AdminCategoryState>(
          listenWhen: (previous, current) =>
              current is AdminCategorySuccess || current is AdminCategoryError,
          listener: (context, state) {
            if (state is AdminCategoryError) {
              context.showError(state.error);
            } else if (state is AdminCategorySuccess) {
              context.showSuccess(state.message);
              try {
                context.read<AdminCategoriesListCubit>().getCategories();
              } catch (_) {}
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 16.h,
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(99.r),
                        child: Padding(
                          padding: EdgeInsets.all(8.w),
                          child: Icon(
                            Icons.close_rounded,
                            color: AppColors.greyMedium3,
                            size: 24.sp,
                          ),
                        ),
                      ),
                      8.horizontalSpace,
                      Text(
                        isEditing ? "تعديل القسم" : "إضافة قسم جديد",
                        style: AppTextStyle.font20.copyWith(
                          color: AppColors.textMain,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        16.verticalSpace,
                        Text(
                          "صورة القسم",
                          style: AppTextStyle.font16.copyWith(
                            color: AppColors.textMain,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        8.verticalSpace,
                        const CategoryImageUpload(),
                        24.verticalSpace,
                        Text(
                          "اسم القسم",
                          style: AppTextStyle.font16.copyWith(
                            color: AppColors.textMain,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        8.verticalSpace,
                        AppTextFormField(
                          controller: cubit.nameController,
                          hinttText: "أدخل اسم القسم (مثال: الخضار والفواكه)",
                        ),
                        40.verticalSpace,
                        Divider(color: AppColors.formBorder, height: 1),
                        24.verticalSpace,
                        ElevatedButton(
                          onPressed: state is AdminCategoryLoading
                              ? null
                              : () {
                                  if (isEditing) {
                                    cubit.updateCategory();
                                  } else {
                                    cubit.addCategory();
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            elevation: 0,
                            minimumSize: Size(double.infinity, 56.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                          child: state is AdminCategoryLoading
                              ? const CircularProgressIndicator(
                                  color: AppColors.white,
                                )
                              : Text(
                                  isEditing
                                      ? "حفظ التعديلات"
                                      : "حفظ القسم الجديد",
                                  style: AppTextStyle.font18.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                        16.verticalSpace,
                        OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: AppColors.greyDark,
                              width: 1.5,
                            ),
                            minimumSize: Size(double.infinity, 56.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                          child: Text(
                            "إلغاء",
                            style: AppTextStyle.font18.copyWith(
                              color: AppColors.greyDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        40.verticalSpace,
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
