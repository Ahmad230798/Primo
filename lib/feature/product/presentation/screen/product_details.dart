import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/app_button.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';
import 'package:primo/core/widgets/custom_counter.dart';
import 'package:primo/feature/product/presentation/widgets/description_section.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(title: "Primo"),
                Image.asset("assets/images/tomato.png"),
                16.verticalSpace,
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "طماطم عضوية طازجة",
                        style: AppTextStyle.font32.copyWith(letterSpacing: 0),
                      ),
                    ),
                    5.horizontalSpace,
                    Text(
                      "24,50 ل.س",
                      style: AppTextStyle.font24.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                8.verticalSpace,
                Row(
                  children: [
                    const Icon(Icons.star_rate, color: AppColors.primary),
                    8.horizontalSpace,
                    Text(
                      "٤.٨ (١٢٠ تقييم)",
                      style: AppTextStyle.font14.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.greyMedium1,
                      ),
                    ),
                  ],
                ),
                DescriptionSection(),

                24.verticalSpace,
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: 1.sw,
        padding: EdgeInsets.only(
          left: 24.w,
          right: 24.w,
          top: 16.h,

          // استخدام MediaQuery لضمان عدم تداخل الأزرار مع خط الآيفون السفلي
          bottom: MediaQuery.of(context).padding.bottom > 0
              ? MediaQuery.of(context).padding.bottom
              : 16.h,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.r),
            topRight: Radius.circular(12.r),
          ),
          boxShadow: [
            // إضافة ظل خفيف جداً يفصل الشريط السفلي عن المحتوى بشكل أنيق
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        // 4. خاصية MainAxisSize.min مهمة جداً هنا لكي لا يملأ الـ Column الشاشة
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomCounter(),
            16.verticalSpace,
            AppButton(text: "أضف إلى السلة", icon: Icons.shopping_cart),
            24.verticalSpace,
          ],
        ),
      ),
    );
  }
}
