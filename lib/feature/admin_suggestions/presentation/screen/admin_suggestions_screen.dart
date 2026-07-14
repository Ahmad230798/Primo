// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/di/service_locator.dart';
import 'package:primo/core/helper/navigation.dart';
import 'package:primo/core/helper/snack_bar_helper.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/admin_drawer.dart';
import 'package:primo/core/widgets/app_error_widget.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';
import 'package:primo/feature/admin_home/data/models/admin_dashboard_model.dart';
import 'package:primo/feature/profile/presentation/cubit/profile_cubit.dart';

import '../cubit/admin_suggestions_cubit.dart';
import '../cubit/admin_suggestions_state.dart';
import '../widgets/suggestion_item_card.dart';
import '../widgets/suggestions_filter_tabs.dart';

class AdminSuggestionsScreen extends StatelessWidget {
  const AdminSuggestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<AdminSuggestionsCubit>()..getSuggestions(),
        ),
        BlocProvider(create: (context) => getIt<ProfileCubit>()),
      ],
      child: Scaffold(
        backgroundColor: AppColors.white,
        drawer: const AdminDrawer(currentRoute: Routes.adminSuggestions),
        body: SafeArea(
          child: BlocConsumer<AdminSuggestionsCubit, AdminSuggestionsState>(
            listener: (context, state) {
              if (state is AdminSuggestionStatusSuccess) {
                context.showSuccess(state.message);
              } else if (state is AdminSuggestionsError) {
                context.showError(state.errorMessage);
              }
            },
            builder: (context, state) {
              final cubit = context.read<AdminSuggestionsCubit>();

              // 💡 التعديل هنا: إذا كانت الحالة المحملة جاهزة، خذ القائمة المفلترة منها، وإلا اعتمد قائمة الكيوبت كخيار احتياطي
              List<SuggestionModel> suggestions = cubit.allSuggestions;
              if (state is AdminSuggestionsLoaded) {
                suggestions = state
                    .suggestions; // (تأكد من اسم متغير القائمة داخل الـ State الخاص بك، غالباً اسمه suggestions)
              }
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: CustomAppBar(
                      title: "مقترحات الزبائن",
                      suffixsIcon: InkWell(
                        onTap: () =>
                            Navigator.pushNamed(context, Routes.notifications),
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
                        size: 26.sp,
                      ),
                      showRightIcon: true,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        16.verticalSpace,
                        SuggestionsFilterTabs(
                          currentTab: cubit.currentTab,
                          onTabChanged: (tabKey) {
                            cubit.filterSuggestions(tabKey);
                          },
                        ),
                        24.verticalSpace,
                        Expanded(
                          child: _buildSuggestionsList(
                            context,
                            state,
                            suggestions,
                            cubit,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionsList(
    BuildContext context,
    AdminSuggestionsState state,
    List<SuggestionModel> dynamicSuggestions,
    AdminSuggestionsCubit cubit,
  ) {
    if (state is AdminSuggestionsLoading && dynamicSuggestions.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    } else if (state is AdminSuggestionsError && dynamicSuggestions.isEmpty) {
      return AppErrorWidget(
        message: state.errorMessage,
        onRetry: () => cubit.getSuggestions(),
      );
    }

    if (dynamicSuggestions.isEmpty) {
      return Center(
        child: Text(
          "لا توجد مقترحات حالياً",
          style: AppTextStyle.font16.copyWith(
            color: AppColors.greyDark,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => cubit.getSuggestions(),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        itemCount: dynamicSuggestions.length,
        separatorBuilder: (context, index) => 16.verticalSpace,
        itemBuilder: (context, index) {
          final item = dynamicSuggestions[index];

          // 💡 1. استخراج بيانات الزبون بشكل صحيح من كائن الـ user الداخلي
          final user = item.user;
          final realCustomerName = user?.name ?? "عميل بريمو";

          // 💡 2. أخذ الحرف الأول من اسم الزبون (وليس اسم المنتج)
          final firstChar = realCustomerName.trim().isNotEmpty
              ? realCustomerName.trim()[0]
              : "ع";

          // 💡 3. معالجة التاريخ ليعرض اليوم والشهر والسنة فقط
          String displayDate = "حديث";
          if (item.createdAt != null && item.createdAt!.trim().isNotEmpty) {
            try {
              final parsedDate = DateTime.parse(item.createdAt!);
              displayDate =
                  "${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}";
            } catch (e) {
              displayDate = item.createdAt!.split('T').first.split(' ').first;
            }
          }
          return Stack(
            children: [
              SuggestionItemCard(
                customerName: realCustomerName,
                customerType: "زبون بريمو",
                avatarLetter: firstChar,
                date: displayDate,
                suggestionTitle: item.name ?? "منتج مقترح",
                suggestionText:
                    '"${item.description ?? 'لا يوجد تفاصيل إضافية'}"',
                onAccept: () {
                  context.pushNamed(Routes.addProducts);
                  cubit.updateStatus(item.id, "rejected");
                },
                onIgnore: () {
                  cubit.updateStatus(item.id, "rejected");
                },
              ),
              if (state is AdminSuggestionUpdating &&
                  state.suggestionId == item.id)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
