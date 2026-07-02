import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/helper/navigation.dart';
import 'package:primo/core/helper/snack_bar_helper.dart';
import 'package:primo/core/routing/routes.dart';
import 'section_header.dart';
import 'suggestion_card.dart';

class CustomerSuggestionsSection extends StatelessWidget {
  const CustomerSuggestionsSection({super.key});

  @override
  Widget build(BuildContext context) {
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
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 2,
          separatorBuilder: (context, index) => 12.verticalSpace,
          itemBuilder: (context, index) {
            return SuggestionCard(
              suggestionText: index == 0
                  ? '"أتمنى توفير حليب لوز خالي من السكر من شركة معينة، بحثت عنه ولم أجده."'
                  : '"نحتاج قسم خاص للمنتجات العضوية المحلية، سيكون إضافة ممتازة."',
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
