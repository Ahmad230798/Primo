// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/admin_drawer.dart';

import '../widgets/calculation_card.dart';
import '../widgets/offer_type_toggle.dart';

class CreateOfferScreen extends StatelessWidget {
  const CreateOfferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // ربط القائمة الجانبية وتمرير المسار الحالي لتمييزه
      drawer: const AdminDrawer(currentRoute: Routes.adminOffers),

      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // 1. الهيدر المخصص (Drawer + Notifications)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 16.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border(
                      bottom: BorderSide(color: AppColors.formBorder, width: 1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // أيقونة الإشعارات (يمين)
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.notifications);
                        },
                        borderRadius: BorderRadius.circular(99.r),
                        child: Padding(
                          padding: EdgeInsets.all(4.w),
                          child: Icon(
                            Icons.notifications_none_rounded,
                            color: AppColors.textMain,
                            size: 28.sp,
                          ),
                        ),
                      ),

                      // العنوان (في المنتصف باللون الأحمر كما في التصميم)
                      Text(
                        "إدارة العروض والخصومات",
                        style: AppTextStyle.font18.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // أيقونة القائمة / Drawer (يسار)
                      Builder(
                        builder: (innerContext) => InkWell(
                          onTap: () => Scaffold.of(innerContext).openDrawer(),
                          borderRadius: BorderRadius.circular(99.r),
                          child: Padding(
                            padding: EdgeInsets.all(4.w),
                            child: Icon(
                              Icons.menu_rounded,
                              color: AppColors.textMain,
                              size: 28.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. محتوى الصفحة
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        24.verticalSpace,

                        // اختيار المنتج
                        _buildSectionLabel("اختر المنتج والتركيبة"),
                        8.verticalSpace,
                        _buildShadowContainer(
                          child: DropdownButtonFormField<String>(
                            decoration: _inputDecoration(),
                            icon: Icon(
                              Icons.expand_more_rounded,
                              color: AppColors.greyDark,
                              size: 24.sp,
                            ),
                            items: [
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
                            value: "1",
                          ),
                        ),
                        24.verticalSpace,

                        // نوع الخصم (مفتاح تبديل مخصص)
                        _buildSectionLabel("نوع الخصم"),
                        8.verticalSpace,
                        const OfferTypeToggle(),
                        24.verticalSpace,

                        // قيمة الخصم
                        _buildSectionLabel("قيمة الخصم"),
                        8.verticalSpace,
                        _buildShadowContainer(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration(
                              hintText: "أدخل قيمة الخصم",
                              // الأيقونة على اليسار (suffixIcon في RTL)
                              suffixIcon: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "%",
                                    style: AppTextStyle.font20.copyWith(
                                      color: AppColors.greyDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        24.verticalSpace,

                        // تواريخ العرض (شبكة)
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSectionLabel("تاريخ بداية العرض"),
                                  8.verticalSpace,
                                  _buildShadowContainer(
                                    child: TextFormField(
                                      readOnly: true,
                                      decoration: _inputDecoration(
                                        hintText: "mm/dd/yyyy",
                                        suffixIcon: Icon(
                                          Icons.calendar_month_outlined,
                                          color: AppColors.greyMedium3,
                                          size: 20.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            16.horizontalSpace,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSectionLabel("تاريخ نهاية العرض"),
                                  8.verticalSpace,
                                  _buildShadowContainer(
                                    child: TextFormField(
                                      readOnly: true,
                                      decoration: _inputDecoration(
                                        hintText: "mm/dd/yyyy",
                                        suffixIcon: Icon(
                                          Icons.calendar_month_outlined,
                                          color: AppColors.greyMedium3,
                                          size: 20.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        24.verticalSpace,

                        // 3. بطاقة الحساب الداكنة
                        const CalculationCard(),

                        120.verticalSpace, // مساحة للزر السفلي
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // 4. زر التفعيل السفلي الثابت
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
                decoration: BoxDecoration(
                  color: AppColors.background.withOpacity(0.95),
                  border: Border(
                    top: BorderSide(
                      color: AppColors.formBorder.withOpacity(0.5),
                    ),
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.adminHome);
                  },
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
                      Text(
                        "تفعيل العرض",
                        style: AppTextStyle.font18.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      8.horizontalSpace,
                      Icon(
                        Icons.check_circle_outline_rounded,
                        color: AppColors.white,
                        size: 24.sp,
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

  // --- دوال مساعدة للتنسيق ---

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: AppTextStyle.font12.copyWith(
        color: AppColors.greyDark,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // حاوية الظل لإعطاء الحقول شكل الـ Elevation الخفيف المطلوب في التصميم
  Widget _buildShadowContainer({required Widget child}) {
    return Container(
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
      child: child,
    );
  }

  InputDecoration _inputDecoration({String? hintText, Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: AppTextStyle.font14.copyWith(color: AppColors.greyMedium3),
      filled: true,
      fillColor: AppColors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppColors.primary, width: 1),
      ),
      suffixIcon: suffixIcon,
    );
  }
}
