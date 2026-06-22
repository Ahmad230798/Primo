import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class OrderInfo extends StatelessWidget {
  const OrderInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(width: 1, color: AppColors.formBorder),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            spreadRadius: 0,
            offset: Offset(0, 4),
            color: AppColors.textMain.withOpacity(0.04),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "رقم الطلب",
                style: AppTextStyle.font14.copyWith(
                  color: AppColors.greyMedium1,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 3.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999.r),
                  color: AppColors.formBorder,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      color: AppColors.greyDark,
                      size: 20,
                    ),
                    Text(
                      "اليوم، 10:30 ص",
                      style: AppTextStyle.font12.copyWith(
                        color: AppColors.greyDark,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          4.verticalSpace,
          Text("#PRM-84920", style: AppTextStyle.font20),
          24.verticalSpace,
          Divider(color: AppColors.greyLight),
          24.verticalSpace,
          Row(
            children: [
              Container(
                width: 94.w,
                height: 94.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage("assets/images/groceries.jpg"),
                  ),
                ),
              ),
              17.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "سلة الفواكه والخضروات والمزيد",
                      style: AppTextStyle.font16.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMain,
                      ),
                    ),
                    4.verticalSpace,
                    Row(
                      children: [
                        Text(
                          "12 عنصر •",
                          style: AppTextStyle.font14.copyWith(
                            color: AppColors.greyMedium2,
                          ),
                        ),
                        Text(
                          " 245.50 ل.س",
                          style: AppTextStyle.font14.copyWith(
                            color: AppColors.greyMedium2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
