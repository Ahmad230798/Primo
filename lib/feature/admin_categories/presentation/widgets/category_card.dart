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

  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onEdit,
    required this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.formBorder.withOpacity(0.6)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16.r,
              offset: const Offset(0, 6),
            ),
          ],
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. صورة القسم (في الأعلى)
          Expanded(
            flex: 5,
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
            flex: 5,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // العنوان
                  Expanded(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        title,
                        style: AppTextStyle.font16.copyWith(
                          color: AppColors.textMain,
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                        ),
                        textAlign: TextAlign.right,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),

                  // الخط الفاصل
                  Divider(color: AppColors.formBorder.withOpacity(0.6), height: 1),
                  8.verticalSpace,

                  // أزرار التعديل والحذف
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // زر التعديل
                      InkWell(
                        onTap: onEdit,
                        borderRadius: BorderRadius.circular(8.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: AppColors.greyBackground,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.edit_outlined,
                                color: AppColors.primary,
                                size: 16.sp,
                              ),
                              4.horizontalSpace,
                              Text(
                                "تعديل",
                                style: AppTextStyle.font12.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      8.horizontalSpace,
                      // زر الحذف
                      InkWell(
                        onTap: onDelete,
                        borderRadius: BorderRadius.circular(8.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.red.shade700,
                                size: 16.sp,
                              ),
                              4.horizontalSpace,
                              Text(
                                "حذف",
                                style: AppTextStyle.font12.copyWith(
                                  color: Colors.red.shade700,
                                  fontWeight: FontWeight.w600,
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
            ),
          ),
        ],
      ),
    ));
  }
}
