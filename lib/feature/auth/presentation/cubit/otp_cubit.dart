import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../../data/models/otp_request_body.dart';
import 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  final VerifyOtpUseCase _verifyOtpUseCase;

  OtpCubit(this._verifyOtpUseCase) : super(OtpInitial());

  
  final List<TextEditingController> controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());

  String finalOtpCode = '';
  String phoneNumber = '';

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

    final response = await _verifyOtpUseCase.execute(requestBody);

    response.fold(
      (failure) => emit(OtpError(error: failure.errorMessage)),
      (data) => emit(OtpSuccess(data)),
    );
  }

  // 3. الأهم: تنظيف الذاكرة عند إغلاق الشاشة
  @override
  Future<void> close() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    return super.close();
  }
}
