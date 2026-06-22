// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class OfferTypeToggle extends StatefulWidget {
  const OfferTypeToggle({super.key});

  @override
  State<OfferTypeToggle> createState() => _OfferTypeToggleState();
}

class _OfferTypeToggleState extends State<OfferTypeToggle> {
  bool isPercentage = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.greyBackground,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Stack(
        children: [
          // الخلفية البيضاء المتحركة (الشريحة)
          AnimatedAlign(
            alignment: isPercentage
                ? Alignment.centerRight
                : Alignment.centerLeft,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // النصوص (الأزرار)
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => isPercentage = true),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Text(
                      "نسبة مئوية %",
                      style: AppTextStyle.font14.copyWith(
                        color: isPercentage
                            ? AppColors.textMain
                            : AppColors.greyMedium3,
                        fontWeight: isPercentage
                            ? FontWeight.bold
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => isPercentage = false),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Text(
                      "مبلغ ثابت",
                      style: AppTextStyle.font14.copyWith(
                        color: !isPercentage
                            ? AppColors.textMain
                            : AppColors.greyMedium3,
                        fontWeight: !isPercentage
                            ? FontWeight.bold
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
