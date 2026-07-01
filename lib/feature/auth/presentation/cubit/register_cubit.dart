import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/feature/auth/data/models/register_request_body.dart';
import 'package:primo/feature/auth/data/repos/auh_repo.dart';
import 'package:primo/feature/auth/presentation/cubit/register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepo _authRepo;

  RegisterCubit(this._authRepo) : super(RegisterInitial());

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

    // 2. تجهيز البيانات للإرسال
    final requestBody = RegisterRequestBody(
      name: nameController.text,
      phone: phoneController.text,
      password: passwordController.text,
      passwordConfirmation: passwordConfirmationController.text,
    );

    // 3. استدعاء السيرفر عبر الـ Repo
    print(
      "Cubit: Emitting Loading State, Calling Repository...",
    ); // <--- أضف هذا

    final response = await _authRepo.register(requestBody);

    print("Cubit: Repository returned response.");

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
}
