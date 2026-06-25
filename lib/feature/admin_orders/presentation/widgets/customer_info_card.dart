import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class CustomerInfoCard extends StatelessWidget {
  const CustomerInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان والشارة (توصيل للعنوان)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "بيانات العميل",
                style: AppTextStyle.font18.copyWith(
                  color: AppColors.textMain,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.greyBackground,
                  borderRadius: BorderRadius.circular(99.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.local_shipping_outlined,
                      size: 16.sp,
                      color: AppColors.textMain,
                    ),
                    4.horizontalSpace,
                    Text(
                      "توصيل للعنوان",
                      style: AppTextStyle.font12.copyWith(
                        color: AppColors.textMain,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          16.verticalSpace,

          // الاسم
          _buildInfoRow(
            Icons.person_outline_rounded,
            "أحمد محمد",
            isLink: false,
          ),
          8.verticalSpace,
          Divider(color: AppColors.formBorder, height: 1),
          8.verticalSpace,

          // رقم الهاتف (بلون أحمر)
          _buildInfoRow(Icons.call_outlined, "050 123 4567", isLink: true),
          8.verticalSpace,
          Divider(color: AppColors.formBorder, height: 1),
          8.verticalSpace,

          // العنوان
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 20.sp,
                color: AppColors.greyDark,
              ),
              8.horizontalSpace,
              Expanded(
                child: Text(
                  "شارع التحلية، حي العليا، الرياض 12241، المملكة العربية السعودية. بالقرب من برج المملكة.",
                  style: AppTextStyle.font14.copyWith(
                    color: AppColors.greyMedium3,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {required bool isLink}) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: AppColors.greyDark),
        8.horizontalSpace,
        Text(
          text,
          style: AppTextStyle.font14.copyWith(
            color: isLink ? AppColors.primary : AppColors.textMain,
            fontWeight: isLink ? FontWeight.bold : FontWeight.w500,
          ),
          textDirection: isLink ? TextDirection.ltr : null, // لضبط رقم الهاتف
        ),
      ],
    );
  }
}
