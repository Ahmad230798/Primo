import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/helper/snack_bar_helper.dart';
import 'package:primo/core/models/order_model.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/feature/admin_orders/presentation/cubit/admin_orders_cubit.dart';
import 'package:primo/feature/admin_orders/presentation/cubit/admin_orders_state.dart';
import 'package:primo/feature/admin_orders/presentation/widgets/cost_summary_card.dart';
import 'package:primo/feature/admin_orders/presentation/widgets/customer_info_card.dart';
import 'package:primo/feature/admin_orders/presentation/widgets/order_status_tracker.dart';
import 'package:primo/feature/admin_orders/presentation/widgets/ordered_items_list.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel? orderArg;
  const OrderDetailsScreen({super.key, this.orderArg});

  @override
  Widget build(BuildContext context) {
    // نحتفظ بالطلب المبدئي القادم من الشاشة السابقة
    OrderModel? screenOrder = orderArg;

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
                // 💡 1. الجدار العازل: هذا البيلدر لن يتحدث أبداً إلا إذا جاءت التفاصيل العميقة
                child: BlocBuilder<AdminOrdersCubit, AdminOrdersState>(
                  buildWhen: (previous, current) {
                    // السحر هنا: لا تقم بتحديث الشاشة بالكامل إلا إذا استلمت تفاصيل الطلب!
                    // أي حالة أخرى (تحديث زر، جلب قائمة) سيتم رفضها وتتجمّد الشاشة على آخر بيانات.
                    return current is AdminOrderDetailsLoaded;
                  },
                  builder: (context, mainState) {
                    // إذا وصلت التفاصيل، نقوم بتحديث المتغير المحلي
                    if (mainState is AdminOrderDetailsLoaded) {
                      screenOrder = mainState.order;
                    }

                    // اللودينغ الكبير يظهر فقط إذا لم تكن المنتجات متوفرة بعد
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
                          // 💡 هذه الودجتس ستستخدم البيانات المجمدة ولن تختفي أبداً
                          CustomerInfoCard(order: screenOrder),
                          24.verticalSpace,

                          // 💡 2. بيلدر الزر: بدون buildWhen لكي يلتقط حالة الـ Updating فوراً ويمنع الفريز
                          BlocBuilder<AdminOrdersCubit, AdminOrdersState>(
                            builder: (context, statusState) {
                              OrderModel? orderForStatus = screenOrder;

                              // تحديث رقم الحالة للزر فقط في حال جلب القائمة الجديدة
                              if (statusState is AdminOrdersLoaded) {
                                try {
                                  orderForStatus = statusState.orders
                                      .firstWhere(
                                        (o) => o.id == screenOrder?.id,
                                      );
                                } catch (_) {}
                              }

                              // 💡 استخراج حالة التحميل بدقة للزر المخصص فقط
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
