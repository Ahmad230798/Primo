import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/helper/navigation.dart';
import 'package:primo/core/helper/snack_bar_helper.dart';
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
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<LoginCubit, LoginState>(
          listenWhen: (previous, current) =>
              current is LoginError || current is LoginSuccess,
          listener: (context, state) {
            if (state is LoginError) {
              context.showError(state.error);
            } else if (state is LoginSuccess) {
              context.showSuccess(
                state.loginResponse.message ?? "تم تسجيل الدخول بنجاح",
              );
              context.pushNamedAndRemoveUntil(Routes.home);
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
    );
  }
}
