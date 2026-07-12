import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/admin_drawer.dart';
import 'package:primo/core/widgets/app_empty_state.dart';
import 'package:primo/core/widgets/app_error_widget.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';
import '../cubit/admin_category_cubit.dart';
import '../cubit/admin_categories_list_cubit.dart';
import '../cubit/admin_categories_list_state.dart';
import '../widgets/category_card.dart';

class AdminCategoriesScreen extends StatefulWidget {
  const AdminCategoriesScreen({super.key});

  @override
  State<AdminCategoriesScreen> createState() => _AdminCategoriesScreenState();
}

class _AdminCategoriesScreenState extends State<AdminCategoriesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminCategoriesListCubit>().getCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const AdminDrawer(currentRoute: Routes.adminCategories),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<AdminCategoryCubit>().clearForAdd();
          Navigator.pushNamed(context, Routes.addCategory);
        },
        backgroundColor: AppColors.primary,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Icon(Icons.add_rounded, color: AppColors.white, size: 32.sp),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: CustomAppBar(
                title: "Primo",
                suffixsIcon: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.notifications);
                  },
                  borderRadius: BorderRadius.circular(99.r),
                  child: Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Icon(
                      Icons.notifications_none_rounded,
                      color: AppColors.textMain,
                      size: 28.sp,
                    ),
                  ),
                ),
                icon: Icon(
                  Icons.menu_rounded,
                  color: AppColors.textMain,
                  size: 28.sp,
                ),
                showRightIcon: true,
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async {
                  await context.read<AdminCategoriesListCubit>().getCategories();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      24.verticalSpace,
                      Text(
                        "إدارة الأقسام",
                        style: AppTextStyle.font30.copyWith(
                          color: AppColors.textMain,
                        ),
                      ),
                      4.verticalSpace,
                      Text(
                        "تحكم في فئات المنتجات، التعديل والإضافة.",
                        style: AppTextStyle.font14.copyWith(
                          color: AppColors.greyMedium3,
                        ),
                      ),
                      32.verticalSpace,
                      BlocBuilder<AdminCategoriesListCubit, AdminCategoriesListState>(
                        builder: (context, state) {
                          if (state is AdminCategoriesListLoading) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.all(40.h),
                                child: const CircularProgressIndicator(
                                  color: AppColors.primary,
                                ),
                              ),
                            );
                          } else if (state is AdminCategoriesListError) {
                            return AppErrorWidget(
                              message: state.message,
                              onRetry: () => context.read<AdminCategoriesListCubit>().getCategories(),
                            );
                          }

                          final categories = context.read<AdminCategoriesListCubit>().categories;

                          if (categories.isEmpty) {
                            return AppEmptyState(
                              icon: Icons.category_outlined,
                              message: "لا توجد أقسام حالياً",
                              onRetry: () => context.read<AdminCategoriesListCubit>().getCategories(),
                            );
                          }

                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: categories.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16.w,
                              mainAxisSpacing: 16.h,
                              childAspectRatio: 0.75,
                            ),
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              return CategoryCard(
                                title: category.name ?? "قسم",
                                imagePath: category.image ?? "assets/images/honey.png",
                                onEdit: () {
                                  context.read<AdminCategoryCubit>().initForEdit(category);
                                  Navigator.pushNamed(
                                    context,
                                    Routes.addCategory,
                                    arguments: category,
                                  );
                                },
                                onDelete: () {
                                  if (category.id != null) {
                                    context.read<AdminCategoriesListCubit>().deleteCategory(category.id!);
                                  }
                                },
                              );
                            },
                          );
                        },
                      ),
                      100.verticalSpace,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
