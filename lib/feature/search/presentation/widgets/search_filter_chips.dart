import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/feature/search/presentation/cubit/search_cubit.dart';
import 'package:primo/feature/search/presentation/cubit/search_state.dart';

class SearchFilterChips extends StatelessWidget {
  const SearchFilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    final filters = [
      "الكل",
      "الأقل سعراً",
      "الأعلى سعراً",
      "الأعلى تقييماً",
      "وصل حديثاً"
    ];

    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        final activeFilter = context.read<SearchCubit>().activeFilter;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Row(
            children: filters.map((title) {
              final isActive = title == activeFilter;

              return Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: InkWell(
                  onTap: () {
                    context.read<SearchCubit>().applyFilter(title);
                  },
                  borderRadius: BorderRadius.circular(99.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.textMain : AppColors.white,
                      borderRadius: BorderRadius.circular(99.r),
                      border: isActive
                          ? null
                          : Border.all(color: AppColors.formBorder),
                    ),
                    child: Text(
                      title,
                      style: AppTextStyle.font12.copyWith(
                        color: isActive ? AppColors.white : AppColors.greyDark,
                        fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
