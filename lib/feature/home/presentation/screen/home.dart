import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/app_text_form_field.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';
import 'package:primo/feature/home/presentation/widgets/activities_list.dart';
import 'package:primo/feature/home/presentation/widgets/catigory_section.dart';
import 'package:primo/feature/home/presentation/widgets/latest_product.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: SingleChildScrollView(
            // التعديل الوحيد هنا: أضفنا مسافة سفلية بمقدار 120
            padding: EdgeInsets.only(bottom: 120.h),
            child: Column(
              children: [
                CustomAppBar(
                  title: "Primo",
                  showRightIcon: true,
                  icon: Icon(
                    Icons.notifications_none_rounded,
                    color: AppColors.primary,
                    size: 28,
                  ),
                  onRightIconTap: () => Navigator.pushNamed(context, Routes.notifications),
                  suffixsIcon: Icon(Icons.person, color: AppColors.primary, size: 28),
                ),
                8.verticalSpace,
                // في ملف home.dart ، استبدل AppTextFormField بهذا الكود:
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.searchResults);
                  },
                  // وضعنا AbsorbPointer لمنع الكيبورد من الظهور في الشاشة الرئيسية، ليتم النقر فقط ونقله لشاشة البحث
                  child: AbsorbPointer(
                    child: AppTextFormField(
                      prefixIcone: const Icon(
                        Icons.search,
                        size: 25,
                        color: AppColors.primary,
                      ),
                      hinttText: "ابحث في Primo...",
                      borderWidth: 0,
                      fillColor: AppColors.formBorder,
                      isFilled: true,
                    ),
                  ),
                ),
                33.verticalSpace,
                const ActivitiesList(),
                41.verticalSpace,
                const CatigorySection(),
                32.verticalSpace,
                Row(
                  children: [
                    Container(
                      width: 6.w,
                      height: 24.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        color: AppColors.primary,
                      ),
                    ),
                    8.horizontalSpace,
                    Text(
                      "أضيف مؤخرا",
                      style: AppTextStyle.font20.copyWith(
                        color: AppColors.textMain,
                      ),
                    ),
                  ],
                ),
                16.verticalSpace,
                const LatestProduct(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
