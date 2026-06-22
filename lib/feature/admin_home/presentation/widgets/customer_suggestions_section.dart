import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'section_header.dart';
import 'suggestion_card.dart';

class CustomerSuggestionsSection extends StatelessWidget {
  const CustomerSuggestionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SectionHeader(title: "اقتراحات العملاء"),
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
              onProvide: () {},
              onIgnore: () {},
            );
          },
        ),
      ],
    );
  }
}
