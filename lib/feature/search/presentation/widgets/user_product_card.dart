import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class UserProductCard extends StatelessWidget {
  final String title;
  final String weight;
  final String price;
  final String imageUrl;
  final bool isFavorite;
  final bool isOutOfStock;

  const UserProductCard({
    super.key,
    required this.title,
    required this.weight,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
    this.isOutOfStock = false,
  });

  @override
  Widget build(BuildContext context) {
    // تحديد الشفافية بناءً على التوفر
    final opacity = isOutOfStock ? 0.6 : 1.0;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.formBorder, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. قسم الصورة مع أيقونة المفضلة
          Expanded(
            child: Stack(
              children: [
                // الصورة بخلفية رمادية
                Opacity(
                  opacity: opacity,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.greyBackground,
                      borderRadius: BorderRadius.circular(12.r),
                      image: DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                // أيقونة المفضلة (في الزاوية العلوية اليسرى كما في التصميم)
                Positioned(
                  top: 4.h,
                  left: 4.w,
                  child: Icon(
                    isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: isFavorite ? AppColors.primary : AppColors.greyDark,
                    size: 20.sp,
                  ),
                ),

                // شارة "نفد الكمية"
                if (isOutOfStock)
                  Positioned(
                    top: 4.h,
                    right: 4.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.textMain,
                        borderRadius: BorderRadius.circular(99.r),
                      ),
                      child: Text(
                        "نفد الكمية",
                        style: AppTextStyle.font12.copyWith(
                          color: AppColors.white,
                          fontSize: 10.sp, // خط صغير جداً
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          12.verticalSpace,

          // 2. التفاصيل (العنوان والوزن)
          Opacity(
            opacity: opacity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyle.font14.copyWith(
                    color: AppColors.textMain,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                4.verticalSpace,
                Text(
                  weight,
                  style: AppTextStyle.font12.copyWith(
                    color: AppColors.greyMedium3,
                  ),
                ),
              ],
            ),
          ),
          12.verticalSpace,

          // 3. السعر وزر الإضافة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Opacity(
                opacity: opacity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      price,
                      style: AppTextStyle.font18.copyWith(
                        color: isOutOfStock
                            ? AppColors.textMain
                            : AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    4.horizontalSpace,
                    Text(
                      "ر.س",
                      style: AppTextStyle.font12.copyWith(
                        color: isOutOfStock
                            ? AppColors.textMain
                            : AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),

              // زر الإضافة الدائري
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: isOutOfStock
                      ? AppColors.formBorder
                      : AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: isOutOfStock
                      ? null
                      : [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Icon(
                  Icons.add_rounded,
                  color: isOutOfStock ? AppColors.greyMedium3 : AppColors.white,
                  size: 20.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
