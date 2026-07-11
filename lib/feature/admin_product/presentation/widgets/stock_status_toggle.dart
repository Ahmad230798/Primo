// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import '../cubit/admin_product_cubit.dart';
import '../cubit/admin_product_state.dart';

class StockStatusToggle extends StatelessWidget {
  const StockStatusToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AdminProductCubit>();

    return BlocBuilder<AdminProductCubit, AdminProductState>(
      buildWhen: (prev, current) => current is AdminProductUIChanged,
      builder: (context, state) {
        final isAvailable = cubit.isActive == 1;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.formBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "حالة المخزون",
                      style: AppTextStyle.font16.copyWith(
                        color: AppColors.textMain,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    4.verticalSpace,
                    Text(
                      "تحديد ما إذا كان المنتج متوفراً للبيع",
                      style: AppTextStyle.font12.copyWith(
                        color: AppColors.greyMedium3,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  cubit.isActive = isAvailable ? 0 : 1;
                  cubit.addVariant();
                  cubit.variants.removeLast();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 50.w,
                  height: 28.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(99.r),
                    color:
                        isAvailable
                            ? const Color(0xFF2563EB)
                            : AppColors.greyLight,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeIn,
                        left: isAvailable ? 4.w : 22.w,
                        right: isAvailable ? 22.w : 4.w,
                        child: Container(
                          width: 22.w,
                          height: 22.w,
                          decoration: const BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                          ),
                          child:
                              isAvailable
                                  ? Icon(
                                    Icons.check_rounded,
                                    color: const Color(0xFF2563EB),
                                    size: 16.sp,
                                  )
                                  : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
