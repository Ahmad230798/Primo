import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'stat_card.dart';

class AdminStatsSection extends StatelessWidget {
  const AdminStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: "إجمالي المبيعات",
                value: "12,450",
                currency: "ر.س",
              ),
            ),
            16.horizontalSpace,
            Expanded(
              child: StatCard(title: "طلبات جديدة", value: "48"),
            ),
          ],
        ),
        16.verticalSpace,
        StatCard(title: "إجمالي المنتجات", value: "312", isFullWidth: true),
      ],
    );
  }
}
