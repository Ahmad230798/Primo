import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class OrderInfoCard extends StatelessWidget {
  const OrderInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.formBorder),
      ),
      child: Column(
        children: [
          // الصف الأول: التاريخ وحالة الطلب
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "تاريخ الطلب",
                    style: AppTextStyle.font12.copyWith(
                      color: AppColors.greyMedium3,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    "12 أكتوبر 2025",
                    style: AppTextStyle.font14.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textMain,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "حالة الطلب",
                    style: AppTextStyle.font12.copyWith(
                      color: AppColors.greyMedium3,
                    ),
                  ),
                  4.verticalSpace,
                  // شارة الحالة (Status Badge)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9), // أخضر فاتح جداً
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Row(
                      children: [
                        Text(
                          "تم التسليم",
                          style: AppTextStyle.font12.copyWith(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2E7D32), // أخضر داكن
                          ),
                        ),
                        4.horizontalSpace,
                        Icon(
                          Icons.check_circle,
                          color: const Color(0xFF2E7D32),
                          size: 14.sp,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          16.verticalSpace,
          Divider(color: AppColors.formBorder, thickness: 1),
          16.verticalSpace,

          // الصف الثاني: طريقة التوصيل وعرض الفاتورة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.local_shipping_outlined,
                    color: AppColors.greyMedium1,
                    size: 20.sp,
                  ),
                  8.horizontalSpace,
                  Text(
                    "التوصيل العادي",
                    style: AppTextStyle.font14.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.greyMedium1,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "عرض الفاتورة",
                    style: AppTextStyle.font14.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  4.horizontalSpace,
                  Icon(
                    Icons.arrow_forward,
                    color: AppColors.primary,
                    size: 16.sp,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
