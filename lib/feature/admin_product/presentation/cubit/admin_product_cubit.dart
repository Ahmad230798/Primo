import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:primo/core/models/category_model.dart';
import 'package:primo/feature/admin_product/domain/usecases/get_categories_usecase.dart';
import '../../data/models/add_product_request_body.dart';
import '../../data/models/variant_request_model.dart';
import '../../domain/usecases/manage_product_usecase.dart';
import 'admin_product_state.dart';

// كلاس مساعد للتحكم بحقول كل نوع (Variant) بشكل منفصل
class VariantItemController {
  final TextEditingController propertyController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();

  void dispose() {
    propertyController.dispose();
    priceController.dispose();
    stockController.dispose();
  }
}

class AdminProductCubit extends Cubit<AdminProductState> {
  final ManageProductUseCase _manageProductUseCase;
  final GetCategoriesUseCase
  _getCategoriesUseCase; // نحتاجه لجلب الأقسام للـ Dropdown

  AdminProductCubit(this._manageProductUseCase, this._getCategoriesUseCase)
    : super(AdminProductInitial());

  // --- المتحكمات الأساسية ---
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  String? selectedCategoryId;
  List<CategoryModel> categories = [];

  File? selectedImage;
  final ImagePicker _picker = ImagePicker();

  // مصفوفة الأنواع (نبدأ بنوع واحد افتراضياً)
  List<VariantItemController> variants = [VariantItemController()];

  // جلب الأقسام لتعبئة القائمة المنسدلة
  void loadCategories() async {
    final response = await _getCategoriesUseCase.execute();
    response.fold((failure) => emit(AdminProductError(failure.errorMessage)), (
      data,
    ) {
      categories = data;
      _updateUI();
    });
  }

  // --- دوال الصور ---
  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage = File(image.path);
      _updateUI();
    }
  }

  // --- دوال الأنواع (Variants) ---
  void addVariant() {
    variants.add(VariantItemController());
    _updateUI();
  }

  void removeVariant(int index) {
    if (variants.length > 1) {
      variants[index].dispose();
      variants.removeAt(index);
      _updateUI();
    } else {
      emit(
        const AdminProductError("يجب أن يحتوي المنتج على نوع واحد على الأقل"),
      );
    }
  }

  void _updateUI() {
    emit(AdminProductUIChanged(DateTime.now().millisecondsSinceEpoch));
  }

  // --- إرسال البيانات للسيرفر ---
  void createProduct() async {
    if (nameController.text.trim().isEmpty ||
        descController.text.trim().isEmpty) {
      emit(const AdminProductError("يرجى إكمال البيانات الأساسية"));
      return;
    }
    if (selectedCategoryId == null) {
      emit(const AdminProductError("يرجى اختيار القسم"));
      return;
    }

    emit(AdminProductLoading());

    // تحويل الكنترولرز إلى المودل الذي يطلبه السيرفر
    List<VariantRequestModel> variantsList = variants
        .map(
          (v) => VariantRequestModel(
            property: v.propertyController.text.trim(),
            price: v.priceController.text.trim(),
            stock: v.stockController.text.trim(),
          ),
        )
        .toList();

    // التأكد من أن الأنواع ليست فارغة
    for (var v in variantsList) {
      if (v.property.isEmpty || v.price.isEmpty || v.stock.isEmpty) {
        emit(
          const AdminProductError("يرجى إكمال جميع بيانات الأنواع والأحجام"),
        );
        return;
      }
    }

    final requestBody = AddProductRequestBody(
      categoryId: selectedCategoryId!,
      name: nameController.text.trim(),
      description: descController.text.trim(),
      image: selectedImage,
      variants: variantsList,
    );

    final response = await _manageProductUseCase.create(requestBody);

    response.fold(
      (failure) => emit(AdminProductError(failure.errorMessage)),
      (success) => emit(const AdminProductSuccess("تم إضافة المنتج بنجاح")),
    );
  }

  @override
  Future<void> close() {
    nameController.dispose();
    descController.dispose();
    for (var v in variants) {
      v.dispose();
    }
    return super.close();
  }
}
