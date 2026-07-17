import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/feature/admin_offers/presentation/cubit/admin_offers_cubit.dart';
import 'package:primo/feature/admin_offers/presentation/cubit/admin_offers_state.dart';

class CalculationCard extends StatelessWidget {
  const CalculationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminOffersCubit, AdminOffersState>(
      builder: (context, state) {
        final cubit = context.read<AdminOffersCubit>();
        final before = cubit.priceBeforeDiscount;
        final after = cubit.priceAfterDiscount;

        return Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: const Color(0xFF3C3837),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "السعر قبل الخصم:",
                    style: AppTextStyle.font14.copyWith(
                      color: AppColors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Text(
                      cubit.selectedVariant?.formatPrice(before.toStringAsFixed(0)) ?? "${before.toStringAsFixed(0)} ل.س",
                      key: ValueKey<double>(before),
                      style: AppTextStyle.font16.copyWith(
                        color: AppColors.white.withValues(alpha: 0.6),
                        decoration: TextDecoration.lineThrough,
                        decorationColor: AppColors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ],
              ),
              16.verticalSpace,
              Divider(color: AppColors.white.withValues(alpha: 0.1), height: 1),
              16.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "السعر بعد الخصم:",
                    style: AppTextStyle.font16.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Text(
                      cubit.selectedVariant?.formatPrice(after.toStringAsFixed(0)) ?? "${after.toStringAsFixed(0)} ل.س",
                      key: ValueKey<double>(after),
                      style: AppTextStyle.font24.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
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
