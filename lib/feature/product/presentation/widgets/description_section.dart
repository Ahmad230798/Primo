import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/app_button.dart';

class DescriptionSection extends StatelessWidget {
  const DescriptionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: AppColors.greyBackground,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("الوصف", style: AppTextStyle.font20),
          8.verticalSpace,
          Text(
            "طماطم عضوية مقطوفة حديثاً من مزارعنا المحلية. تتميز بلونها الأحمر الزاهي وطعمهاالغني الذي يضفي نكهة مميزة لصلصاتكوسلطاتك. خالية تماماً من المبيدات الحشريةوالمواد الكيميائية لضمان صحتك وصحة عائلتك.",
            style: AppTextStyle.font16.copyWith(color: AppColors.greyMedium2),
          ),
          32.verticalSpace,
          Container(
            width: 1.sw,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.quantityBackground),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.lightbulb_sharp, color: AppColors.primary),
                    8.horizontalSpace,
                    Expanded(
                      child: Text(
                        "لم تجد ما تبحث عنه؟؟ ",
                        style: AppTextStyle.font20.copyWith(
                          color: AppColors.textMain,
                        ),
                      ),
                    ),
                  ],
                ),
                6.8.verticalSpace,
                Text(
                  "اقترح منتجاً وسنعمل على توفيره لك في أقرب وقت.",
                  style: AppTextStyle.font16,
                ),
                16.verticalSpace,
                AppButton(
                  text: "اطلب توفير منتج",
                  onPressed: () =>
                      Navigator.pushNamed(context, Routes.suggestProduct),
                ),
                24.verticalSpace,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
