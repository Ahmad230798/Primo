// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class ProductVariantsSection extends StatefulWidget {
  const ProductVariantsSection({super.key});

  @override
  State<ProductVariantsSection> createState() => _ProductVariantsSectionState();
}

class _ProductVariantsSectionState extends State<ProductVariantsSection> {
  // قائمة وهمية لتخزين عدد الأحجام/الأنواع. في الوضع الحقيقي سيتم ربطها بالـ Bloc
  List<int> variants = [0, 1];

  void _addVariant() {
    setState(() {
      variants.add(DateTime.now().millisecondsSinceEpoch); // إضافة عنصر جديد
    });
  }

  void _removeVariant(int index) {
    setState(() {
      variants.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // عنوان القسم
        Text(
          "أنواع وأحجام المنتج",
          style: AppTextStyle.font18.copyWith(
            color: AppColors.textMain,
            fontWeight: FontWeight.bold,
          ),
        ),
        16.verticalSpace,

        // قائمة الأنواع
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: variants.length,
          separatorBuilder: (context, index) => 16.verticalSpace,
          itemBuilder: (context, index) {
            return _buildVariantCard(index);
          },
        ),

        16.verticalSpace,

        // زر "إضافة حجم أو نوع آخر"
        InkWell(
          onTap: _addVariant,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 14.h),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.textMain, width: 1.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_rounded, color: AppColors.textMain, size: 22.sp),
                8.horizontalSpace,
                Text(
                  "إضافة حجم أو نوع آخر",
                  style: AppTextStyle.font16.copyWith(
                    color: AppColors.textMain,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // بطاقة النوع الواحد (حجم، سعر، كمية، حذف)
  Widget _buildVariantCard(int index) {
    final borderStyle = OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.formBorder, width: 1),
      borderRadius: BorderRadius.circular(12.r),
    );

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.formBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // حقل النوع / الحجم
          _buildLabel("النوع / الحجم"),
          8.verticalSpace,
          TextFormField(
            decoration: InputDecoration(
              hintText: index == 0 ? "4 كيلو لافندر" : "مثال: 2 كيلو ليمون",
              hintStyle: AppTextStyle.font14.copyWith(
                color: AppColors.greyMedium3,
              ),
              filled: true,
              fillColor: AppColors.white,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
              border: borderStyle,
              enabledBorder: borderStyle,
              focusedBorder: borderStyle.copyWith(
                borderSide: BorderSide(color: AppColors.primary, width: 1),
              ),
            ),
          ),
          16.verticalSpace,

          // السعر والكمية في سطر واحد
          Row(
            children: [
              // السعر
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("السعر"),
                    8.verticalSpace,
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: index == 0 ? "45" : "0",
                        hintStyle: AppTextStyle.font14.copyWith(
                          color: AppColors.greyMedium3,
                        ),
                        filled: true,
                        fillColor: AppColors.white,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        border: borderStyle,
                        enabledBorder: borderStyle,
                        focusedBorder: borderStyle.copyWith(
                          borderSide: BorderSide(
                            color: AppColors.primary,
                            width: 1,
                          ),
                        ),
                        // كلمة ر.س على اليسار
                        prefixIcon: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "ر.س",
                              style: AppTextStyle.font12.copyWith(
                                color: AppColors.greyMedium3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              12.horizontalSpace,
              // الكمية
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("الكمية"),
                    8.verticalSpace,
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: index == 0 ? "20" : "0",
                        hintStyle: AppTextStyle.font14.copyWith(
                          color: AppColors.greyMedium3,
                        ),
                        filled: true,
                        fillColor: AppColors.white,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        border: borderStyle,
                        enabledBorder: borderStyle,
                        focusedBorder: borderStyle.copyWith(
                          borderSide: BorderSide(
                            color: AppColors.primary,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          16.verticalSpace,

          // زر الحذف
          Align(
            alignment: Alignment.centerRight, // لجعله في الزاوية
            child: InkWell(
              onTap: () => _removeVariant(index),
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: const Color(
                    0xFFFFDAD6,
                  ), // لون أحمر فاتح جداً مطابق للصورة
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.primary,
                  size: 22.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: AppTextStyle.font12.copyWith(
        color: AppColors.greyDark,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
