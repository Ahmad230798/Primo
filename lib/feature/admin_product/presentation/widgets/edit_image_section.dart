// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/app_cached_network_image.dart';
import '../cubit/admin_product_cubit.dart';
import '../cubit/admin_product_state.dart';

class EditImageSection extends StatelessWidget {
  const EditImageSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AdminProductCubit>();

    return BlocBuilder<AdminProductCubit, AdminProductState>(
      buildWhen: (prev, current) => current is AdminProductUIChanged,
      builder: (context, state) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            width: double.infinity,
            height: 180.h,
            color: AppColors.greyBackground,
            child: Stack(
              children: [
                Positioned.fill(
                  child: cubit.selectedImage != null
                      ? Image.file(
                          cubit.selectedImage!,
                          fit: BoxFit.cover,
                        )
                      : (cubit.existingImageUrl != null &&
                              cubit.existingImageUrl!.trim().isNotEmpty)
                          ? AppCachedNetworkImage(
                              imageUrl: cubit.existingImageUrl!,
                              fit: BoxFit.cover,
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_photo_alternate_outlined,
                                    size: 40.sp,
                                    color: AppColors.greyMedium3,
                                  ),
                                  8.verticalSpace,
                                  Text(
                                    "إضافة صورة المنتج",
                                    style: AppTextStyle.font14.copyWith(
                                      color: AppColors.greyMedium3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                ),
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.05),
                  ),
                ),
              Positioned(
                bottom: 12.h,
                left: 12.w,
                child: InkWell(
                  onTap: () {
                    cubit.pickImage();
                  },
                  borderRadius: BorderRadius.circular(99.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(99.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Text(
                          "تغيير الصورة",
                          style: AppTextStyle.font12.copyWith(
                            color: AppColors.textMain,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        6.horizontalSpace,
                        Icon(
                          Icons.camera_alt_outlined,
                          color: AppColors.textMain,
                          size: 16.sp,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
}
