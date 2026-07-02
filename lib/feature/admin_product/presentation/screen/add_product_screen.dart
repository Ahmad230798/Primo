import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/helper/snack_bar_helper.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';

import '../cubit/admin_product_cubit.dart';
import '../cubit/admin_product_state.dart';
import '../widgets/image_upload_widget.dart';
import '../widgets/product_form_section.dart';
import '../widgets/product_variants_section.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<AdminProductCubit, AdminProductState>(
          listenWhen: (prev, current) =>
              current is AdminProductSuccess || current is AdminProductError,
          listener: (context, state) {
            if (state is AdminProductError) {
              context.showError(state.error);
            } else if (state is AdminProductSuccess) {
              context.showSuccess(state.message);
              Navigator.pop(context); // عودة لقائمة المخزون بعد النجاح
            }
          },
          builder: (context, state) {
            final cubit = context.read<AdminProductCubit>();

            return Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: CustomAppBar(
                        title: "إضافة منتج جديد",
                        suffixsIcon: InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            color: AppColors.textMain,
                            size: 26.sp,
                          ),
                        ),
                        showRightIcon:
                            false, // لا نحتاج جرس الاشعارات هنا حسب التصميم
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            24.verticalSpace,
                            const ImageUploadWidget(),
                            24.verticalSpace,
                            const ProductFormSection(),
                            32.verticalSpace,
                            const ProductVariantsSection(),
                            140.verticalSpace,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 24.h),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          AppColors.background,
                          AppColors.background.withOpacity(0.9),
                          AppColors.transparent,
                        ],
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: state is AdminProductLoading
                          ? null
                          : () => cubit.createProduct(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 0,
                        minimumSize: Size(double.infinity, 56.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        shadowColor: AppColors.primary.withOpacity(0.5),
                      ),
                      child: state is AdminProductLoading
                          ? const CircularProgressIndicator(
                              color: AppColors.white,
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.save_outlined,
                                  color: AppColors.white,
                                  size: 24.sp,
                                ),
                                8.horizontalSpace,
                                Text(
                                  "حفظ المنتج",
                                  style: AppTextStyle.font18.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
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
