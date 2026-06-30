import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class RequestProductSection extends StatelessWidget {
  const RequestProductSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: AppColors.greyBackground,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Column(
          children: [
            Text(
              "لم تجد ما تبحث عنه؟",
              style: AppTextStyle.font18.copyWith(
                color: AppColors.textMain,
                fontWeight: FontWeight.bold,
              ),
            ),
            8.verticalSpace,
            Text(
              "أخبرنا بالمنتج الذي تريده وسنقوم بتوفيره لك في أقرب وقت ممكن.",
              style: AppTextStyle.font14.copyWith(
                color: AppColors.greyMedium3,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            24.verticalSpace,
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.suggestProduct);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                elevation: 0,
                minimumSize: Size(double.infinity, 52.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                shadowColor: AppColors.primary.withValues(alpha: 0.4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    color: AppColors.white,
                    size: 20.sp,
                  ),
                  8.horizontalSpace,
                  Text(
                    "اطلب توفير المنتج",
                    style: AppTextStyle.font16.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
