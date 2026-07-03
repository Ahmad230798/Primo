import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/app_storage.dart';
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

  void togglePasswordVisibility() {
    isPasswordObscure = !isPasswordObscure;
    _emitUIChange();
  }

  void _emitUIChange() {
    emit(LoginChangeUI(isPasswordObscure: isPasswordObscure));
  }

  void emitLoginStates() async {
    emit(LoginLoading());

    final requestBody = LoginRequestBody(
      phoneNumber: phoneController.text,
      password: passwordController.text,
    );

    final response = await _loginUseCase.execute(requestBody);

    response.fold(
      (failure) {
        emit(LoginError(error: failure.errorMessage));
      },
      (data) async {
        // حفظ التوكن بمجرد نجاح تسجيل الدخول
        await AppStorage.saveTokens(
          accessToken: data.data?.accessToken ?? '',
          refreshToken: data.data?.refreshToken ?? "",
        );
        await AppStorage.saveUserRole(data.data?.user?.isAdmin ?? 0);
        emit(LoginSuccess(data));
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
