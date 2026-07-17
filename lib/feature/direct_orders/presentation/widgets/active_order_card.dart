// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class ActiveOrderCard extends StatelessWidget {
  final String orderId;
  final String timeAgo;
  final String price;
  final String paymentMethod;
  final String customerName;
  final String customerType;
  final String distance;
  final bool isDollar;

  const ActiveOrderCard({
    super.key,
    required this.orderId,
    required this.timeAgo,
    required this.price,
    required this.paymentMethod,
    required this.customerName,
    required this.customerType,
    required this.distance,
    this.isDollar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. الشريط الأحمر الجانبي (على اليمين)
              Container(width: 6.w, color: AppColors.primary),

              // 2. محتوى البطاقة
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- الجزء الأول: تفاصيل الطلب والسعر ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // اليمين (رقم الطلب والوقت)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFDAD6),
                                  borderRadius: BorderRadius.circular(99.r),
                                ),
                                child: Text(
                                  "طلب جديد",
                                  style: AppTextStyle.font12.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              8.verticalSpace,
                              Text(
                                orderId,
                                style: AppTextStyle.font20.copyWith(
                                  color: AppColors.textMain,
                                ),
                              ),
                              2.verticalSpace,
                              Text(
                                timeAgo,
                                style: AppTextStyle.font14.copyWith(
                                  color: AppColors.greyMedium3,
                                ),
                              ),
                            ],
                          ),
                          // اليسار (السعر وطريقة الدفع)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    isDollar ? "\$ $price" : "$price ل.س",
                                    style: AppTextStyle.font20.copyWith(
                                      color: AppColors.textMain,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              4.verticalSpace,
                              Text(
                                paymentMethod,
                                style: AppTextStyle.font12.copyWith(
                                  color: AppColors.greyMedium3,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      16.verticalSpace,

                      // --- الجزء الثاني: معلومات العميل ---
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20.r,
                              backgroundColor: AppColors.greyLight.withOpacity(
                                0.4,
                              ),
                              child: Icon(
                                Icons.person_outline,
                                color: AppColors.greyDark,
                                size: 22.sp,
                              ),
                            ),
                            12.horizontalSpace,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  customerName,
                                  style: AppTextStyle.font14.copyWith(
                                    color: AppColors.textMain,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                2.verticalSpace,
                                Text(
                                  customerType,
                                  style: AppTextStyle.font12.copyWith(
                                    color: AppColors.greyMedium2,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      16.verticalSpace,

                      // --- الجزء الثالث: مكان الخريطة (Placeholder) ---
                      // جاهز للاستبدال بـ GoogleMap لاحقاً
                      Container(
                        height: 120.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          color: AppColors.greyBackground,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // أيقونة الموقع الوهمية (وسط الخريطة)
                            Icon(
                              Icons.location_on,
                              color: AppColors.quantityBackground,
                              size: 40.sp,
                            ),

                            // شريحة المسافة (يسار أسفل)
                            Positioned(
                              bottom: 8.h,
                              left: 8.w,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(8.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      size: 14.sp,
                                      color: AppColors.textMain,
                                    ),
                                    4.horizontalSpace,
                                    Text(
                                      distance,
                                      style: AppTextStyle.font12.copyWith(
                                        color: AppColors.textMain,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      16.verticalSpace,

                      // --- الجزء الرابع: القائمة المنسدلة ---
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.formBorder),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "طلب جديد",
                              style: AppTextStyle.font14.copyWith(
                                color: AppColors.textMain,
                              ),
                            ),
                            Icon(
                              Icons.expand_more_rounded,
                              color: AppColors.greyMedium3,
                              size: 24.sp,
                            ),
                          ],
                        ),
                      ),
                      12.verticalSpace,

                      // --- الجزء الخامس: زر التفاصيل ---
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          elevation: 0,
                          minimumSize: Size(double.infinity, 52.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "تفاصيل",
                              style: AppTextStyle.font16.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            8.horizontalSpace,
                            // سهم يتجه لليسار كما في الصورة
                            Icon(
                              Icons.arrow_back_rounded,
                              color: AppColors.white,
                              size: 20.sp,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
