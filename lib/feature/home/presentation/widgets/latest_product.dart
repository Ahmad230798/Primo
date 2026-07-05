import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/feature/home/presentation/cubit/home_cubit.dart';
import 'package:primo/feature/home/presentation/cubit/home_state.dart';
import 'package:primo/feature/home/presentation/widgets/product_card.dart';

class LatestProduct extends StatelessWidget {
  const LatestProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 40.h),
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        } else if (state is HomeLoaded) {
          if (state.data.products.isEmpty) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 40.h),
              child: Center(
                child: Text(
                  "سيتم إضافة منتجات قريباً",
                  style: AppTextStyle.font14.copyWith(color: AppColors.greyMedium2),
                ),
              ),
            );
          }
          final products = state.data.products;
          return GridView.builder(
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.39.h,
              childAspectRatio: 0.6,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return ProductCard(product: products[index]);
            },
          );
        } else if (state is HomeError) {
          return Center(child: Text(state.errorMessage));
        }
        return const SizedBox();
      },
    );
  }
}
