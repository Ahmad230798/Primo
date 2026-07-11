import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:primo/core/models/category_model.dart';
import 'package:primo/core/models/product_model.dart';
import 'package:primo/feature/admin_product/domain/usecases/get_categories_usecase.dart';
import '../../data/models/add_product_request_body.dart';
import '../../data/models/update_product_request_body.dart';
import '../../data/models/variant_request_model.dart';
import '../../domain/usecases/manage_product_usecase.dart';
import 'admin_product_state.dart';

// كلاس مساعد للتحكم بحقول كل نوع (Variant) بشكل منفصل
class VariantItemController {
  int? id;
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
  final GetCategoriesUseCase _getCategoriesUseCase;

  AdminProductCubit(this._manageProductUseCase, this._getCategoriesUseCase)
    : super(AdminProductInitial());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  String? selectedCategoryId;
  List<CategoryModel> categories = [];

  File? selectedImage;
  final ImagePicker _picker = ImagePicker();

  List<VariantItemController> variants = [VariantItemController()];
  int? editingProductId;
  String? existingImageUrl;
  int isActive = 1;

  void loadCategories() async {
    final response = await _getCategoriesUseCase.execute();
    response.fold((failure) => emit(AdminProductError(failure.errorMessage)), (
      data,
    ) {
      categories = data;
      _updateUI();
    });
  }

  int _parseIsActive(dynamic val) {
    if (val == true || val == 1 || val == "1" || val == "true") return 1;
    if (val == false || val == 0 || val == "0" || val == "false") return 0;
    return 1;
  }

  void clearForm() {
    editingProductId = null;
    existingImageUrl = null;
    nameController.clear();
    descController.clear();
    selectedCategoryId = null;
    isActive = 1;
    selectedImage = null;

    for (var v in variants) {
      v.dispose();
    }
    variants.clear();
    variants.add(VariantItemController());
    _updateUI();
  }

  void initForEdit(ProductModel product) {
    editingProductId = product.id;
    existingImageUrl = product.image;
    nameController.text = product.name ?? '';
    descController.text = product.description ?? '';
    selectedCategoryId = product.category?.id?.toString() ?? product.categoryId?.toString();
    isActive = _parseIsActive(product.isActive);
    selectedImage = null;

    for (var v in variants) {
      v.dispose();
    }
    variants.clear();

    if (product.variants != null && product.variants!.isNotEmpty) {
      for (var variant in product.variants!) {
        final ctrl = VariantItemController();
        ctrl.id = variant.id;
        ctrl.propertyController.text = variant.property ?? '';
        ctrl.priceController.text = variant.price?.toString() ?? '';
        ctrl.stockController.text = variant.stock?.toString() ?? '';
        variants.add(ctrl);
      }
    } else {
      variants.add(VariantItemController());
    }
    _updateUI();
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage = File(image.path);
      _updateUI();
    }
  }

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

    List<VariantRequestModel> variantsList = variants
        .map(
          (v) => VariantRequestModel(
            property: v.propertyController.text.trim(),
            price: v.priceController.text.trim(),
            stock: v.stockController.text.trim(),
          ),
        )
        .toList();

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

  void updateProduct() async {
    if (editingProductId == null) return;
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

    final updateVariantsList = <VariantRequestModel>[];
    final addVariantsList = <VariantRequestModel>[];

    for (var v in variants) {
      final prop = v.propertyController.text.trim();
      final prc = v.priceController.text.trim();
      final stk = v.stockController.text.trim();
      if (prop.isEmpty || prc.isEmpty || stk.isEmpty) {
        emit(
          const AdminProductError("يرجى إكمال جميع بيانات الأنواع والأحجام"),
        );
        return;
      }
      final model = VariantRequestModel(
        id: v.id,
        property: prop,
        price: prc,
        stock: stk,
        isActive: 1,
      );
      if (v.id != null) {
        updateVariantsList.add(model);
      } else {
        addVariantsList.add(model);
      }
    }

    final requestBody = UpdateProductRequestBody(
      categoryId: selectedCategoryId!,
      name: nameController.text.trim(),
      description: descController.text.trim(),
      isActive: isActive,
      image: selectedImage, // will be ignored in toFormData if null
      updateVariants: updateVariantsList,
      addVariants: addVariantsList,
    );

    final response = await _manageProductUseCase.update(
      editingProductId!,
      requestBody,
    );

    response.fold(
      (failure) => emit(AdminProductError(failure.errorMessage)),
      (success) => emit(const AdminProductSuccess("تم تحديث المنتج بنجاح")),
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
