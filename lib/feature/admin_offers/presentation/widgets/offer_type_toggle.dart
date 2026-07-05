// استبدل كود offer_type_toggle.dart بالكامل بهذا لتوصيله بالـ Cubit
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import '../cubit/admin_offers_cubit.dart';
import '../cubit/admin_offers_state.dart';

class OfferTypeToggle extends StatelessWidget {
  const OfferTypeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminOffersCubit, AdminOffersState>(
      buildWhen: (prev, current) => current is AdminOffersUIChanged,
      builder: (context, state) {
        final cubit = context.read<AdminOffersCubit>();
        final isPercentage = cubit.isPercentage;

        return Container(
          height: 52.h,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppColors.greyBackground,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Stack(
            children: [
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
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => cubit.changeOfferType(true),
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
                      onTap: () => cubit.changeOfferType(false),
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
      },
    );
  }
}
