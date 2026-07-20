import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/custom_error_retry_widget.dart';
import 'package:primo/feature/home/presentation/cubit/home_cubit.dart';
import 'package:primo/feature/home/presentation/cubit/home_state.dart';
import 'package:primo/feature/home/presentation/widgets/catigory_chip.dart';

import 'package:primo/core/widgets/app_shimmer_skeletons.dart';

class CatigorySection extends StatelessWidget {
  const CatigorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return SizedBox(
            height: 105.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: 5,
              separatorBuilder: (context, index) => 12.horizontalSpace,
              itemBuilder: (context, index) => const CategoryShimmer(),
            ),
          );
        } else if (state is HomeLoaded) {
          if (state.data.categories.isEmpty) {
            return Center(
              child: Text(
                "لا توجد تصنيفات متاحة حالياً",
                style: AppTextStyle.font14.copyWith(
                  color: AppColors.greyMedium3,
                ),
              ),
            );
          }
          final cats = state.data.categories;
          return CarouselSlider(
            options: CarouselOptions(
              height: 105.h,
              enableInfiniteScroll: true,
              padEnds: false,
              viewportFraction: 0.25,
              enlargeCenterPage: false,
            ),
            items: cats.map((cat) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: CatigoryChip(
                  text: cat.name ?? "قسم",
                  imageUrl: cat.fullImageUrl,
                  onTap: () => Navigator.pushNamed(
                    context,
                    Routes.categoryProducts,
                    arguments: cat,
                  ),
                ),
              );
            }).toList(),
          );
        } else if (state is HomeError) {
          return CustomErrorRetryWidget(
            message: state.errorMessage,
            onRetry: () => context.read<HomeCubit>().getHomeData(isRefresh: true),
          );
        }
        return const SizedBox();
      },
    );
  }
}
