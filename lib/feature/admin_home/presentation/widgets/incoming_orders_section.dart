import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/helper/navigation.dart';
import 'package:primo/core/models/order_model.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'section_header.dart';
import 'order_card.dart';

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

              // 1. الوصول للاسم من كائن user وليس address
              final customerName = order.user?.name ?? "عميل #${order.userId}";

              // 2. بخصوص عدد العناصر:
              // بما أن الـ items غير موجودة في هذا الرد، سنحاول إظهار نص افتراضي
              // أو إذا كان لديك حقل آخر في المودل مثل itemsCount تأكد من استخدامه.
              // حالياً سنضع نصاً معبراً لتجنب ظهور "0"
              final itemCountText = "طلبية";

              return OrderCard(
                customerName: customerName,
                orderId: "#${order.id}",
                itemCount:
                    itemCountText, // تم استبدال الـ length النصي بهذا المتغير
                price: order.totalAmount.toString(),
                onAccept: () {
                  context.pushNamed(Routes.adminOrders);
                },
                onReject: () {
                  context.pushNamed(Routes.adminOrders);
                },
              );
            },
          ),
      ],
    );
  }
}
