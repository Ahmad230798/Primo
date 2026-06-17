import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';
import 'package:primo/feature/auth/presentation/widgets/register_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(title: 'Primo'),
                32.verticalSpace,
                Text(
                  "انضم إلى عائلة Primo",
                  style: AppTextStyle.font30.copyWith(
                    color: AppColors.textMain,
                  ),
                ),
                6.verticalSpace,
                Text(
                  "أنشئ حسابك للوصول إلى تشكيلة واسعة من\nالمنتجات الفاخرة.",
                  style: AppTextStyle.font16.copyWith(
                    color: AppColors.greyMedium1,
                    letterSpacing: 0,
                  ),
                ),
                32.verticalSpace,
                RegisterForm(),
                16.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "لديك حساب بالفعل؟ ",
                      style: AppTextStyle.font16.copyWith(
                        color: AppColors.greyMedium2,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "تسجيل الدخول",
                        style: AppTextStyle.font16.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                50.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
