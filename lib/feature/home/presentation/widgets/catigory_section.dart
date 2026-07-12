import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/feature/home/presentation/cubit/home_cubit.dart';
import 'package:primo/feature/home/presentation/cubit/home_state.dart';
import 'package:primo/feature/home/presentation/widgets/catigory_chip.dart';

class CatigorySection extends StatelessWidget {
  const CatigorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        } else if (state is HomeLoaded) {
          if (state.data.categories.isEmpty) {
            return Center(
              child: Text(
                "لا يوجد أقسام حالياً",
                style: AppTextStyle.font14.copyWith(
                  color: AppColors.greyMedium2,
                ),
              ),
            );
          }
          // ... داخل الـ HomeLoaded
          // 1. إزالة .take(4) لعرض كل العناصر
          final cats = state.data.categories;

          return SizedBox(
            // 💡 يجب تحديد ارتفاع للـ SizedBox لكي تعرف القائمة مساحتها
            height: 120.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal, // 💡 جعل القائمة أفقية
              padding: EdgeInsets.symmetric(
                horizontal: 24.w,
              ), // مسافة من الجوانب
              itemCount: cats.length,
              separatorBuilder: (context, index) =>
                  12.horizontalSpace, // مسافة بين العناصر
              itemBuilder: (context, index) {
                final cat = cats[index];
                return CatigoryChip(
                  text: cat.name ?? "قسم",
                  imageUrl: cat.fullImageUrl,
                  onTap: () => Navigator.pushNamed(
                    context,
                    Routes.categoryProducts,
                    arguments: cat,
                  ),
                );
              },
            ),
          );
        } else if (state is HomeError) {
          return Center(
            child: Text(
              state.errorMessage,
              style: AppTextStyle.font14.copyWith(color: AppColors.primary),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
