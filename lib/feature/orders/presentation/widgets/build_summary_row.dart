import 'package:flutter/material.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class BuildSummaryRow extends StatelessWidget {
  const BuildSummaryRow({
    super.key,
    required this.title,
    required this.value,
    this.isTotal,
  });

  final String title;
  final String value;
  final bool? isTotal;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: isTotal??false
              ? AppTextStyle.font16.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMain,
                )
              : AppTextStyle.font14.copyWith(color: AppColors.greyMedium1),
        ),
        Text(
          value,
          style: isTotal??false
              ? AppTextStyle.font16.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                )
              : AppTextStyle.font14.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMain,
                ),
        ),
      ],
    );
  }
}
