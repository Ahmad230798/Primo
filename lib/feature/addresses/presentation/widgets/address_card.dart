// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class AddressCard extends StatelessWidget {
  final String title;
  final String details;
  final IconData icon;
  final bool isDefault;
  final VoidCallback onEditTap;
  final VoidCallback onDeleteTap;
  final VoidCallback onTap;

  const AddressCard({
    super.key,
    required this.title,
    required this.details,
    required this.icon,
    required this.isDefault,
    required this.onEditTap,
    required this.onDeleteTap,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isDefault ? AppColors.primary : AppColors.formBorder,
            width: isDefault ? 1.2 : 1,
          ),
        ),
        child: Stack(
          children: [
            // المحتوى الداخلي للبطاقة مرتب حسب محاذاة RTL
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // أزرار التحكم (حذف وتعديل) تظهر في أقصى اليسار
                  Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: const BoxDecoration(
                      color: AppColors.greyBackground,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: AppColors.greyDark, size: 22.sp),
                  ),

                  const Spacer(),

                  // تفاصيل العنوان والنصوص (المنتصف)
                  Expanded(
                    flex: 9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              title,
                              style: AppTextStyle.font18.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.textMain,
                              ),
                            ),
                            8.horizontalSpace,
                            // شارة "الافتراضي" تظهر فقط إذا كان العنوان افتراضياً
                            if (isDefault) ...[
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Text(
                                  "الافتراضي",
                                  style: AppTextStyle.font12.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        8.verticalSpace,
                        Text(
                          details,
                          style: AppTextStyle.font14.copyWith(
                            color: AppColors.greyMedium3,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  12.horizontalSpace,

                  // أيقونة تصنيف العنوان (المنزل، العمل..) تظهر في أقصى اليمين
                  Row(
                    children: [
                      InkWell(
                        onTap: onDeleteTap,
                        child: Icon(
                          Icons.delete_outline_rounded,
                          color: AppColors.greyMedium3,
                          size: 22.sp,
                        ),
                      ),
                      12.horizontalSpace,
                      InkWell(
                        onTap: onEditTap,
                        child: Icon(
                          Icons.edit_outlined,
                          color: AppColors.greyMedium3,
                          size: 22.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // الشريط الأحمر الجانبي المخصص للعنوان الافتراضي ليعطي تطابقاً كاملاً مع الصورة
            if (isDefault)
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 4.w,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16.r),
                      bottomRight: Radius.circular(16.r),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
