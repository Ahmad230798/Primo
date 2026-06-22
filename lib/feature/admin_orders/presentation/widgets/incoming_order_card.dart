// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class IncomingOrderCard extends StatelessWidget {
  final bool isDelayed; // هذا المتغير يتحكم بشكل البطاقة بالكامل
  final String orderId;
  final String timeText;
  final String customerName;
  final String customerAvatarLetter;
  final String orderType;
  final String totalPrice;
  final VoidCallback onStatusUpdate;
  final VoidCallback onActionTap;

  const IncomingOrderCard({
    super.key,
    required this.isDelayed,
    required this.orderId,
    required this.timeText,
    required this.customerName,
    required this.customerAvatarLetter,
    required this.orderType,
    required this.totalPrice,
    required this.onStatusUpdate,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    // الألوان الديناميكية بناءً على حالة التأخير
    final bgColor = isDelayed
        ? const Color(0xFFFCE8E8)
        : AppColors.white; // أحمر فاتح جداً أو أبيض
    final borderColor = isDelayed
        ? AppColors.primary.withOpacity(0.3)
        : AppColors.formBorder;
    final badgeBgColor = isDelayed
        ? const Color(0xFFFFDAD6)
        : AppColors.greyBackground;
    final badgeTextColor = isDelayed ? AppColors.primary : AppColors.greyDark;
    final avatarBgColor = isDelayed
        ? AppColors.primary
        : const Color(0xFFFFDAD6);
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
            // الشريط الأحمر العلوي للطلبات المتأخرة
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
                      // اليمين (الوقت ورقم الطلب)
                      Column(
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
                              Text(
                                timeText,
                                style: AppTextStyle.font12.copyWith(
                                  color: timeColor,
                                  fontWeight: isDelayed
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          8.verticalSpace,
                          Text(
                            orderId,
                            style: AppTextStyle.font14.copyWith(
                              color: AppColors.greyMedium3,
                            ),
                          ),
                        ],
                      ),

                      // اليسار (الشارة)
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
                              isDelayed ? "متأخر - قيد التجهيز" : "قيد التجهيز",
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

                  // --- معلومات العميل ---
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20.r,
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            customerName,
                            style: AppTextStyle.font16.copyWith(
                              color: AppColors.textMain,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          2.verticalSpace,
                          Text(
                            orderType,
                            style: AppTextStyle.font14.copyWith(
                              color: AppColors.greyMedium3,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  16.verticalSpace,

                  // خط فاصل شفاف يأخذ لون خفيف
                  Divider(color: borderColor, height: 1),
                  16.verticalSpace,

                  // --- الجزء السفلي: المجموع + الأزرار ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // اليمين (المجموع)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "المجموع",
                            style: AppTextStyle.font12.copyWith(
                              color: AppColors.greyMedium3,
                            ),
                          ),
                          2.verticalSpace,
                          Text(
                            totalPrice,
                            style: AppTextStyle.font20.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      // اليسار (القائمة المنسدلة + الزر)
                      Row(
                        children: [
                          // القائمة المنسدلة (تصميم مخصص لتبدو كزر)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: isDelayed
                                  ? AppColors.white
                                  : AppColors.greyBackground,
                              borderRadius: BorderRadius.circular(8.r),
                              border: isDelayed
                                  ? Border.all(
                                      color: AppColors.primary.withOpacity(0.3),
                                    )
                                  : null,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "تحديث الحالة",
                                  style: AppTextStyle.font12.copyWith(
                                    color: AppColors.textMain,
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
                          8.horizontalSpace,
                          // الزر الرئيسي (تم / عاجل)
                          InkWell(
                            onTap: onActionTap,
                            borderRadius: BorderRadius.circular(8.r),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(8.r),
                                boxShadow: [
                                  if (isDelayed)
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isDelayed
                                        ? Icons.priority_high_rounded
                                        : Icons.check_rounded,
                                    color: AppColors.white,
                                    size: 18.sp,
                                  ),
                                  4.horizontalSpace,
                                  Text(
                                    isDelayed ? "عاجل" : "تم",
                                    style: AppTextStyle.font14.copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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
