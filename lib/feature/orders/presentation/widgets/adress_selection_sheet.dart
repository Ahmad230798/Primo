import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class AddressSelectionSheet extends StatelessWidget {
  const AddressSelectionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // قائمة عناوين وهمية (Mock Data) للتجربة حتى يتم ربط الـ API
    final List<Map<String, String>> savedAddresses = [
      {
        "id": "1",
        "title": "المنزل",
        "details": "شارع التحلية، حي العليا، مبنى 45، شقة 12، الرياض",
      },
      {
        "id": "2",
        "title": "العمل",
        "details": "طريق الملك فهد، برج الفيصلية، الطابق 18، الرياض",
      },
    ];

    // معرف العنوان المختار حالياً (كمثال ثابت، سيأتي من الـ Cubit لاحقاً)
    const String selectedAddressId = "1";

    return Container(
      width: 1.sw,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // لتأخذ النافذة مساحة محتواها فقط
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // رأس النافذة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "اختر عنوان التوصيل",
                style: AppTextStyle.font20.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.textMain),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          16.verticalSpace,

          // قائمة العناوين المحفوظة
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: savedAddresses.length,
            separatorBuilder: (context, index) =>
                Divider(color: AppColors.formBorder, height: 24.h),
            itemBuilder: (context, index) {
              final address = savedAddresses[index];
              final isSelected = address["id"] == selectedAddressId;

              return InkWell(
                onTap: () {
                  // TODO: context.read<CheckoutCubit>().selectAddress(address["id"]);
                  Navigator.pop(context);
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: const BoxDecoration(
                        color: AppColors.greyBackground,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: AppColors.greyMedium1,
                      ),
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            address["title"]!,
                            style: AppTextStyle.font16.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          4.verticalSpace,
                          Text(
                            address["details"]!,
                            style: AppTextStyle.font14.copyWith(
                              color: AppColors.greyMedium3,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Radio<String>(
                      value: address["id"]!,
                      groupValue: selectedAddressId,
                      activeColor: AppColors.primary,
                      onChanged: (value) {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          24.verticalSpace,

          // زر إضافة عنوان جديد
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                // TODO: الانتقال لشاشة إضافة عنوان جديد (أو الخريطة)
              },
              icon: const Icon(
                Icons.add_location_alt_outlined,
                color: AppColors.primary,
              ),
              label: Text(
                "إضافة عنوان جديد",
                style: AppTextStyle.font14.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14.h),
                side: const BorderSide(color: AppColors.primary, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
          ),
          16.verticalSpace,
        ],
      ),
    );
  }
}
