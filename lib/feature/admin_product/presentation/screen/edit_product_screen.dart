import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/helper/snack_bar_helper.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';
import '../cubit/admin_product_cubit.dart';
import '../cubit/admin_product_state.dart';
import '../cubit/admin_products_list_cubit.dart';
import '../widgets/edit_image_section.dart';
import '../widgets/edit_product_form.dart';

class EditProductScreen extends StatelessWidget {
  const EditProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AdminProductCubit>();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: BlocConsumer<AdminProductCubit, AdminProductState>(
          listenWhen: (prev, current) =>
              current is AdminProductSuccess || current is AdminProductError,
          listener: (context, state) {
            if (state is AdminProductError) {
              context.showError(state.error);
            } else if (state is AdminProductSuccess) {
              context.showSuccess(state.message);
              try {
                context.read<AdminProductsListCubit>().getProducts();
              } catch (_) {}
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: CustomAppBar(
                    title: "تعديل بيانات المنتج",
                    suffixsIcon: Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColors.textMain,
                      size: 26.sp,
                    ),
                    showRightIcon: false,
                    onBackTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        24.verticalSpace,
                        const EditImageSection(),
                        24.verticalSpace,
                        const EditProductForm(),
                        32.verticalSpace,
                        ElevatedButton(
                          onPressed: () {
                            cubit.updateProduct();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            elevation: 0,
                            minimumSize: Size(double.infinity, 56.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                          child: state is AdminProductLoading
                              ? const CircularProgressIndicator(
                                  color: AppColors.white,
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "تحديث البيانات",
                                      style: AppTextStyle.font18.copyWith(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    8.horizontalSpace,
                                    Icon(
                                      Icons.save_outlined,
                                      color: AppColors.white,
                                      size: 24.sp,
                                    ),
                                  ],
                                ),
                        ),
                        16.verticalSpace,
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () {
                              if (cubit.editingProductId != null) {
                                try {
                                  context
                                      .read<AdminProductsListCubit>()
                                      .deleteProduct(cubit.editingProductId!);
                                } catch (_) {}
                                Navigator.pop(context);
                              }
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 8.h,
                              ),
                              foregroundColor: AppColors.primary,
                            ),
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              size: 20.sp,
                            ),
                            label: Text(
                              "حذف المنتج نهائياً",
                              style: AppTextStyle.font14.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
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
