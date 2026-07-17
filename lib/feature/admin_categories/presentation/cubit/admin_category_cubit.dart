import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:primo/core/models/category_model.dart';
import '../../data/models/add_category_request_body.dart';
import '../../data/models/update_category_request_body.dart';
import '../../domain/usecases/manage_category_usecase.dart';
import 'admin_category_state.dart';

class AdminCategoryCubit extends Cubit<AdminCategoryState> {
  final ManageCategoryUseCase _manageCategoryUseCase;

  AdminCategoryCubit(this._manageCategoryUseCase)
      : super(AdminCategoryInitial());

  TextEditingController nameController = TextEditingController();
  File? selectedImage;
  String? existingImageUrl;
  int? editingCategoryId;
  final ImagePicker _picker = ImagePicker();

  void initForEdit(CategoryModel category) {
    editingCategoryId = category.id;
    nameController.text = category.name ?? "";
    existingImageUrl = category.image;
    selectedImage = null;
    emit(AdminCategoryInitial());
  }

  void clearForAdd() {
    editingCategoryId = null;
    nameController.clear();
    existingImageUrl = null;
    selectedImage = null;
    emit(AdminCategoryInitial());
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage = File(image.path);
      emit(AdminCategoryImagePicked(selectedImage!));
    }
  }

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

    try {
      final requestBody = AddCategoryRequestBody(
        name: nameController.text.trim(),
        image: selectedImage!,
      );

      final response = await _manageCategoryUseCase.addCategory(requestBody);

      response.fold(
        (failure) => emit(AdminCategoryError(failure.errorMessage)),
        (success) {
          nameController.clear();
          selectedImage = null;
          emit(const AdminCategorySuccess("تمت إضافة القسم بنجاح"));
        },
      );
    } catch (e) {
      if (!isClosed) emit(AdminCategoryError(e.toString()));
    }
  }

  void updateCategory() async {
    if (editingCategoryId == null) return;
    if (nameController.text.trim().isEmpty) {
      emit(const AdminCategoryError("يرجى إدخال اسم القسم"));
      return;
    }

    emit(AdminCategoryLoading());

    try {
      final requestBody = UpdateCategoryRequestBody(
        name: nameController.text.trim(),
        image: selectedImage,
      );

      final response = await _manageCategoryUseCase.updateCategory(
        editingCategoryId!,
        requestBody,
      );

      response.fold(
        (failure) => emit(AdminCategoryError(failure.errorMessage)),
        (success) {
          emit(const AdminCategorySuccess("تم تعديل القسم بنجاح"));
        },
      );
    } catch (e) {
      if (!isClosed) emit(AdminCategoryError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    return super.close();
  }
}
