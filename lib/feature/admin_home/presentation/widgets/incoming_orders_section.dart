import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'section_header.dart';
import 'order_card.dart';

class IncomingOrdersSection extends StatelessWidget {
  const IncomingOrdersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: "الطلبات الواردة",
          actionText: "عرض الكل",
          onActionTap: () {},
        ),
        16.verticalSpace,
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 2, // بناءً على التصميم
          separatorBuilder: (context, index) => 12.verticalSpace,
          itemBuilder: (context, index) {
            // بيانات وهمية مؤقتة للتصميم
            return OrderCard(
              customerName: index == 0 ? "أحمد المحمد" : "سارة عبدالله",
              orderId: index == 0 ? "#4902" : "#4901",
              itemCount: index == 0 ? "4" : "12",
              price: index == 0 ? "240" : "850",
              onAccept: () {},
            );
          },
        ),
      ],
    );
  }
}
