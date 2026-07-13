import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/helper/snack_bar_helper.dart';
import 'package:primo/core/models/order_model.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import '../cubit/admin_orders_cubit.dart';
import '../cubit/admin_orders_state.dart';
import '../widgets/cost_summary_card.dart';
import '../widgets/customer_info_card.dart';
import '../widgets/order_status_tracker.dart';
import '../widgets/ordered_items_list.dart';

class AdminOrderDetailsScreen extends StatelessWidget {
  final OrderModel? orderArg;
  const AdminOrderDetailsScreen({super.key, this.orderArg});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocListener<AdminOrdersCubit, AdminOrdersState>(
          listener: (context, state) {
            if (state is AdminOrderStatusSuccess) {
              context.showSuccess(state.message);
            } else if (state is AdminOrdersError) {
              context.showError(state.errorMessage);
            }
          },
          child: Column(
            children: [
              // شريط التنقل العلوي (AppBar)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  border: Border(
                    bottom: BorderSide(color: AppColors.formBorder, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(99.r),
                      child: Padding(
                        padding: EdgeInsets.all(4.w),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          color: AppColors.primary,
                          size: 24.sp,
                        ),
                      ),
                    ),
                    8.horizontalSpace,
                    Text(
                      "تفاصيل الطلب #${orderArg?.id ?? ''}",
                      style: AppTextStyle.font18.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // محتوى الشاشة
              Expanded(
                child: BlocBuilder<AdminOrdersCubit, AdminOrdersState>(
                  builder: (context, state) {
                    final cubit = context.read<AdminOrdersCubit>();
                    OrderModel? liveOrder = orderArg;
                    try {
                      if (orderArg?.id != null) {
                        liveOrder = cubit.allOrders.firstWhere(
                          (o) => o.id == orderArg!.id,
                          orElse: () => orderArg!,
                        );
                      }
                    } catch (_) {}

                    return SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 24.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomerInfoCard(order: liveOrder),
                          24.verticalSpace,

                          OrderStatusTracker(
                            order: liveOrder,
                            isLoading: state is AdminOrdersLoading,
                            onUpdateStatus: (newStatus) {
                              if (liveOrder?.id != null) {
                                context
                                    .read<AdminOrdersCubit>()
                                    .updateOrderStatus(
                                      liveOrder!.id,
                                      newStatus,
                                    );
                              }
                            },
                          ),
                          24.verticalSpace,

                          OrderedItemsList(items: liveOrder?.items),
                          24.verticalSpace,

                          CostSummaryCard(order: liveOrder),
                          40.verticalSpace,
                        ],
                      ),
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
}
