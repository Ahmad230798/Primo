import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/di/service_locator.dart';
import 'package:primo/core/helper/snack_bar_helper.dart';
import 'package:primo/core/models/order_model.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/app_button.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';
import 'package:primo/feature/cart/presentation/cubit/cart_cubit.dart';
import 'package:primo/feature/orders/presentation/bloc/orders_cubit.dart';
import 'package:primo/feature/orders/presentation/bloc/orders_state.dart';
import 'package:primo/feature/orders/presentation/widgets/build_summary_row.dart';
import 'package:primo/feature/orders/presentation/widgets/order_info_card.dart';
import 'package:primo/feature/orders/presentation/widgets/order_item_card.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel? orderArg; // استقبال البيانات هنا
  const OrderDetailsScreen({super.key, this.orderArg});

  @override
  Widget build(BuildContext context) {
    final passedOrder =
        orderArg ?? ModalRoute.of(context)?.settings.arguments as OrderModel?;
    return BlocProvider(
      create: (_) => getIt<OrdersCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: BlocConsumer<OrdersCubit, OrdersState>(
            listener: (context, state) {
              if (state is OrderRatingSuccess) {
                context.showSuccess(state.message);
              } else if (state is OrdersError) {
                context.showError(state.errorMessage);
              }
            },
            builder: (context, state) {
              OrderModel? order = passedOrder;
              if (state is SingleOrderLoaded) {
                order = state.order;
              }

              if (state is OrdersLoading && order == null) {
                return const Center(child: CircularProgressIndicator());
              }

              if (order == null) {
                return Center(
                  child: Text(
                    "لم يتم العثور على تفاصيل الطلب",
                    style: AppTextStyle.font18,
                  ),
                );
              }

              final isCompleted =
                  order.status.toLowerCase() == 'completed' ||
                  order.status.toLowerCase() == 'delivered';

              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: CustomAppBar(
                      title: "تفاصيل الطلب #${order.id}",
                      showRightIcon: true,
                      icon: Icon(
                        Icons.shopping_bag_outlined,
                        color: AppColors.textMain,
                        size: 28.sp,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 20.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          OrderInfoCard(order: order),
                          24.verticalSpace,
                          Text(
                            "المنتجات (${order.items.length})",
                            style: AppTextStyle.font16.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textMain,
                            ),
                          ),
                          16.verticalSpace,
                          ListView.builder(
                            itemCount: order.items.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final item = order!.items[index];
                              return OrderItemCard(
                                item: item,
                                showRating: isCompleted,
                                onRate: (rating) {
                                  context.read<OrdersCubit>().rateProduct(
                                    item.id,
                                    order!.id,
                                    rating,
                                  );
                                },
                              );
                            },
                          ),
                          24.verticalSpace,
                          Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: AppColors.formBorder.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            child: Column(
                              children: [
                                BuildSummaryRow(
                                  title: "المجموع الفرعي",
                                  value: "${order.amount} ل.س",
                                ),
                                12.verticalSpace,
                                BuildSummaryRow(
                                  title: "رسوم التوصيل",
                                  value: "${order.deliveryAmount} ل.س",
                                ),
                                16.verticalSpace,
                                Divider(
                                  color: AppColors.formBorder,
                                  thickness: 1,
                                ),
                                16.verticalSpace,
                                BuildSummaryRow(
                                  title: "الإجمالي",
                                  value: "${order.totalAmount} ل.س",
                                  isTotal: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: 24.w,
                      right: 24.w,
                      bottom: 24.h,
                      top: 16.h,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.background,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppButton(
                          text: "تتبع حالة الطلب",
                          icon: Icons.map_outlined,
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              Routes.orderTracking,
                              arguments: order,
                            );
                          },
                        ),
                        12.verticalSpace,
                        AppButton(
                          text: "إعادة طلب هذه المنتجات",
                          icon: Icons.add_shopping_cart,
                          onPressed: () {
                            for (final item in order!.items) {
                              getIt<CartCubit>().addToCart(
                                item.id,
                                item.quantity,
                              );
                            }
                            context.showSuccess(
                              "تم إضافة المنتجات لسلة المشتريات",
                            );
                            Navigator.pushNamed(context, Routes.cart);
                          },
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
}
