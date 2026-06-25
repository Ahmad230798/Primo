import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class SearchAndFilterWidget extends StatelessWidget {
  const SearchAndFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // حقل البحث
        Expanded(
          child: Container(
            height: 48.h,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(99.r), // شكل كبسولة
              border: Border.all(color: AppColors.formBorder),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  color: AppColors.greyMedium3,
                  size: 24.sp,
                ),
                12.horizontalSpace,
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "البحث برقم المنتج أو الاسم...",
                      hintStyle: AppTextStyle.font14.copyWith(
                        color: AppColors.greyMedium3,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    style: AppTextStyle.font14.copyWith(
                      color: AppColors.textMain,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        12.horizontalSpace,
        // زر الفلترة
        Container(
          width: 48.w,
          height: 48.h,
          decoration: BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.formBorder),
          ),
          child: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.filter_list_rounded,
              color: AppColors.greyDark,
              size: 24.sp,
            ),
          ),
        ),
      ],
    );
  }
}
