import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class OfferProductDropdown extends StatelessWidget {
  const OfferProductDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "اختر المنتج",
          style: AppTextStyle.font12.copyWith(
            color: AppColors.greyDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        8.verticalSpace,
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.white,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 14.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
            ),
            icon: Icon(
              Icons.expand_more_rounded,
              color: AppColors.greyDark,
              size: 24.sp,
            ),
            hint: Text(
              "اختر منتجاً لتطبيق العرض عليه",
              style: AppTextStyle.font14.copyWith(color: AppColors.greyMedium3),
            ),
            items: [
              // TODO: سيتم جلب هذه القائمة من الـ Cubit لاحقاً
              DropdownMenuItem(
                value: "1",
                child: Text(
                  "دواء غسيل - 4 كيلو لافندر",
                  style: AppTextStyle.font14.copyWith(
                    color: AppColors.textMain,
                  ),
                ),
              ),
            ],
            onChanged: (val) {},
          ),
        ),
      ],
    );
  }
}
