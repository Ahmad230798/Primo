import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          final cats = state.data.categories.take(4).toList();
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: cats.map((cat) {
              return CatigoryChip(
                text: cat.name ?? "قسم",
                imageUrl: cat.fullImageUrl,
                onTap: () => Navigator.pushNamed(
                  context,
                  Routes.categoryProducts,
                  arguments: cat,
                ),
              );
            }).toList(),
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
