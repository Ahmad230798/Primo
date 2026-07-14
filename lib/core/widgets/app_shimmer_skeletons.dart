import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/widgets/app_shimmer.dart';

class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: AppShimmerPlaceholder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          12.verticalSpace,
          AppShimmerPlaceholder(
            width: 100.w,
            height: 14.h,
            borderRadius: BorderRadius.circular(4.r),
          ),
          8.verticalSpace,
          AppShimmerPlaceholder(
            width: 60.w,
            height: 12.h,
            borderRadius: BorderRadius.circular(4.r),
          ),
          16.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppShimmerPlaceholder(
                width: 50.w,
                height: 16.h,
                borderRadius: BorderRadius.circular(4.r),
              ),
              AppShimmerPlaceholder(
                width: 28.w,
                height: 28.h,
                borderRadius: BorderRadius.circular(999.r),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CategoryShimmer extends StatelessWidget {
  const CategoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppShimmerPlaceholder(
          width: 70.w,
          height: 70.h,
          borderRadius: BorderRadius.circular(999.r),
        ),
        8.verticalSpace,
        AppShimmerPlaceholder(
          width: 60.w,
          height: 12.h,
          borderRadius: BorderRadius.circular(4.r),
        ),
      ],
    );
  }
}

class ListTileShimmer extends StatelessWidget {
  const ListTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          AppShimmerPlaceholder(
            width: 64.w,
            height: 64.h,
            borderRadius: BorderRadius.circular(12.r),
          ),
          16.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppShimmerPlaceholder(
                  width: 140.w,
                  height: 14.h,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                8.verticalSpace,
                AppShimmerPlaceholder(
                  width: 90.w,
                  height: 12.h,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ],
            ),
          ),
          16.horizontalSpace,
          AppShimmerPlaceholder(
            width: 50.w,
            height: 16.h,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ],
      ),
    );
  }
}
