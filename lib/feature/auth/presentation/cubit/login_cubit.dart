import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/network/app_storage.dart';
import '../../../../core/services/firebase_messaging_service.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../data/models/login_request_body.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;

  LoginCubit(this._loginUseCase) : super(LoginInitial());

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool isPasswordObscure = true;
  int _failedAttempts = 0; // عداد المحاولات الفاشلة
  DateTime? _lockUntil; // وقت فك الحظر المحلي
  void togglePasswordVisibility() {
    isPasswordObscure = !isPasswordObscure;
    _emitUIChange();
  }

  void _emitUIChange() {
    emit(LoginChangeUI(isPasswordObscure: isPasswordObscure));
  }

  void emitLoginStates() async {
    if (_lockUntil != null) {
      if (DateTime.now().isBefore(_lockUntil!)) {
        final remainingMinutes = _lockUntil!
            .difference(DateTime.now())
            .inMinutes;
        emit(
          LoginError(
            error:
                "تم قفل الحساب مؤقتاً. يرجى المحاولة بعد ${remainingMinutes + 1} دقيقة.",
          ),
        );
        return;
      } else {
        // انتهت مدة الحظر، نصفّر العداد
        _failedAttempts = 0;
        _lockUntil = null;
      }
    }
    emit(LoginLoading());

    final fcmToken = await getIt<FirebaseCloudMessagingService>().getDeviceToken();
    final requestBody = LoginRequestBody(
      phoneNumber: phoneController.text,
      password: passwordController.text,
      fcmToken: fcmToken,
    );

    final response = await _loginUseCase.execute(requestBody);

    response.fold(
      (failure) {
        _failedAttempts++;

        // 3. التحقق من رد السيرفر 429 أو بلوغ الحد الأقصى محلياً (مثلاً 5 مرات)
        if (_failedAttempts >= 5) {
          _lockUntil = DateTime.now().add(
            const Duration(minutes: 15),
          ); // قفل لمدة 15 دقيقة
          emit(
            const LoginError(
              error: "محاولات خاطئة كثيرة. تم قفل تسجيل الدخول لمدة 15 دقيقة.",
            ),
          );
        } else {
          emit(LoginError(error: failure.errorMessage));
        }
      },
      (data) async {
        _failedAttempts = 0;
        _lockUntil = null;
        if (data.data?.otpRequired == true) {
          // إرسال حالة طلب الـ OTP وتمرير الرسالة القادمة من السيرفر
          emit(
            LoginRequiresOtp(
              data.data?.innerMessage ?? "الحساب غير مفعل، يرجى إدخال الكود.",
            ),
          );
        } else {
          // المسار الطبيعي (تم الدخول بنجاح والحساب مفعل)
          await AppStorage.saveTokens(
            accessToken: data.data?.accessToken ?? '',
            refreshToken: data.data?.refreshToken ?? "",
          );

          await AppStorage.saveUserRole(data.data?.user?.isAdmin ?? 0);
          await AppStorage.saveUserData(
            name: data.data?.user?.name,
            phone: data.data?.user?.phone,
            avatar: data.data?.user?.avatar,
          );
          emit(LoginSuccess(data));
        }
      },
    );
  }

  @override
  Future<void> close() {
    phoneController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
