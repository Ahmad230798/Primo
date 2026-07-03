import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/feature/auth/data/models/reset_password_request_body.dart';
import 'package:primo/feature/auth/domain/usecases/reset_password_use_case.dart';
import 'package:primo/feature/auth/presentation/cubit/reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final ResetPasswordUseCase _resetPasswordUseCase;
  ResetPasswordCubit(this._resetPasswordUseCase)
    : super(ResetPasswordInitial());
  final TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController =
      TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isPasswordObscure = true;
  bool isPasswordConfirmationObscure = true;
  String phoneNumber = '';
  void togglePasswordVisibility() {
    isPasswordObscure = !isPasswordObscure;
    _emitUIChange();
  }

  void toggleConfirmPasswordVisibility() {
    isPasswordConfirmationObscure = !isPasswordConfirmationObscure;
    _emitUIChange();
  }

  void _emitUIChange() {
    emit(
      ResetPasswordChangeUI(
        isPasswordObscure: isPasswordObscure,
        isPasswordConfirmationObscure: isPasswordConfirmationObscure,
      ),
    );
  }

  void emitResetPasswordStates() async {
    emit(ResetPasswordLoading());
    final requestBody = ResetPassworRequestBody(
      phone: phoneNumber,
      password: passwordController.text,
      passwordConfirmation: passwordConfirmationController.text,
    );
    final response = await _resetPasswordUseCase.execute(requestBody);
    response.fold(
      (failure) => emit(ResetPassowrdError(error: failure.errorMessage)),
      (data) => emit(ResetPasswordSuccess(data)),
    );
  }
}
