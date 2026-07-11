// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/app_cached_network_image.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CategoryCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.formBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. صورة القسم (في الأعلى)
          Expanded(
            flex: 4, // نأخذ 4 أجزاء للصورة
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              child: Container(
                color: AppColors.greyBackground,
                child: imagePath.startsWith('assets/')
                    ? Image.asset(imagePath, fit: BoxFit.cover)
                    : AppCachedNetworkImage(
                        imageUrl: imagePath,
                        fit: BoxFit.cover,
                        errorWidget: Image.asset(
                          'assets/images/honey.png',
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
          ),

          // 2. المحتوى السفلي (العنوان + الأزرار)
          Expanded(
            flex: 5, // نأخذ 5 أجزاء للنصوص والأزرار
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // العنوان
                  Expanded(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        title,
                        style: AppTextStyle.font18.copyWith(
                          color: AppColors.textMain,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                        textAlign: TextAlign.right,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),

                  // الخط الفاصل
                  Divider(color: AppColors.formBorder, height: 1),
                  8.verticalSpace,

                  // أزرار التعديل والحذف
                  Row(
                    children: [
                      // زر التعديل
                      InkWell(
                        onTap: onEdit,
                        borderRadius: BorderRadius.circular(8.r),
                        child: Padding(
                          padding: EdgeInsets.all(4.w),
                          child: Icon(
                            Icons.edit_outlined,
                            color: AppColors.greyMedium2,
                            size: 20.sp,
                          ),
                        ),
                      ),
                      12.horizontalSpace,
                      // زر الحذف
                      InkWell(
                        onTap: onDelete,
                        borderRadius: BorderRadius.circular(8.r),
                        child: Padding(
                          padding: EdgeInsets.all(4.w),
                          child: Icon(
                            Icons.delete_outline_rounded,
                            color: AppColors.greyMedium2,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
