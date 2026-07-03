import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/feature/auth/data/models/forget_password_request_body.dart';
import '../../domain/usecases/forgot_password_usecase.dart';

import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgotPasswordUsecase _forgotPasswordUseCase;

  ForgotPasswordCubit(this._forgotPasswordUseCase)
    : super(ForgotPasswordInitial());

  final TextEditingController phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void emitForgotPasswordStates() async {
    emit(ForgotPasswordLoading());

    final requestBody = ForgetPasswordRequestBody(phone: phoneController.text);

    final response = await _forgotPasswordUseCase.execute(requestBody);

    response.fold(
      (failure) => emit(ForgotPasswordError(error: failure.errorMessage)),
      (data) => emit(ForgotPasswordSuccess(data)),
    );
  }

  @override
  Future<void> close() {
    phoneController.dispose();
    return super.close();
  }
}
