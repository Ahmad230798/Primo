import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';
import 'package:primo/core/widgets/profile_image_holder.dart';
import 'package:primo/feature/profile/presentation/widgets/info_card.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomAppBar(title: "Primo"),
                32.verticalSpace,
                ProfileImageHolder(
                  imagePath: "assets/images/profile_image.jpg",
                  icon: SizedBox(),
                ),
                24.verticalSpace,
                Text(
                  "أحمد المحمد",
                  style: AppTextStyle.font24.copyWith(
                    color: AppColors.textMain,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "0934107141",
                  style: AppTextStyle.font16.copyWith(
                    color: AppColors.greyMedium2,
                  ),
                ),
                InfoCard(
                  text: "عناويني المحفوظة",
                  iconData: Icons.location_on,
                  onTap: () => Navigator.pushNamed(context, Routes.addresses),
                ),
                8.verticalSpace,
                InfoCard(
                  text: "سجل المشتريات",
                  iconData: Icons.receipt_long_outlined,
                  onTap: () =>
                      Navigator.pushNamed(context, Routes.orderHistory),
                ),
                8.verticalSpace,
                InfoCard(
                  text: "الإعدادات",
                  iconData: Icons.settings_outlined,
                  onTap: () => Navigator.pushNamed(context, Routes.settings),
                ),
                8.verticalSpace,
                InfoCard(
                  text: "مركز المساعدة",
                  iconData: Icons.support_agent_sharp,
                  onTap: () {}, // TODO: مسار مركز المساعدة
                ),
                32.verticalSpace,
                InfoCard(
                  text: "تسجيل الخروج",
                  iconData: Icons.logout,
                  iconContainerColor: AppColors.quantityBackground,
                  textColor: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  borderColor: AppColors.quantityBackground,
                  onTap: () {
                    // مسح الكاش والتوجه لتسجيل الدخول
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      Routes.login,
                      (route) => false,
                    );
                  },
                ),
                30.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
