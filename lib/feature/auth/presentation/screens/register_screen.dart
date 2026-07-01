import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import 'package:primo/core/helper/navigation.dart';
import 'package:primo/core/helper/snack_bar_helper.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';
import 'package:primo/feature/auth/presentation/cubit/register_cubit.dart';
import 'package:primo/feature/auth/presentation/cubit/register_state.dart';
import 'package:primo/feature/auth/presentation/widgets/register_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // أضفنا BlocConsumer هنا ليكون هو الغلاف الأساسي للشاشة
        child: BlocConsumer<RegisterCubit, RegisterState>(
          listenWhen: (previous, current) =>
              current is RegisterError || current is RegisterSuccess,
          listener: (context, state) {
            if (state is RegisterError) {
              context.showError(state.error); // إظهار الخطأ
            } else if (state is RegisterSuccess) {
              context.showSuccess(
                state.registerResponse.data?.message ??
                    "تم إرسال كود التحقق بنجاح",
              );
              if (state.registerResponse.data?.otpRequired == true) {
                // جلب رقم الهاتف من الـ Cubit لتمريره للشاشة التالية
                final phoneNumber = context
                    .read<RegisterCubit>()
                    .phoneController
                    .text;

                // الانتقال لشاشة الـ OTP مع تمرير رقم الهاتف
                context.pushNamed(
                  Routes
                      .otpVerification, // تأكد من اسم الروت الخاص بك في ملف Routes
                  arguments: phoneNumber,
                );
              } else {
                // كإجراء احتياطي: إذا لم يطلب السيرفر OTP، نوجهه لتسجيل الدخول
                context.pushNamedAndRemoveUntil(Routes.home);
              }
            }
          },
          buildWhen: (previous, current) =>
              current is RegisterLoading ||
              current is RegisterError ||
              current is RegisterSuccess ||
              current is RegisterInitial,
          builder: (context, state) {
            return SingleChildScrollView(
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

                    // تمرير الحالة الحالية للـ Form للتحكم بزر التحميل
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
                            context.pop();
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
            );
          },
        ),
      ),
    );
  }
}
