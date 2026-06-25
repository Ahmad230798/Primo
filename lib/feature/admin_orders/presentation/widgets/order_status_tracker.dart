import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class OrderStatusTracker extends StatelessWidget {
  const OrderStatusTracker({super.key});

  @override
  Widget build(BuildContext context) {
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
              Stack(
                alignment: Alignment.center,
                children: [
                  // الخط الواصل بين النقاط
                  Divider(color: AppColors.formBorder, thickness: 2),
                  // النقاط الثلاث
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStep(
                        Icons.check_rounded,
                        "تم الاستلام",
                        true,
                        true,
                      ),
                      _buildStep(
                        Icons.sync_rounded,
                        "قيد التجهيز",
                        true,
                        false,
                      ),
                      _buildStep(
                        Icons.local_shipping_outlined,
                        "قيد التوصيل",
                        false,
                        false,
                      ),
                    ],
                  ),
                ],
              ),
              24.verticalSpace,

              // القائمة المنسدلة وزر التحديث
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.greyBackground,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "قيد التجهيز",
                            style: AppTextStyle.font14.copyWith(
                              color: AppColors.textMain,
                            ),
                          ),
                          Icon(
                            Icons.expand_more_rounded,
                            color: AppColors.greyDark,
                            size: 20.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                  12.horizontalSpace,
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 14.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    child: Text(
                      "تحديث الحالة",
                      style: AppTextStyle.font14.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ودجت مساعد لرسم خطوة في المتتبع
  Widget _buildStep(
    IconData icon,
    String title,
    bool isActive,
    bool isCompleted,
  ) {
    Color bgColor;
    Color iconColor;
    Color borderColor = Colors.transparent;

    if (isCompleted) {
      bgColor = AppColors.primary;
      iconColor = AppColors.white;
    } else if (isActive) {
      bgColor = AppColors.white;
      iconColor = AppColors.primary;
      borderColor = AppColors.primary;
    } else {
      bgColor = AppColors.greyBackground;
      iconColor = AppColors.greyDark;
    }

    return Container(
      color: AppColors.white, // لخفاء الخط الذي يمر تحت الدائرة
      padding: EdgeInsets.symmetric(
        horizontal: 8.w,
      ), // إبعاد الخط عن الدائرة قليلاً
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
              color: isActive ? AppColors.primary : AppColors.greyDark,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
