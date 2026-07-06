import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';
import 'package:primo/feature/categories/presentation/cubit/user_categories_cubit.dart';
import 'package:primo/feature/categories/presentation/cubit/user_categories_state.dart';
import 'package:primo/feature/categories/presentation/widgets/category_grid_card.dart';

class AllCategoriesScreen extends StatelessWidget {
    final bool isFromBottomNav;
  const AllCategoriesScreen({super.key, required this.isFromBottomNav});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: CustomAppBar(
                title: "تصفح أقسام Primo",
               suffixsIcon: isFromBottomNav ? const SizedBox() : null,
                // showRightIcon: true,
                icon: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.searchResults);
                  },
                  child: Icon(
                    Icons.search,
                    color: AppColors.textMain,
                    size: 26.sp,
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<UserCategoriesCubit, UserCategoriesState>(
                builder: (context, state) {
                  if (state is UserCategoriesLoading ||
                      state is UserCategoriesInitial) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  } else if (state is UserCategoriesLoaded) {
                    final categories = state.categories;
                    if (categories.isEmpty) {
                      return Center(
                        child: Text(
                          "لا يوجد أقسام حالياً",
                          style: AppTextStyle.font16.copyWith(
                            color: AppColors.greyMedium2,
                          ),
                        ),
                      );
                    }
                    return GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 20.h,
                      ),
                      itemCount: categories.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.w,
                        mainAxisSpacing: 16.h,
                        childAspectRatio: 0.95,
                      ),
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return CategoryGridCard(
                          title: category.name ?? "قسم",
                          imagePath: category.fullImageUrl ?? "",
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.categoryProducts,
                              arguments: category,
                            );
                          },
                        );
                      },
                    );
                  } else if (state is UserCategoriesError) {
                    return Center(child: Text(state.errorMessage));
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
