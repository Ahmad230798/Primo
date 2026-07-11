import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/core/di/service_locator.dart';
import 'package:primo/core/services/firebase_messaging_service.dart';
import 'package:primo/feature/auth/data/models/register_request_body.dart';
import 'package:primo/feature/auth/domain/usecases/register_usecase.dart';
import 'package:primo/feature/auth/presentation/cubit/register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase _registerUseCase;

  RegisterCubit(this._registerUseCase) : super(RegisterInitial());

  // متحكمات النصوص (من الأفضل وضعها هنا ليبقى كود الـ UI نظيفاً جداً)
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController =
      TextEditingController();

  // مفتاح النموذج للتحقق من صحة المدخلات (Validation)
  final formKey = GlobalKey<FormState>();
  // ================= UI States =================
  bool isPasswordObscure = true;
  bool isConfirmPasswordObscure = true;
  bool isTermsAccepted = false;

  void togglePasswordVisibility() {
    isPasswordObscure = !isPasswordObscure;
    _emitUIChange();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordObscure = !isConfirmPasswordObscure;
    _emitUIChange();
  }

  void toggleTermsAcceptance(bool? value) {
    isTermsAccepted = value ?? false;
    _emitUIChange();
  }

  // دالة مساعدة لتحديث الواجهة فوراً
  void _emitUIChange() {
    emit(
      RegisterChangeUI(
        isPasswordObscure: isPasswordObscure,
        isConfirmPasswordObscure: isConfirmPasswordObscure,
        isTermsAccepted: isTermsAccepted,
      ),
    );
  }

  // =============================================
  void emitRegisterStates() async {
    // 1. إخبار الواجهة أن تبدأ بعرض دائرة التحميل
    emit(RegisterLoading());

    final fcmToken = await getIt<FirebaseCloudMessagingService>().getDeviceToken();
    final requestBody = RegisterRequestBody(
      name: nameController.text,
      phone: phoneController.text,
      password: passwordController.text,
      passwordConfirmation: passwordConfirmationController.text,
      fcmToken: fcmToken,
    );

    // 3. استدعاء السيرفر عبر الـ Repo

    final response = await _registerUseCase.execute(requestBody);

    // 4. السحر هنا: فك الـ Either باستخدام fold
    response.fold(
      (failure) {
        // جهة اليسار (Left) = خطأ
        // نأخذ رسالة الخطأ ونرسلها للواجهة
        emit(RegisterError(error: failure.errorMessage));
      },
      (data) {
        // جهة اليمين (Right) = نجاح
        // نرسل البيانات للواجهة
        emit(RegisterSuccess(data));
      },
    );
  }

  @override
  Future<void> close() {
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    return super.close();
  }
}
