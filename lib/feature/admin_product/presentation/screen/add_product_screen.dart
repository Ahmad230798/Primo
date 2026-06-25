// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';

import '../widgets/image_upload_widget.dart';
import '../widgets/product_form_section.dart';
import '../widgets/product_variants_section.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // 1. شريط التنقل العلوي
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: CustomAppBar(
                    title: "إضافة منتج جديد",
                    suffixsIcon: Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColors.textMain,
                      size: 26.sp,
                    ),
                    icon: Icon(
                      Icons.notifications_none_rounded,
                      color: AppColors.textMain,
                      size: 26.sp,
                    ),
                    showRightIcon: true,
                    onBackTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),

                // 2. محتوى الصفحة القابل للتمرير
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        24.verticalSpace,

                        // قسم الصورة والمعلومات الأساسية
                        const ImageUploadWidget(),
                        24.verticalSpace,
                        const ProductFormSection(), // عدلناه لحذف حقل السعر منه

                        32.verticalSpace,

                        // قسم الأنواع والأحجام (الجديد)
                        const ProductVariantsSection(),

                        // مسافة فارغة أسفل الشاشة لضمان عدم تغطية الزر السفلي للمحتوى
                        120.verticalSpace,
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // 3. زر الحفظ السفلي العائم (Fixed Bottom Action)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 24.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppColors.background,
                      AppColors.background.withOpacity(0.9),
                      AppColors.background.withOpacity(0.0),
                    ],
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    minimumSize: Size(double.infinity, 56.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    shadowColor: AppColors.primary.withOpacity(0.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.save_outlined,
                        color: AppColors.white,
                        size: 24.sp,
                      ),
                      8.horizontalSpace,
                      Text(
                        "حفظ المنتج",
                        style: AppTextStyle.font18.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
