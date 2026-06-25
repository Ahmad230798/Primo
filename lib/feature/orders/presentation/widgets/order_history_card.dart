import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class OrderHistoryCard extends StatelessWidget {
  final String orderNumber;
  final String date;
  final String price;
  final bool isDelivery;
  final String status;
  final bool isDelivered;
  final List<String> productImages;
  final int extraProductsCount;
  final VoidCallback onTap;

  const OrderHistoryCard({
    super.key,
    required this.orderNumber,
    required this.date,
    required this.price,
    required this.isDelivery,
    required this.status,
    required this.isDelivered,
    required this.productImages,
    this.extraProductsCount = 0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.formBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- الصف الأول: الأيقونة، رقم الطلب، التاريخ، والسعر ---
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الأيقونة (توصيل أو استلام)
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isDelivery
                      ? Icons.shopping_bag_outlined
                      : Icons.storefront_outlined,
                  color: AppColors.primary,
                  size: 20.sp,
                ),
              ),
              12.horizontalSpace,
              // رقم الطلب والتاريخ
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      orderNumber,
                      style: AppTextStyle.font20.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMain,
                      ),
                    ),
                    4.verticalSpace,
                    Text(
                      date,
                      style: AppTextStyle.font12.copyWith(
                        color: AppColors.greyMedium3,
                      ),
                    ),
                  ],
                ),
              ),
              // السعر
              Text(
                price,
                style: AppTextStyle.font20.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          16.verticalSpace,

          // --- الصف الثاني: شارات الحالة وطريقة الاستلام ---
          Row(
            children: [
              // شارة طريقة الاستلام
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.greyBackground,
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      isDelivery
                          ? Icons.local_shipping_outlined
                          : Icons.storefront_outlined,
                      color: AppColors.greyDark,
                      size: 14.sp,
                    ),
                    4.horizontalSpace,
                    Text(
                      isDelivery ? "توصيل" : "استلام من المتجر",
                      style: AppTextStyle.font12.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.greyDark,
                      ),
                    ),
                  ],
                ),
              ),
              8.horizontalSpace,
              // شارة الحالة (خضراء إذا تم التسليم)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isDelivered
                      ? const Color(0xFFE8F5E9)
                      : AppColors.quantityBackground,
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      isDelivered
                          ? Icons.check_circle_outline
                          : Icons.access_time,
                      color: isDelivered ? AppColors.green : AppColors.primary,
                      size: 14.sp,
                    ),
                    4.horizontalSpace,
                    Text(
                      status,
                      style: AppTextStyle.font12.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDelivered
                            ? AppColors.green
                            : AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          16.verticalSpace,
          Divider(color: AppColors.formBorder, thickness: 1, height: 1),
          16.verticalSpace,

          // --- الصف الثالث: صور المنتجات المتداخلة وزر عرض التفاصيل ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // صور المنتجات المتداخلة (مبنية كدالة مساعدة بالأسفل)
              _buildOverlappingImages(),
              // زر عرض التفاصيل
              InkWell(
                onTap: onTap,
                child: Row(
                  children: [
                    Text(
                      "عرض التفاصيل",
                      style: AppTextStyle.font14.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                    4.horizontalSpace,
                    Icon(
                      Icons.arrow_forward,
                      color: AppColors.primary,
                      size: 20.sp,
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

  // دالة مساعدة لإنشاء تأثير تداخل الصور (Overlapping)
  Widget _buildOverlappingImages() {
    double imageSize = 32.w;
    double overlap = 12.w; // مسافة التداخل
    int visibleCount = productImages.length;

    // حساب العرض الكلي للـ Stack بناءً على عدد الصور والتداخل
    double stackWidth =
        (imageSize * visibleCount) - (overlap * (visibleCount - 1));
    if (extraProductsCount > 0) {
      stackWidth += (imageSize - overlap);
    }

    return SizedBox(
      width: stackWidth,
      height: imageSize,
      child: Stack(
        children: [
          for (int i = 0; i < visibleCount; i++)
            Positioned(
              right: i * (imageSize - overlap), // ترتيب من اليمين لليسار (RTL)
              child: Container(
                width: imageSize,
                height: imageSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 2),
                  image: DecorationImage(
                    image: AssetImage(productImages[i]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          if (extraProductsCount > 0)
            Positioned(
              right: visibleCount * (imageSize - overlap),
              child: Container(
                width: imageSize,
                height: imageSize,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 2),
                ),
                child: Center(
                  child: Text(
                    "+$extraProductsCount",
                    style: AppTextStyle.font12.copyWith(
                      color: AppColors.textMain,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
