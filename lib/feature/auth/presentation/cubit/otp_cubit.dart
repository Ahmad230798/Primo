import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/core/network/app_storage.dart';
import 'package:primo/core/routing/otp_enum.dart';
import 'package:primo/feature/auth/data/models/resend_otp_request_body.dart';
import 'package:primo/feature/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:primo/feature/auth/domain/usecases/verify_forget_password_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../../data/models/otp_request_body.dart';
import 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  final VerifyOtpUseCase _verifyOtpUseCase;
  final VerifyForgetPasswordOtpUsecase _verifyForgotPasswordOtpUseCase;
  final ResendOtpUseCase _resendOtpUseCase; // حقن الـ UseCase
  OtpCubit(
    this._verifyOtpUseCase,
    this._verifyForgotPasswordOtpUseCase,
    ResendOtpUseCase resendOtpUseCase,
  ) : _resendOtpUseCase = resendOtpUseCase,
      super(OtpInitial());
  final List<TextEditingController> controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());

  String finalOtpCode = '';
  String phoneNumber = '';
  late OtpType otpType;
  int countdown = 59;
  Timer? _timer;
  bool get canResend => countdown == 0;

  // دالة تشغيل المؤقت
  void startTimer() {
    countdown = 59;
    _timer?.cancel();
    emit(OtpTimerTick(countdown)); // تحديث الواجهة برقم 59

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        countdown--;
        emit(OtpTimerTick(countdown));
      } else {
        timer.cancel();
        emit(OtpTimerTick(countdown)); // تحديث الواجهة ليصبح الزر قابلاً للضغط
      }
    });
  }

  // 2. دالة التحكم بانتقال المؤشر (Focus) بين المربعات
  void onOtpInputChanged(String value, int index) {
    if (value.isNotEmpty) {
      // الانتقال للمربع التالي
      if (index < 3) {
        focusNodes[index + 1].requestFocus();
      } else {
        focusNodes[index].unfocus(); // إخفاء الكيبورد عند المربع الأخير
      }
    } else {
      // الرجوع للمربع السابق عند الحذف
      if (index > 0) {
        focusNodes[index - 1].requestFocus();
      }
    }

    // تجميع الكود في كل مرة يتغير فيها أي مربع
    finalOtpCode = controllers.map((c) => c.text).join();
  }

  // دالة إعادة إرسال الكود للباك إند
  void emitResendOtp() async {
    if (!canResend) return;

    emit(ResendOtpLoading());

    // تجهيز الطلب بناءً على نوع العملية التي مررناها للشاشة
    final requestBody = ResendOtpRequestBody(
      phone: phoneNumber,
      type: otpType == OtpType.register ? 'register' : 'reset_password',
    );

    final response = await _resendOtpUseCase.execute(requestBody);

    response.fold(
      (failure) {
        emit(OtpError(error: failure.errorMessage));
      },
      (data) {
        startTimer(); // إعادة تشغيل المؤقت من 59 ثانية
        emit(ResendOtpSuccess(message: data.message ?? 'تمت إعادة الإرسال'));
      },
    );
  }

  void emitVerifyOtpStates() async {
    // التحقق قبل الإرسال
    if (finalOtpCode.length != 4) {
      emit(const OtpError(error: "الرجاء إدخال رمز التحقق كاملاً"));
      return;
    }

    emit(OtpLoading());

    final requestBody = OtpRequestBody(
      phone: phoneNumber,
      otpCode: finalOtpCode,
    );

    if (otpType == OtpType.register) {
      // 1. مسار تفعيل الحساب عند التسجيل
      final response = await _verifyOtpUseCase.execute(requestBody);
      response.fold((failure) => emit(OtpError(error: failure.errorMessage)), (
        data,
      ) async {
        await AppStorage.saveTokens(
          accessToken: data.data?.accessToken ?? '',
          refreshToken: data.data?.refreshToken ?? '',
        );
        emit(OtpSuccess(data)); // سيعيد OtpResponse
      });
    } else {
      // 2. مسار التحقق من كود نسيت كلمة المرور
      final response = await _verifyForgotPasswordOtpUseCase.execute(
        requestBody,
      );
      response.fold((failure) => emit(OtpError(error: failure.errorMessage)), (
        data,
      ) {
        // نرسل حالة النجاح الخاصة بـ نسيت كلمة المرور
        emit(OtpForgotPasswordSuccess(data)); // سننشئ هذه الـ State الآن
      });
    }
  }

  // 3. الأهم: تنظيف الذاكرة عند إغلاق الشاشة
  @override
  Future<void> close() {
    for (var controller in controllers) {
      controller.dispose();
    }
    _timer?.cancel();
    for (var node in focusNodes) {
      node.dispose();
    }
    return super.close();
  }
}
