// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class FavoriteProductCard extends StatelessWidget {
  final String title;
  final String weight;
  final String price;
  final String imagePath;
  final VoidCallback onFavoriteTap;
  final VoidCallback onAddTap;

  const FavoriteProductCard({
    super.key,
    required this.title,
    required this.weight,
    required this.price,
    required this.imagePath,
    required this.onFavoriteTap,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, Routes.productDetails),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: AppColors.white,
          border: Border.all(
            color: AppColors.formBorder,
            width: 0.5,
          ), // حد خفيف للبطاقة
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. الصورة مع أيقونة القلب (Stack)
            Stack(
              children: [
                Container(
                  height: 120.h,
                  width: 1.sw,
                  decoration: BoxDecoration(
                    color: AppColors.greyBackground, // خلفية الصورة الرمادية
                    borderRadius: BorderRadius.circular(12.r),
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // أيقونة القلب
                Positioned(
                  top: 8.h,
                  left: 8.w,
                  child: InkWell(
                    onTap: onFavoriteTap,
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite,
                        color: AppColors.primary,
                        size: 25.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            12.verticalSpace,

            // 2. اسم المنتج
            Text(
              title,
              style: AppTextStyle.font14.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.textMain,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            4.verticalSpace,

            // 3. الوزن
            Text(
              weight,
              style: AppTextStyle.font12.copyWith(color: AppColors.greyMedium3),
            ),

            const Spacer(), // لدفع السعر والزر لأسفل البطاقة دائماً
            // 4. السعر وزر الإضافة
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  price,
                  style: AppTextStyle.font20.copyWith(color: AppColors.primary),
                ),
                InkWell(
                  onTap: onAddTap,
                  child: Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.23),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                          spreadRadius: 0,
                        ),
                      ],
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                    child: Icon(Icons.add, color: AppColors.white, size: 20.sp),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
