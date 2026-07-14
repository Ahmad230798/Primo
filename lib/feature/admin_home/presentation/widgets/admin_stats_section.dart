import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'stat_card.dart';

class AdminStatsSection extends StatelessWidget {
  final num? totalAmount;
  final int? pendingOrdersCount;
  final int? productsCount;
  final num? weeklyTotalAmount;
  final int? weeklyOrdersCount;

  const AdminStatsSection({
    super.key,
    this.totalAmount,
    this.pendingOrdersCount,
    this.productsCount,
    this.weeklyTotalAmount,
    this.weeklyOrdersCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: "إجمالي المبيعات",
                value: totalAmount != null ? totalAmount.toString() : "0",
                currency: "ل.س",
              ),
            ),
            16.horizontalSpace,
            Expanded(
              child: StatCard(
                title: "طلبات معلقة",
                value: pendingOrdersCount != null ? pendingOrdersCount.toString() : "0",
              ),
            ),
          ],
        ),
        16.verticalSpace,
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: "مبيعات الأسبوع",
                value: weeklyTotalAmount != null ? weeklyTotalAmount.toString() : "0",
                currency: "ل.س",
              ),
            ),
            16.horizontalSpace,
            Expanded(
              child: StatCard(
                title: "طلبات الأسبوع",
                value: weeklyOrdersCount != null ? weeklyOrdersCount.toString() : "0",
              ),
            ),
          ],
        ),
        16.verticalSpace,
        StatCard(
          title: "إجمالي المنتجات",
          value: productsCount != null ? productsCount.toString() : "0",
          isFullWidth: true,
        ),
      ],
    );
  }
}
