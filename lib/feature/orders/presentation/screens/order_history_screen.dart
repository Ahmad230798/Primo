import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/di/service_locator.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';
import 'package:primo/feature/orders/presentation/bloc/orders_cubit.dart';
import 'package:primo/feature/orders/presentation/bloc/orders_state.dart';
import 'package:primo/feature/orders/presentation/widgets/order_history_card.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OrdersCubit>()..getOrders(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: CustomAppBar(
                  title: "Primo",
                  showRightIcon: true,
                  icon: Icon(
                    Icons.notifications_none,
                    color: AppColors.textMain,
                    size: 26.sp,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "سجل الطلبات",
                      style: AppTextStyle.font24.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.textMain,
                      ),
                    ),
                    Builder(
                      builder: (context) => InkWell(
                        onTap: () => _showFilterOptions(context),
                        child: Row(
                          children: [
                            Text(
                              "تصفية",
                              style: AppTextStyle.font14.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.greyMedium1,
                              ),
                            ),
                            4.horizontalSpace,
                            Icon(
                              Icons.filter_list,
                              color: AppColors.greyMedium1,
                              size: 20.sp,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<OrdersCubit, OrdersState>(
                  builder: (context, state) {
                    if (state is OrdersLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is OrdersError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.errorMessage,
                              style: AppTextStyle.font16.copyWith(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            16.verticalSpace,
                            ElevatedButton(
                              onPressed: () => context.read<OrdersCubit>().getOrders(),
                              child: const Text("إعادة المحاولة"),
                            ),
                          ],
                        ),
                      );
                    }

                    final orders = context.read<OrdersCubit>().currentOrders;

                    if (orders.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              size: 80.sp,
                              color: AppColors.greyMedium2,
                            ),
                            16.verticalSpace,
                            Text(
                              "لا توجد طلبات سابقة",
                              style: AppTextStyle.font20.copyWith(
                                color: AppColors.greyMedium2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return OrderHistoryCard(
                          order: order,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.orderDetailsScreen,
                              arguments: order,
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "تصفية حسب الحالة",
                style: AppTextStyle.font18.copyWith(fontWeight: FontWeight.bold),
              ),
              16.verticalSpace,
              ListTile(
                title: const Text("الكل"),
                onTap: () {
                  Navigator.pop(context);
                  context.read<OrdersCubit>().getOrders(status: 'all');
                },
              ),
              ListTile(
                title: const Text("تم التسليم / مكتمل"),
                onTap: () {
                  Navigator.pop(context);
                  context.read<OrdersCubit>().getOrders(status: 'completed');
                },
              ),
              ListTile(
                title: const Text("قيد التجهيز"),
                onTap: () {
                  Navigator.pop(context);
                  context.read<OrdersCubit>().getOrders(status: 'processing');
                },
              ),
              ListTile(
                title: const Text("قيد الانتظار"),
                onTap: () {
                  Navigator.pop(context);
                  context.read<OrdersCubit>().getOrders(status: 'pending');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
