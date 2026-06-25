import 'package:flutter/material.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class SummaryRow extends StatelessWidget {
  final String title;
  final String value;
  final bool isTotal;

  const SummaryRow({
    super.key,
    required this.title,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: isTotal
              ? AppTextStyle.font18.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                )
              : AppTextStyle.font16.copyWith(
                  color: AppColors.greyMedium1,
                ),
        ),
        Text(
          value,
          style: isTotal
              ? AppTextStyle.font18.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                )
              : AppTextStyle.font16.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMain,
                ),
        ),
      ],
    );
  }
}