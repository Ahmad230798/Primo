import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

import 'stock_status_toggle.dart';

class EditProductForm extends StatelessWidget {
  const EditProductForm({super.key});

  @override
  Widget build(BuildContext context) {
    // تنسيق موحد للحدود (بدون حدود مع خلفية رمادية فاتحة)
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide.none,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. الاسم
        _buildLabel("الاسم"),
        8.verticalSpace,
        TextFormField(
          initialValue: "عسل سدر جبلي فاخر",
          style: AppTextStyle.font16.copyWith(color: AppColors.textMain),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.greyBackground,
            border: inputBorder,
            enabledBorder: inputBorder,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: AppColors.primary, width: 1),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
          ),
        ),
        16.verticalSpace,

        // 2. السعر
        _buildLabel("السعر (ر.س)"),
        8.verticalSpace,
        TextFormField(
          initialValue: "185.00",
          textDirection:
              TextDirection.ltr, // لضبط الأرقام من اليسار كما في الصورة
          textAlign: TextAlign.right, // لكن النص يظهر على اليمين
          style: AppTextStyle.font16.copyWith(color: AppColors.textMain),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.greyBackground,
            border: inputBorder,
            enabledBorder: inputBorder,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: AppColors.primary, width: 1),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
          ),
        ),
        16.verticalSpace,

        // 3. القسم (القائمة المنسدلة)
        _buildLabel("القسم"),
        8.verticalSpace,
        DropdownButtonFormField<String>(
          // ignore: deprecated_member_use
          value: "honey",
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.greyBackground,
            border: inputBorder,
            enabledBorder: inputBorder,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: AppColors.primary, width: 1),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
          ),
          icon: Icon(
            Icons.expand_more_rounded,
            color: AppColors.greyDark,
            size: 24.sp,
          ),
          items: [
            DropdownMenuItem(
              value: "honey",
              child: Text(
                "العسل والمربى",
                style: AppTextStyle.font16.copyWith(color: AppColors.textMain),
              ),
            ),
          ],
          onChanged: (val) {},
        ),
        16.verticalSpace,

        // 4. الوصف
        _buildLabel("الوصف"),
        8.verticalSpace,
        TextFormField(
          initialValue:
              "عسل سدر طبيعي 100% مستخرج من أفضل المناحل الجبلية. يتميز بطعمه الغني وقوامه الكثيف. مثالي للاستخدام اليومي وكبديل صحي للسكر.",
          style: AppTextStyle.font14.copyWith(
            color: AppColors.textMain,
            height: 1.6,
          ),
          maxLines: 4,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.greyBackground,
            border: inputBorder,
            enabledBorder: inputBorder,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: AppColors.primary, width: 1),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
          ),
        ),
        24.verticalSpace,

        // 5. حالة المخزون مع الـ Toggle
        const StockStatusToggle(),
      ],
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
