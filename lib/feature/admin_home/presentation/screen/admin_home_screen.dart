import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/widgets/admin_drawer.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';
import 'package:primo/feature/admin_home/presentation/cubit/admin_dashboard_cubit.dart';
import 'package:primo/feature/admin_home/presentation/cubit/admin_dashboard_state.dart';

import '../widgets/admin_stats_section.dart';
import '../widgets/customer_suggestions_section.dart';
import '../widgets/incoming_orders_section.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const AdminDrawer(currentRoute: Routes.adminHome),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(
                  title: "Primo",
                  suffixsIcon: Icon(
                    Icons.notifications_none_rounded,
                    color: AppColors.primary,
                    size: 28.sp,
                  ),
                  icon: Icon(
                    Icons.menu_rounded,
                    color: AppColors.greyDark,
                    size: 28.sp,
                  ),
                  showRightIcon: true,
                  onBackTap: () {
                    Navigator.pushNamed(context, Routes.notifications);
                  },
                ),
                16.verticalSpace,
                BlocBuilder<AdminDashboardCubit, AdminDashboardState>(
                  builder: (context, state) {
                    if (state is AdminDashboardLoading) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 60.h),
                        child: const Center(
                          child: CircularProgressIndicator(color: AppColors.primary),
                        ),
                      );
                    } else if (state is AdminDashboardLoaded) {
                      final dash = state.dashboard;
                      return Column(
                        children: [
                          AdminStatsSection(
                            totalAmount: dash.totalAmount,
                            pendingOrdersCount: dash.pendingOrdersCount,
                            productsCount: dash.productsCount,
                          ),
                          32.verticalSpace,
                          IncomingOrdersSection(orders: dash.pendingOrders),
                          32.verticalSpace,
                          CustomerSuggestionsSection(suggestions: dash.pendingSuggestions),
                        ],
                      );
                    }
                    return Column(
                      children: [
                        const AdminStatsSection(),
                        32.verticalSpace,
                        const IncomingOrdersSection(),
                        32.verticalSpace,
                        const CustomerSuggestionsSection(),
                      ],
                    );
                  },
                ),
                100.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
