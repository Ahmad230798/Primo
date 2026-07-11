import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/helper/navigation.dart';
import 'package:primo/core/helper/snack_bar_helper.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/feature/admin_home/data/models/admin_dashboard_model.dart';
import 'section_header.dart';
import 'suggestion_card.dart';

class CustomerSuggestionsSection extends StatelessWidget {
  final List<SuggestionModel>? suggestions;

  const CustomerSuggestionsSection({super.key, this.suggestions});

  @override
  Widget build(BuildContext context) {
    final list = suggestions ?? [];
    return Column(
      children: [
        SectionHeader(
          title: "اقتراحات العملاء",
          actionText: "عرض الكل",
          onActionTap: () {
            context.pushNamed(Routes.adminSuggestions);
          },
        ),
        16.verticalSpace,
        if (list.isEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 32.h),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.formBorder),
            ),
            child: Center(
              child: Text(
                "لا توجد مقترحات حالياً",
                style: AppTextStyle.font16.copyWith(
                  color: AppColors.greyDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: list.length > 5 ? 5 : list.length,
            separatorBuilder: (context, index) => 12.verticalSpace,
            itemBuilder: (context, index) {
              final item = list[index];
              return SuggestionCard(
                suggestionText: item.description ?? "مقترح #${item.id}",
                userName: item.name,
                onProvide: () {
                  context.pushNamed(Routes.addProducts);
                },
                onIgnore: () {
                  context.showInfo("تم تجاهل المقترح");
                },
              );
            },
          ),
      ],
    );
  }
}
