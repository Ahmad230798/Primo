// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/di/service_locator.dart';
import 'package:primo/core/helper/snack_bar_helper.dart';
import 'package:primo/core/models/order_model.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/admin_drawer.dart';
import 'package:primo/core/widgets/app_error_widget.dart';
import '../cubit/admin_orders_cubit.dart';
import '../cubit/admin_orders_state.dart';
import '../widgets/incoming_order_card.dart';
import '../widgets/orders_tab_bar.dart';

class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AdminOrdersCubit>()..getOrders(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        drawer: const AdminDrawer(currentRoute: Routes.adminOrders),
        body: SafeArea(
          child: BlocConsumer<AdminOrdersCubit, AdminOrdersState>(
            listener: (context, state) {
              if (state is AdminOrderStatusSuccess) {
                context.showSuccess(state.message);
              } else if (state is AdminOrdersError) {
                context.showError(state.errorMessage);
              }
            },
            builder: (context, state) {
              final cubit = context.read<AdminOrdersCubit>();
              final orders = cubit.allOrders;
              final activeCount = orders
                  .where((o) =>
                      o.status.toLowerCase() != 'completed' &&
                      o.status.toLowerCase() != 'delivered' &&
                      o.status != 'مكتمل')
                  .length;

              return Column(
                children: [
                  // الهيدر المخصص
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 24.w, vertical: 16.h),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border(
                        bottom: BorderSide(
                            color: AppColors.formBorder, width: 1),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(99.r),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            "$activeCount نشط",
                            style: AppTextStyle.font12.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ),
                        Text(
                          "إدارة الطلبات",
                          style: AppTextStyle.font18.copyWith(
                            color: AppColors.textMain,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Builder(
                          builder: (innerContext) => InkWell(
                            onTap: () => Scaffold.of(innerContext).openDrawer(),
                            borderRadius: BorderRadius.circular(99.r),
                            child: Padding(
                              padding: EdgeInsets.all(4.w),
                              child: Icon(
                                Icons.menu_rounded,
                                color: AppColors.textMain,
                                size: 28.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // شريط التبويبات (Tabs)
                  OrdersTabBar(
                    activeFilter: cubit.currentFilter,
                    onFilterChanged: (newFilter) {
                      cubit.filterOrdersByStatus(newFilter);
                    },
                  ),

                  // قائمة الطلبات
                  Expanded(
                    child: _buildOrdersList(context, state, orders, cubit),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildOrdersList(
    BuildContext context,
    AdminOrdersState state,
    List<OrderModel> orders,
    AdminOrdersCubit cubit,
  ) {
    if (state is AdminOrdersLoading && orders.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    } else if (state is AdminOrdersError && orders.isEmpty) {
      return AppErrorWidget(
        message: state.errorMessage,
        onRetry: () => cubit.getOrders(status: cubit.currentFilter),
      );
    }

    if (orders.isEmpty) {
      return Center(
        child: Text(
          "لا توجد طلبات مطابقة حالياً",
          style: AppTextStyle.font16.copyWith(
            color: AppColors.greyDark,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => cubit.getOrders(status: cubit.currentFilter),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        itemCount: orders.length,
        separatorBuilder: (context, index) => 16.verticalSpace,
        itemBuilder: (context, index) {
          final order = orders[index];
          final st = order.status.toLowerCase();
          final isPending = st == 'pending' || order.status == 'قيد الانتظار';
          final customerName = order.user?.name ?? order.address?.name ?? "عميل بريمو #${order.userId}";
          final firstLetter = customerName.trim().isNotEmpty
              ? customerName.trim()[0]
              : "ز";

          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.orderDetails,
                arguments: order,
              );
            },
            child: Stack(
              children: [
                IncomingOrderCard(
                  isDelayed: isPending,
                  orderId: "طلب #${order.id}",
                  timeText: order.formattedDate.isNotEmpty
                      ? order.formattedDate
                      : (order.createdAt ?? ""),
                  customerName: customerName,
                  customerPhone: order.user?.phone,
                  customerAvatarLetter: firstLetter,
                  orderType: order.isDelivery ? "توصيل" : "استلام من الفرع",
                  totalPrice: "${order.totalAmount} ل.س",
                  onStatusUpdate: () => _showStatusPicker(context, cubit, order),
                  onActionTap: () {
                    final nextStatus = isPending ? 'processing' : 'completed';
                    cubit.updateOrderStatus(order.id, nextStatus);
                  },
                  onRejectTap: () {
                    cubit.updateOrderStatus(order.id, 'canceled');
                  },
                ),
                if (state is AdminOrderStatusUpdating && state.orderId == order.id)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(color: AppColors.primary),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showStatusPicker(
      BuildContext context, AdminOrdersCubit cubit, OrderModel order) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (ctx) {
        return Container(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "تغيير حالة الطلب #${order.id}",
                style: AppTextStyle.font18.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              20.verticalSpace,
              _buildStatusOption(
                ctx,
                "قيد الانتظار",
                'pending',
                order.status,
                () {
                  Navigator.pop(ctx);
                  cubit.updateOrderStatus(order.id, 'pending');
                },
              ),
              12.verticalSpace,
              _buildStatusOption(
                ctx,
                "قيد التجهيز",
                'processing',
                order.status,
                () {
                  Navigator.pop(ctx);
                  cubit.updateOrderStatus(order.id, 'processing');
                },
              ),
              12.verticalSpace,
              _buildStatusOption(
                ctx,
                "مكتمل / تم التسليم",
                'completed',
                order.status,
                () {
                  Navigator.pop(ctx);
                  cubit.updateOrderStatus(order.id, 'completed');
                },
              ),
              12.verticalSpace,
              _buildStatusOption(
                ctx,
                "ملغي / مرفوض",
                'canceled',
                order.status,
                () {
                  Navigator.pop(ctx);
                  cubit.updateOrderStatus(order.id, 'canceled');
                },
              ),
              16.verticalSpace,
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusOption(BuildContext ctx, String label, String value,
      String current, VoidCallback onTap) {
    final isSelected = current.toLowerCase() == value;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.formBorder,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextStyle.font16.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textMain,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
