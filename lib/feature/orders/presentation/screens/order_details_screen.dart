import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/app_button.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';
import 'package:primo/feature/orders/presentation/widgets/build_summary_row.dart';
import 'package:primo/feature/orders/presentation/widgets/order_info_card.dart';
import 'package:primo/feature/orders/presentation/widgets/order_item_card.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // --- 1. AppBar المطابق للتصميم ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: CustomAppBar(
                title: "تفاصيل الطلب #8492",
                showRightIcon: true,
                icon: Icon(
                  Icons.shopping_bag_outlined,
                  color: AppColors.textMain,
                  size: 28.sp,
                ),
              ),
            ),

            // --- 2. محتوى الشاشة ---
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // بطاقة معلومات الطلب
                    const OrderInfoCard(),
                    24.verticalSpace,

                    // عنوان قسم المنتجات
                    Text(
                      "المنتجات (3)",
                      style: AppTextStyle.font16.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textMain,
                      ),
                    ),
                    16.verticalSpace,

                    // قائمة المنتجات (تم استخدام بيانات ثابتة مطابقة للصورة للتجربة)
                    ListView.builder(
                      itemCount: 3,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return OrderItemCard(
                          title: "قهوة مختصة إثيوبية",
                          weight: "250 جرام",
                          quantity: 2,
                          price: "120",
                          imagePath: "assets/images/coffe.png",
                        );
                      },
                    ), // --- 3. ملخص الفاتورة النهائي ---
                    24.verticalSpace,
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: AppColors.formBorder.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          BuildSummaryRow(
                            title: "المجموع الفرعي",
                            value: "SAR 250",
                          ),
                          12.verticalSpace,
                          BuildSummaryRow(
                            title: "رسوم التوصيل",
                            value: "SAR 15",
                          ),
                          16.verticalSpace,
                          Divider(color: AppColors.formBorder, thickness: 1),
                          16.verticalSpace,
                          BuildSummaryRow(
                            title: "الإجمالي",
                            value: "SAR 265",
                            isTotal: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- 4. الزر السفلي (إعادة الطلب) ---
            Container(
              padding: EdgeInsets.only(
                left: 24.w,
                right: 24.w,
                bottom: 24.h,
                top: 16.h,
              ),
              decoration: const BoxDecoration(color: AppColors.background),
              child: AppButton(
                text: "إعادة طلب هذه المنتجات",
                icon: Icons.add_shopping_cart,
                onPressed: () {
                  // TODO: إضافة المنتجات لسلة المشتريات
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // دالة مساعدة لرسم أسطر ملخص الفاتورة
}
