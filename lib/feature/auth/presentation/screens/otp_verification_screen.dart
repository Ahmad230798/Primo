// ignore_for_file: deprecated_member_use

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/helper/navigation.dart';
import 'package:primo/core/helper/snack_bar_helper.dart';
import 'package:primo/core/routing/otp_enum.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/app_button.dart';
import 'package:primo/feature/auth/presentation/cubit/otp_cubit.dart';
import 'package:primo/feature/auth/presentation/cubit/otp_state.dart';

import '../widgets/otp_input_row.dart';

class OtpVerificationScreen extends StatelessWidget {
  final OtpVerificationArgs args;
  const OtpVerificationScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OtpCubit>();
    cubit.phoneNumber = args.phoneNumber;
    cubit.otpType = args.otpType; // تمرير النوع للكيوبت
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<OtpCubit, OtpState>(
          listenWhen: (previous, current) =>
              current is OtpSuccess ||
              current is OtpError ||
              current is OtpForgotPasswordSuccess,

          listener: (context, state) {
            if (state is OtpError) {
              context.showError(state.error);
            } else if (state is OtpSuccess) {
              context.showSuccess(
                state.otpResponse.data?.message ?? "تم تفعيل الحساب بنجاح",
              );
              context.pushNamedAndRemoveUntil(Routes.userMainLayout);
              // الانتقال لشاشة تسجيل الدخول بعد النجاح
            } else if (state is OtpForgotPasswordSuccess) {
              context.showSuccess(
                state.response.message ?? "تم التحقق من الكود بنجاح",
              );
              context.pushNamedAndRemoveUntil(
                Routes.resetPassword,
                arguments: cubit.phoneNumber,
              );
            } else if (state is ResendOtpSuccess) {
              context.showSuccess(state.message);
            }
          },
          buildWhen: (previous, current) =>
              current is OtpTimerTick || current is ResendOtpLoading,
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  16.verticalSpace,
                  // 1. زر الرجوع (دائري مع ظل خفيف) في أعلى اليمين
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () => context.pop(),
                      borderRadius: BorderRadius.circular(99.r),
                      child: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: AppColors.textMain,
                          size: 24.sp,
                        ),
                      ),
                    ),
                  ),

                  32.verticalSpace,

                  // 2. النصوص (العنوان والوصف)
                  Text(
                    "أدخل رمز التحقق",
                    style: AppTextStyle.font32.copyWith(
                      color: AppColors.textMain,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  16.verticalSpace,
                  Text(
                    "أرسلنا رمزاً مكوناً من 4 أرقام إلى رقم هاتفك المرجو إدخاله أدناه.",
                    style: AppTextStyle.font16.copyWith(
                      color: AppColors.greyDark,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  40.verticalSpace,

                  // 3. حقول الـ OTP المخصصة
                  const OtpInputRow(),

                  // مسافة لدفع العناصر السفلية إلى أسفل الشاشة
                  const Spacer(),

                  // 4. إعادة الإرسال والزر السفلي
                  Column(
                    children: [
                      // نص إعادة الإرسال
                      InkWell(
                        onTap: cubit.canResend
                            ? () => cubit.emitResendOtp()
                            : null,
                        child: RichText(
                          text: TextSpan(
                            text: "لم تستلم الرمز؟ ",
                            style: AppTextStyle.font14.copyWith(
                              color: AppColors.greyDark,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    "إعادة الإرسال بعد 00:${cubit.countdown.toString().padLeft(2, '0')}",
                                style: AppTextStyle.font14.copyWith(
                                  color: cubit.canResend
                                      ? AppColors.primary
                                      : AppColors.greyMedium3,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    if (cubit.canResend) {
                                      cubit.emitResendOtp();
                                    }
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                      24.verticalSpace,
                      AppButton(
                        text: "تحقق",
                        isLoading: state is OtpLoading,
                        onPressed: cubit.emitVerifyOtpStates,
                      ),

                      32.verticalSpace, // مسافة أسفل الزر
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
