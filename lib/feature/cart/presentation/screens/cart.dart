import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/app_button.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';
import 'package:primo/feature/cart/presentation/widgets/cart_item_list.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                CustomAppBar(
                  title: "Primo",
                  icon: Icon(
                    Icons.notifications_none,
                    color: AppColors.greyMedium1,
                  ),
                ),
                20.verticalSpace,
                Row(
                  children: [
                    Text("عربة التسوق", style: AppTextStyle.font20),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.formBorder,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        "3 عناصر",
                        style: AppTextStyle.font14.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.greyMedium2,
                        ),
                      ),
                    ),
                  ],
                ),
                16.verticalSpace,
                CartItemList(),
                32.verticalSpace,
                // في ملف cart.dart، استبدل الـ AppButton الأخير بهذا الكود:
                AppButton(
                  text: "متابعة للدفع",
                  icon: Icons.arrow_forward,
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.checkoutScreen);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
