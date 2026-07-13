// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/models/order_model.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class OrderStatusTracker extends StatelessWidget {
  final OrderModel? order;
  final bool isLoading;
  final void Function(String newStatus)? onUpdateStatus;

  const OrderStatusTracker({
    super.key,
    this.order,
    this.isLoading = false,
    this.onUpdateStatus,
  });

  @override
  Widget build(BuildContext context) {
    final status = order?.status.toLowerCase() ?? 'pending';
    final isPending = status == 'pending' || order?.status == 'قيد الانتظار';
    final isProcessing = status == 'processing' || order?.status == 'قيد التجهيز';
    final isCompleted = status == 'completed' || order?.status == 'مكتمل' || order?.status == 'تم التسليم';
    final isCancelled = status == 'canceled' || status == 'cancelled' || order?.status == 'ملغي';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "تحديث حالة الطلب",
          style: AppTextStyle.font18.copyWith(
            color: AppColors.textMain,
            fontWeight: FontWeight.bold,
          ),
        ),
        12.verticalSpace,
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.formBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // الـ Stepper (المتتبع)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStep(
                    Icons.schedule_rounded,
                    "قيد الانتظار",
                    true,
                    isPending,
                  ),
                  _buildStep(
                    Icons.sync_rounded,
                    "قيد التجهيز",
                    isProcessing || isCompleted,
                    isProcessing,
                  ),
                  _buildStep(
                    Icons.check_circle_outline_rounded,
                    "مكتمل",
                    isCompleted,
                    isCompleted,
                  ),
                ],
              ),
              20.verticalSpace,
              Divider(color: AppColors.formBorder, height: 1),
              16.verticalSpace,

              // أزرار تغيير الحالة السريعة والواضحة
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  _buildActionButton(
                    "قيد الانتظار",
                    'pending',
                    isPending,
                    AppColors.primary,
                  ),
                  _buildActionButton(
                    "قيد التجهيز",
                    'processing',
                    isProcessing,
                    Colors.orange.shade700,
                  ),
                  _buildActionButton(
                    "مكتمل / تم التسليم",
                    'completed',
                    isCompleted,
                    Colors.green.shade700,
                  ),
                  _buildActionButton(
                    "ملغي / مرفوض",
                    'canceled',
                    isCancelled,
                    Colors.red.shade700,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String label,
    String value,
    bool isCurrent,
    Color color,
  ) {
    return InkWell(
      onTap: isLoading
          ? null
          : () {
              if (onUpdateStatus != null) {
                onUpdateStatus!(value);
              }
            },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isCurrent ? color : color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isCurrent ? color : color.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isCurrent) ...[
              Icon(Icons.check_circle_rounded, color: AppColors.white, size: 16.sp),
              6.horizontalSpace,
            ],
            Text(
              label,
              style: AppTextStyle.font14.copyWith(
                color: isCurrent ? AppColors.white : color,
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(
    IconData icon,
    String title,
    bool isCompleted,
    bool isCurrent,
  ) {
    Color bgColor;
    Color iconColor;
    Color borderColor = Colors.transparent;

    if (isCurrent) {
      bgColor = AppColors.primary;
      iconColor = AppColors.white;
    } else if (isCompleted) {
      bgColor = AppColors.primary.withOpacity(0.15);
      iconColor = AppColors.primary;
      borderColor = AppColors.primary;
    } else {
      bgColor = AppColors.greyBackground;
      iconColor = AppColors.greyDark;
    }

    return Container(
      color: AppColors.white,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
              border: Border.all(color: borderColor, width: 2),
            ),
            child: Icon(icon, color: iconColor, size: 20.sp),
          ),
          8.verticalSpace,
          Text(
            title,
            style: AppTextStyle.font12.copyWith(
              color: (isCurrent || isCompleted) ? AppColors.primary : AppColors.greyDark,
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
