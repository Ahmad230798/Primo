import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/helper/navigation.dart';
import 'package:primo/core/helper/snack_bar_helper.dart';
import 'package:primo/core/routing/otp_enum.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/feature/auth/presentation/cubit/login_cubit.dart';
import 'package:primo/feature/auth/presentation/cubit/login_state.dart';
import 'package:primo/feature/auth/presentation/widgets/log_in_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      // 3. تحديد ماذا يحدث عند الضغط على زر الرجوع
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        // إغلاق التطبيق بالكامل والخروج منه بأمان
        SystemNavigator.pop();
      },
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<LoginCubit, LoginState>(
            listenWhen: (previous, current) =>
                current is LoginError ||
                current is LoginSuccess ||
                current is LoginRequiresOtp,
            listener: (context, state) {
              if (state is LoginError) {
                context.showError(state.error);
              } else if (state is LoginRequiresOtp) {
                // إظهار تنبيه للمستخدم (مثلاً: تم إرسال كود التحقق إلى واتساب)
                context.showSuccess(state.message);

                // جلب الرقم من الحقل
                final phoneNumber = context
                    .read<LoginCubit>()
                    .phoneController
                    .text;

                // التوجيه إلى شاشة الـ OTP مع اعتبارها عملية "تسجيل" ليكمل التفعيل
                context.pushNamed(
                  Routes.otpVerification,
                  arguments: OtpVerificationArgs(
                    phoneNumber: phoneNumber,
                    otpType: OtpType.register,
                  ),
                );
              } else if (state is LoginSuccess) {
                final isAdmin = state.loginResponse.data?.user?.isAdmin ?? 0;
                context.showSuccess(
                  state.loginResponse.message ?? "تم تسجيل الدخول بنجاح",
                );
                if (isAdmin == 1) {
                  // توجيه الإدمن إلى لوحة التحكم (Dashboard)
                  context.pushNamedAndRemoveUntil(Routes.adminHome);
                } else {
                  // توجيه المستخدم العادي إلى التطبيق
                  context.pushNamedAndRemoveUntil(Routes.userMainLayout);
                }
              }
            },
            buildWhen: (previous, current) =>
                current is LoginLoading ||
                current is LoginError ||
                current is LoginSuccess ||
                current is LoginInitial,
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Primo",
                          style: AppTextStyle.font24.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        7.19.verticalSpace,
                        Text(
                          "مرحباً بعودتك!",
                          style: AppTextStyle.font32.copyWith(
                            color: AppColors.textMain,
                          ),
                        ),
                        6.39.verticalSpace,
                        Text(
                          "سجل الدخول للمتابعة إلى حسابك",
                          style: AppTextStyle.font16.copyWith(
                            color: AppColors.greyMedium2,
                          ),
                        ),
                        32.verticalSpace,
                        LogInForm(),
                        32.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "ليس لديك حساب؟ ",
                              style: AppTextStyle.font16.copyWith(
                                color: AppColors.greyMedium2,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                context.pushNamed(Routes.register);
                              },
                              child: Text(
                                "إنشاء حساب جديد",
                                style: AppTextStyle.font16.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
