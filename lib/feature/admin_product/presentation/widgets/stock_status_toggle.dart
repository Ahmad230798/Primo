// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class StockStatusToggle extends StatefulWidget {
  const StockStatusToggle({super.key});

  @override
  State<StockStatusToggle> createState() => _StockStatusToggleState();
}

class _StockStatusToggleState extends State<StockStatusToggle> {
  bool isAvailable = true; // القيمة الافتراضية كما في الصورة

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.formBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // النصوص
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "حالة المخزون",
                  style: AppTextStyle.font16.copyWith(
                    color: AppColors.textMain,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                4.verticalSpace,
                Text(
                  "تحديد ما إذا كان المنتج متوفراً للبيع",
                  style: AppTextStyle.font12.copyWith(
                    color: AppColors.greyMedium3,
                  ),
                ),
              ],
            ),
          ),

          // الـ Toggle الأزرق المخصص
          GestureDetector(
            onTap: () {
              setState(() {
                isAvailable = !isAvailable;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 50.w,
              height: 28.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(99.r),
                // اللون الأزرق في حالة التفعيل، أو رمادي في حالة التعطيل
                color: isAvailable
                    ? const Color(0xFF2563EB)
                    : AppColors.greyLight,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeIn,
                    // تغيير الاتجاه (يمين/يسار) بناءً على التفعيل
                    left: isAvailable ? 4.w : 22.w,
                    right: isAvailable ? 22.w : 4.w,
                    child: Container(
                      width: 22.w,
                      height: 22.w,
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: isAvailable
                          ? Icon(
                              Icons.check_rounded,
                              color: const Color(0xFF2563EB),
                              size: 16.sp,
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
