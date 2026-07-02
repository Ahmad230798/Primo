import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/add_category_request_body.dart';
import '../../domain/usecases/add_category_usecase.dart';
import 'admin_category_state.dart';

class AdminCategoryCubit extends Cubit<AdminCategoryState> {
  final AddCategoryUseCase _addCategoryUseCase;

  AdminCategoryCubit(this._addCategoryUseCase) : super(AdminCategoryInitial());

  TextEditingController nameController = TextEditingController();
  File? selectedImage;
  final ImagePicker _picker = ImagePicker();

  // دالة التقاط الصورة
  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage = File(image.path);
      emit(AdminCategoryImagePicked(selectedImage!));
    }
  }

  // دالة الإرسال للسيرفر
  void addCategory() async {
    if (nameController.text.trim().isEmpty) {
      emit(const AdminCategoryError("يرجى إدخال اسم القسم"));
      return;
    }
    if (selectedImage == null) {
      emit(const AdminCategoryError("يرجى اختيار صورة للقسم"));
      return;
    }

    emit(AdminCategoryLoading());

    final requestBody = AddCategoryRequestBody(
      name: nameController.text.trim(),
      image: selectedImage!,
    );

    final response = await _addCategoryUseCase.execute(requestBody);

    response.fold((failure) => emit(AdminCategoryError(failure.errorMessage)), (
      success,
    ) {
      // تفريغ الحقول بعد النجاح
      nameController.clear();
      selectedImage = null;
      emit(AdminCategorySuccess());
    });
  }

  @override
  Future<void> close() {
    nameController.dispose();
    return super.close();
  }
}
