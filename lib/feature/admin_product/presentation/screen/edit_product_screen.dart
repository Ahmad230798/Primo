import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';

import '../widgets/edit_image_section.dart';
import '../widgets/edit_product_form.dart';

class EditProductScreen extends StatelessWidget {
  const EditProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white, // تم تعيين الخلفية للأبيض لتطابق الصورة
      body: SafeArea(
        child: Column(
          children: [
            // 1. شريط التنقل العلوي (يتطابق مع الصورة)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: CustomAppBar(
                title: "تعديل بيانات المنتج",
                // أيقونة الرجوع (سهم لليمين)
                suffixsIcon: Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.textMain,
                  size: 26.sp,
                ),
                showRightIcon: false, // لإخفاء الأيقونة اليسرى وتوسيط العنوان
                onBackTap: () {
                  Navigator.pop(context);
                },
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    24.verticalSpace,

                    // 2. قسم صورة المنتج مع زر "تغيير الصورة"
                    const EditImageSection(),
                    24.verticalSpace,

                    // 3. نموذج الإدخال (الاسم، السعر، القسم، الوصف، والمخزون)
                    const EditProductForm(),
                    32.verticalSpace,

                    // 4. زر تحديث البيانات
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 0,
                        minimumSize: Size(double.infinity, 56.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "تحديث البيانات",
                            style: AppTextStyle.font18.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          8.horizontalSpace,
                          Icon(
                            Icons.save_outlined,
                            color: AppColors.white,
                            size: 24.sp,
                          ),
                        ],
                      ),
                    ),
                    16.verticalSpace,

                    // 5. زر حذف المنتج نهائياً
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 8.h,
                          ),
                          foregroundColor: AppColors.primary, // اللون الأحمر
                        ),
                        icon: Icon(Icons.delete_outline_rounded, size: 20.sp),
                        label: Text(
                          "حذف المنتج نهائياً",
                          style: AppTextStyle.font14.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    40.verticalSpace, // مساحة سفلية
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
