import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/helper/snack_bar_helper.dart';
import 'package:primo/core/models/order_model.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/custom_error_retry_widget.dart';
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
    // 💡 هذا المتغير سيحفظ البيانات محلياً ويمنع الشاشة من الوميض
    OrderModel? screenOrder = orderArg;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocListener<AdminOrdersCubit, AdminOrdersState>(
          listener: (context, state) {
            
            // 💡 هنا نعرض رسائل النجاح أو الخطأ فقط (بدون أي استدعاء لأي دوال)
            if (state is AdminOrderStatusSuccess) {
              context.showSuccess(state.message);
            } else if (state is AdminOrdersError) {
              context.showError(state.errorMessage);
            }
          },
          child: Column(
            children: [
              // --- شريط التنقل العلوي (AppBar) ---
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

              // --- محتوى الشاشة ---
              Expanded(
                child: BlocBuilder<AdminOrdersCubit, AdminOrdersState>(
                  buildWhen: (previous, current) {
                    return current is AdminOrderDetailsLoaded ||
                        current is AdminOrdersError;
                  },
                  builder: (context, mainState) {
                    if (mainState is AdminOrderDetailsLoaded) {
                      screenOrder = mainState.order;
                    }

                    if (mainState is AdminOrdersError &&
                        (screenOrder?.items == null ||
                            screenOrder!.items.isEmpty)) {
                      return CustomErrorRetryWidget(
                        message: mainState.errorMessage,
                        onRetry: () {
                          if (orderArg?.id != null) {
                            context
                                .read<AdminOrdersCubit>()
                                .getOrderDetails(orderArg!.id);
                          }
                        },
                      );
                    }

                    if (screenOrder?.items == null ||
                        screenOrder!.items.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 24.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomerInfoCard(order: screenOrder),
                          24.verticalSpace,

                          // 💡 2. البيلدر الداخلي (الخاص بالزر فقط)
                          BlocBuilder<AdminOrdersCubit, AdminOrdersState>(
                            builder: (context, statusState) {
                              OrderModel? orderForStatus = screenOrder;

                              if (statusState is AdminOrdersLoaded) {
                                try {
                                  orderForStatus = statusState.orders
                                      .firstWhere(
                                        (o) => o.id == screenOrder?.id,
                                      );
                                } catch (_) {}
                              }

                              // استخراج حالة اللودينغ بدقة لهذا الزر
                              final isButtonLoading =
                                  statusState is AdminOrderStatusUpdating &&
                                  statusState.orderId == screenOrder?.id;

                              return OrderStatusTracker(
                                order: orderForStatus,
                                isLoading: isButtonLoading,
                                onUpdateStatus: (newStatus) {
                                  if (screenOrder?.id != null) {
                                    context
                                        .read<AdminOrdersCubit>()
                                        .updateOrderStatus(
                                          screenOrder!.id,
                                          newStatus,
                                        );
                                  }
                                },
                              );
                            },
                          ),

                          24.verticalSpace,
                          OrderedItemsList(items: screenOrder?.items),
                          24.verticalSpace,
                          CostSummaryCard(order: screenOrder),
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
