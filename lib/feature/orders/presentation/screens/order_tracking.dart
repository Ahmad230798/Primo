import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/models/order_model.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';
import 'package:primo/feature/orders/presentation/bloc/orders_cubit.dart';
import 'package:primo/feature/orders/presentation/bloc/orders_state.dart';
import 'package:primo/feature/orders/presentation/widgets/additional_options.dart';
import 'package:primo/feature/orders/presentation/widgets/order_info.dart';
import 'package:primo/feature/orders/presentation/widgets/order_state.dart';

class OrderTracking extends StatelessWidget {
  final OrderModel? orderArg;
  const OrderTracking({super.key, this.orderArg});

  @override
  Widget build(BuildContext context) {
    final passedOrder =
        orderArg ?? ModalRoute.of(context)?.settings.arguments as OrderModel?;

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<OrdersCubit, OrdersState>(
          builder: (context, state) {
            OrderModel? currentOrder = orderArg;

            if (state is SingleOrderLoaded) {
              currentOrder = state.order;
            }

            if (state is OrdersLoading && currentOrder == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (currentOrder == null) {
              return Center(
                child: Text(
                  "لم يتم العثور على بيانات التتبع",
                  style: AppTextStyle.font18,
                ),
              );
            }
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomAppBar(title: "Primo"),
                    32.verticalSpace,
                    OrderInfo(order: passedOrder),
                    32.verticalSpace,
                    Text(
                      "حالة الطلب",
                      style: AppTextStyle.font20.copyWith(
                        color: AppColors.textMain,
                      ),
                    ),
                    24.verticalSpace,
                    OrderState(order: passedOrder),
                    32.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const AdditionalOptions(
                          iconData: Icons.support_agent_outlined,
                          text: "المساعدة",
                        ),
                        const AdditionalOptions(
                          iconData: Icons.description_outlined,
                          text: 'الفاتورة',
                        ),
                      ],
                    ),
                    20.verticalSpace,
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
