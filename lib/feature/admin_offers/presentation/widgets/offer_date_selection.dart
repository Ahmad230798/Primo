// استبدل كود offer_date_selection.dart بهذا
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import '../cubit/admin_offers_cubit.dart';
import '../cubit/admin_offers_state.dart';

class OfferDateSelection extends StatelessWidget {
  const OfferDateSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminOffersCubit, AdminOffersState>(
      buildWhen: (prev, current) => current is AdminOffersUIChanged,
      builder: (context, state) {
        final cubit = context.read<AdminOffersCubit>();

        return Row(
          children: [
            Expanded(
              child: _buildDatePicker(
                context,
                label: "تاريخ بداية العرض",
                hint: cubit.startDateText,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) cubit.setStartDate(date);
                },
              ),
            ),
            16.horizontalSpace,
            Expanded(
              child: _buildDatePicker(
                context,
                label: "تاريخ نهاية العرض",
                hint: cubit.endDateText,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: cubit.startDate ?? DateTime.now(),
                    firstDate: cubit.startDate ?? DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) cubit.setEndDate(date);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDatePicker(
    BuildContext context, {
    required String label,
    required String hint,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.font12.copyWith(
            color: AppColors.greyDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        8.verticalSpace,
        Container(
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
          child: TextFormField(
            readOnly: true,
            onTap: onTap,
            textDirection: TextDirection.ltr,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyle.font14.copyWith(
                color: AppColors.textMain,
                fontWeight: FontWeight.w500,
              ),
              filled: true,
              fillColor: AppColors.white,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 14.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              suffixIcon: Icon(
                Icons.calendar_month_outlined,
                color: AppColors.greyMedium3,
                size: 20.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
