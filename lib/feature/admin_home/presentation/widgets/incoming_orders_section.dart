import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/helper/navigation.dart';
import 'package:primo/core/models/order_model.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'section_header.dart';
import 'package:primo/feature/admin_orders/presentation/widgets/incoming_order_card.dart';

class IncomingOrdersSection extends StatelessWidget {
  final List<OrderModel>? orders;

  const IncomingOrdersSection({super.key, this.orders});

  @override
  Widget build(BuildContext context) {
    final list = orders ?? [];
    return Column(
      children: [
        SectionHeader(
          title: "الطلبات الواردة",
          actionText: "عرض الكل",
          onActionTap: () {
            context.pushNamed(Routes.adminOrders);
          },
        ),
        16.verticalSpace,
        if (list.isEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 32.h),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.formBorder),
            ),
            child: Center(
              child: Text(
                "لا توجد طلبات معلقة حالياً",
                style: AppTextStyle.font16.copyWith(
                  color: AppColors.greyDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: list.length > 5 ? 5 : list.length,
            separatorBuilder: (context, index) => 12.verticalSpace,
            itemBuilder: (context, index) {
              final order = list[index];
              final st = order.status.toLowerCase();
              final isPending = st == 'pending' || order.status == 'قيد الانتظار';
              final customerName =
                  order.user?.name ??
                  order.address?.name ??
                  "عميل بريمو #${order.userId}";
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
                child: IncomingOrderCard(
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
                  statusText: order.statusArabic,
                  onStatusUpdate: () {
                    context.pushNamed(Routes.adminOrders);
                  },
                  onActionTap: () {
                    context.pushNamed(Routes.adminOrders);
                  },
                  onRejectTap: () {
                    context.pushNamed(Routes.adminOrders);
                  },
                ),
              );
            },
          ),
      ],
    );
  }
}
