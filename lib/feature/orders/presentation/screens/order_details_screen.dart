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
import 'package:primo/feature/cart/presentation/cubit/cart_state.dart'; // تأكد من استيراد حالة السلة
import 'package:primo/feature/orders/presentation/bloc/orders_cubit.dart';
import 'package:primo/feature/orders/presentation/bloc/orders_state.dart';
import 'package:primo/feature/orders/presentation/widgets/build_summary_row.dart';
import 'package:primo/feature/orders/presentation/widgets/order_info_card.dart';
import 'package:primo/feature/orders/presentation/widgets/order_item_card.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel? orderArg;
  const OrderDetailsScreen({super.key, this.orderArg});

  @override
  Widget build(BuildContext context) {
    // 💡 جلب الطلب الممرر فقط لأخذ الـ ID منه لعنوان الشاشة
    final passedOrder =
        orderArg ?? ModalRoute.of(context)?.settings.arguments as OrderModel?;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // =========================================================
            // 1. الـ AppBar الثابت (يظهر فوراً ليعطي تجربة مستخدم سريعة)
            // =========================================================
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: CustomAppBar(
                title: "تفاصيل الطلب #${passedOrder?.id ?? ''}",
                showRightIcon: true,
                icon: Icon(
                  Icons.shopping_bag_outlined,
                  color: AppColors.textMain,
                  size: 28.sp,
                ),
              ),
            ),

            // =========================================================
            // 2. جسم الشاشة (يحتوي على الأنميشن ثم يظهر البيانات الجديدة)
            // =========================================================
            Expanded(
              child: BlocConsumer<OrdersCubit, OrdersState>(
                listener: (context, state) {
                  if (state is OrderRatingSuccess) {
                    context.showSuccess(state.message);
                  } else if (state is OrdersError) {
                    context.showError(state.errorMessage);
                  }
                },
                builder: (context, state) {
                  // 💡 السحر هنا: إذا كنا في حالة تحميل، نعرض دائرة تمنع ظهور البيانات الصفرية
                  if (state is! SingleOrderLoaded) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }

                  // 💡 إذا اكتمل التحميل، نأخذ البيانات الحية من السيرفر
                  final liveOrder = state.order;

                  final isCompleted =
                      liveOrder.status.toLowerCase() == 'completed' ||
                      liveOrder.status.toLowerCase() == 'delivered' ||
                      liveOrder.status == 'مكتمل' ||
                      liveOrder.status == 'تم التوصيل';

                  // 💡 رسم الشاشة بالبيانات المكتملة والحقيقية
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 20.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        OrderInfoCard(order: liveOrder),
                        24.verticalSpace,
                        Text(
                          "المنتجات (${liveOrder.items.length})",
                          style: AppTextStyle.font16.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textMain,
                          ),
                        ),
                        16.verticalSpace,
                        ListView.builder(
                          itemCount: liveOrder.items.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final item = liveOrder.items[index];
                            return OrderItemCard(
                              item: item,
                              showRating: isCompleted,
                              onRate: (rating) {
                                context.read<OrdersCubit>().rateProduct(
                                  item.id,
                                  liveOrder.id,
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
                                value: "${liveOrder.amount} ل.س",
                              ),
                              12.verticalSpace,
                              BuildSummaryRow(
                                title: "رسوم التوصيل",
                                value: "${liveOrder.deliveryAmount} ل.س",
                              ),
                              16.verticalSpace,
                              const Divider(
                                color: AppColors.formBorder,
                                thickness: 1,
                              ),
                              16.verticalSpace,
                              BuildSummaryRow(
                                title: "الإجمالي",
                                value: "${liveOrder.totalAmount} ل.س",
                                isTotal: true,
                              ),
                            ],
                          ),
                        ),

                        24.verticalSpace,

                        // =========================================================
                        // 3. أزرار التتبع وإعادة الطلب
                        // =========================================================
                        AppButton(
                          text: "تتبع حالة الطلب",
                          icon: Icons.map_outlined,
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              Routes.orderTracking,
                              arguments: liveOrder,
                            );
                          },
                        ),
                        12.verticalSpace,

                        // 💡 زر إعادة الطلب المدرع بحالة السلة الذي كتبناه سابقاً
                        BlocConsumer<CartCubit, CartState>(
                          bloc: getIt<CartCubit>(),
                          listener: (context, cartState) {
                            if (cartState is CartError) {
                              context.showError(cartState.errorMessage);
                            }
                          },
                          builder: (context, cartState) {
                            return AppButton(
                              text: "إعادة طلب هذه المنتجات",
                              icon: Icons.add_shopping_cart,
                              isLoading: cartState is CartLoading,
                              onPressed: () async {
                                if (cartState is CartLoading) return;

                                bool hasErrors = false;

                                for (final item in liveOrder .items) {
                                  await getIt<CartCubit>().addToCart(
                                    item.id,
                                    item.quantity,
                                  );

                                  if (getIt<CartCubit>().state is CartError) {
                                    hasErrors = true;
                                    break;
                                  }
                                }

                                if (context.mounted && !hasErrors) {
                                  context.showSuccess(
                                    "تم إضافة المنتجات لسلة المشتريات",
                                  );
                                  Navigator.pushNamed(context, Routes.cart);
                                }
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
