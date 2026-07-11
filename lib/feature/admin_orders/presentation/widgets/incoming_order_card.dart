// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class IncomingOrderCard extends StatelessWidget {
  final bool isDelayed;
  final String orderId;
  final String timeText;
  final String customerName;
  final String? customerPhone;
  final String customerAvatarLetter;
  final String orderType;
  final String totalPrice;
  final VoidCallback onStatusUpdate;
  final VoidCallback onActionTap;
  final VoidCallback? onRejectTap;

  const IncomingOrderCard({
    super.key,
    required this.isDelayed,
    required this.orderId,
    required this.timeText,
    required this.customerName,
    this.customerPhone,
    required this.customerAvatarLetter,
    required this.orderType,
    required this.totalPrice,
    required this.onStatusUpdate,
    required this.onActionTap,
    this.onRejectTap,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDelayed ? const Color(0xFFFCE8E8) : AppColors.white;
    final borderColor =
        isDelayed ? AppColors.primary.withOpacity(0.3) : AppColors.formBorder;
    final badgeBgColor =
        isDelayed ? const Color(0xFFFFDAD6) : AppColors.greyBackground;
    final badgeTextColor = isDelayed ? AppColors.primary : AppColors.greyDark;
    final avatarBgColor =
        isDelayed ? AppColors.primary : const Color(0xFFFFDAD6);
    final avatarTextColor = isDelayed ? AppColors.white : AppColors.primary;
    final timeColor = isDelayed ? AppColors.primary : AppColors.greyMedium3;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Stack(
          children: [
            if (isDelayed)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(height: 4.h, color: AppColors.primary),
              ),

            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- الجزء العلوي: الشارة + رقم الطلب + الوقت ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.schedule_rounded,
                                  size: 16.sp,
                                  color: timeColor,
                                ),
                                4.horizontalSpace,
                                Flexible(
                                  child: Text(
                                    timeText,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyle.font12.copyWith(
                                      color: timeColor,
                                      fontWeight: isDelayed
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            6.verticalSpace,
                            Text(
                              orderId,
                              style: AppTextStyle.font14.copyWith(
                                color: AppColors.greyMedium3,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      8.horizontalSpace,
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: badgeBgColor,
                          borderRadius: BorderRadius.circular(99.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!isDelayed) ...[
                              Container(
                                width: 8.w,
                                height: 8.w,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              6.horizontalSpace,
                            ],
                            if (isDelayed) ...[
                              Icon(
                                Icons.warning_rounded,
                                color: AppColors.primary,
                                size: 14.sp,
                              ),
                              4.horizontalSpace,
                            ],
                            Text(
                              isDelayed
                                  ? "متأخر - قيد التجهيز"
                                  : "قيد التجهيز",
                              style: AppTextStyle.font12.copyWith(
                                color: badgeTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  16.verticalSpace,

                  // --- معلومات العميل ونوع التوصيل ---
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22.r,
                        backgroundColor: avatarBgColor,
                        child: Text(
                          customerAvatarLetter,
                          style: AppTextStyle.font18.copyWith(
                            color: avatarTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      12.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              customerName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.font16.copyWith(
                                color: AppColors.textMain,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (customerPhone != null &&
                                customerPhone!.trim().isNotEmpty) ...[
                              2.verticalSpace,
                              Text(
                                customerPhone!,
                                style: AppTextStyle.font12.copyWith(
                                  color: AppColors.greyMedium3,
                                ),
                              ),
                            ],
                            4.verticalSpace,
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.greyBackground,
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Text(
                                orderType,
                                style: AppTextStyle.font12.copyWith(
                                  color: AppColors.greyMedium3,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  16.verticalSpace,

                  Divider(color: borderColor, height: 1),
                  12.verticalSpace,

                  // --- المجموع والإجمالي ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "إجمالي الطلب",
                        style: AppTextStyle.font14.copyWith(
                          color: AppColors.greyMedium3,
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          totalPrice,
                          style: AppTextStyle.font20.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  16.verticalSpace,

                  // --- الأزرار السفلية (موزعة بـ Expanded لمنع الـ Overflow و ANR) ---
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: onStatusUpdate,
                          borderRadius: BorderRadius.circular(8.r),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            decoration: BoxDecoration(
                              color: isDelayed
                                  ? AppColors.white
                                  : AppColors.greyBackground,
                              borderRadius: BorderRadius.circular(8.r),
                              border: isDelayed
                                  ? Border.all(
                                      color:
                                          AppColors.primary.withOpacity(0.3),
                                    )
                                  : Border.all(color: AppColors.formBorder),
                            ),
                            alignment: Alignment.center,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "تحديث الحالة",
                                    style: AppTextStyle.font12.copyWith(
                                      color: AppColors.textMain,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  4.horizontalSpace,
                                  Icon(
                                    Icons.expand_more_rounded,
                                    size: 16.sp,
                                    color: AppColors.greyMedium3,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (onRejectTap != null) ...[
                        8.horizontalSpace,
                        Expanded(
                          child: InkWell(
                            onTap: onRejectTap,
                            borderRadius: BorderRadius.circular(8.r),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              decoration: BoxDecoration(
                                color: Colors.red.shade700,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              alignment: Alignment.center,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "رفض الطلب",
                                  style: AppTextStyle.font12.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                      8.horizontalSpace,
                      Expanded(
                        child: InkWell(
                          onTap: onActionTap,
                          borderRadius: BorderRadius.circular(8.r),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(8.r),
                              boxShadow: [
                                if (isDelayed)
                                  BoxShadow(
                                    color:
                                        AppColors.primary.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check_rounded,
                                    color: AppColors.white,
                                    size: 16.sp,
                                  ),
                                  4.horizontalSpace,
                                  Text(
                                    "قبول الطلب",
                                    style: AppTextStyle.font12.copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
