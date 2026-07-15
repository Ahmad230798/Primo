import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/core/models/product_model.dart';
import 'package:primo/core/network/app_storage.dart';
import 'package:primo/feature/admin_product/domain/usecases/get_products_usecase.dart';
import 'package:primo/feature/admin_product/domain/usecases/manage_product_usecase.dart';
import 'admin_products_list_state.dart';

class AdminProductsListCubit extends Cubit<AdminProductsListState> {
  final GetProductsUseCase _getProductsUseCase;
  final ManageProductUseCase _manageProductUseCase;

  AdminProductsListCubit(this._getProductsUseCase, this._manageProductUseCase)
    : super(AdminProductsListInitial());

  List<ProductModel> currentProducts = [];
  List<ProductModel> allProducts = [];
  List<ProductModel> filteredProducts = [];

  Future<void> getProducts() async {
    bool hasCache = false;
    try {
      final cached = await AppStorage.getCachedData('cache_admin_products');
      if (cached != null) {
        final List<dynamic> jsonList = jsonDecode(cached);
        final cachedProducts = jsonList
            .map((e) => ProductModel.fromJson(e))
            .toList();
        allProducts = cachedProducts;
        filteredProducts = cachedProducts;
        currentProducts = cachedProducts;
        hasCache = true;
        if (!isClosed) emit(AdminProductsListLoaded(filteredProducts));
      }
    } catch (_) {}

    if (!hasCache && !isClosed) {
      emit(AdminProductsListLoading());
    }

    final result = await _getProductsUseCase.getAll();
    result.fold(
      (failure) {
        if (!hasCache && !isClosed) {
          emit(AdminProductsListError(failure.errorMessage));
        }
      },
      (products) {
        allProducts = products;
        filteredProducts = products;
        currentProducts = products;
        try {
          final jsonString = jsonEncode(
            products.map((e) => e.toJson()).toList(),
          );
          AppStorage.cacheData('cache_admin_products', jsonString);
        } catch (_) {}
        if (!isClosed) emit(AdminProductsListLoaded(filteredProducts));
      },
    );
  }

  void searchProducts(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      filteredProducts = List.from(allProducts);
    } else {
      filteredProducts = allProducts.where((product) {
        final nameMatch = (product.name ?? '').toLowerCase().contains(q);
        final skuMatch = (product.skuCode ?? '').toLowerCase().contains(q);
        return nameMatch || skuMatch;
      }).toList();
    }
    currentProducts = filteredProducts;
    emit(AdminProductsListLoaded(filteredProducts));
  }

  int? selectedCategoryIdFilter;

  void filterByCategory(int? categoryId) {
    selectedCategoryIdFilter = categoryId;
    if (categoryId == null) {
      filteredProducts = List.from(allProducts);
    } else {
      filteredProducts = allProducts.where((product) {
        final prodCatId = product.categoryId ?? product.category?.id;
        return prodCatId == categoryId;
      }).toList();
    }
    currentProducts = filteredProducts;
    emit(AdminProductsListLoaded(filteredProducts));
  }

  Future<void> deleteProduct(int productId) async {
    final result = await _manageProductUseCase.deleteProduct(productId);
    result.fold(
      (failure) => emit(AdminProductsListError(failure.errorMessage)),
      (_) {
        emit(const AdminProductsListActionSuccess("تم حذف المنتج بنجاح"));
        getProducts();
      },
    );
  }

  Future<void> toggleProductStatus(int productId) async {
    // 1. إيجاد المنتج المستهدف في القائمة المحلية
    final index = currentProducts.indexWhere((p) => p.id == productId);
    if (index == -1) return;

    // 2. حفظ الكائن القديم بالكامل للرجوع إليه (Rollback) في حال فشل الـ API
    final oldProduct = currentProducts[index];
    final oldStatus = oldProduct.isActiveBool;

    // 3. التحديث المتفائل (Optimistic Update) بدون copyWith:
    // نقوم ببناء كائن جديد ممررين له نفس بيانات القديم مع تغيير قيمة isActive فقط
    final updatedProduct = ProductModel(
      id: oldProduct.id,
      categoryId: oldProduct.categoryId,
      categoryName: oldProduct.categoryName,
      name: oldProduct.name,
      image: oldProduct.image,
      description: oldProduct.description,
      price: oldProduct.price,
      skuCode: oldProduct.skuCode,
      isActive: !oldStatus, // 💡 الحالة الجديدة المعكوسة
      category: oldProduct.category,
      variants: oldProduct.variants,
      ratings: oldProduct.ratings,
      ratingsCount: oldProduct.ratingsCount,
      isFavorite: oldProduct.isFavorite,
      directLowestPrice: oldProduct.directLowestPrice,
      directTotalStock: oldProduct.directTotalStock,
    );

    // تحديث العنصر في المصفوفة فوراً
    currentProducts[index] = updatedProduct;

    // إطلاق حالة التحديث الفورية لتغيير السلايدر في الواجهة بلمح البصر (0ms)
    if (!isClosed) {
      emit(AdminProductsListLoaded(List.from(currentProducts)));
    }

    // 4. إرسال الطلب للسيرفر في الخلفية باستخدام الـ UseCase المتاح لديك فعلياً
    final result = await _manageProductUseCase.toggleStatus(productId);

    result.fold(
      (failure) {
        // 5. في حال الفشل: تراجع فوري وإعادة المنتج لحالته السابقة لتنبيه المستخدم
        currentProducts[index] = oldProduct;
        if (!isClosed) {
          emit(
            AdminProductsListLoaded(List.from(currentProducts)),
          ); // إعادة السلايدر لوضعه القديم
          emit(
            AdminProductsListError(failure.errorMessage),
          ); // إظهار رسالة الخطأ
        }
      },
      (_) {
        if (!isClosed) {}
        {
          emit(
            const AdminProductsListActionSuccess("تم تغيير حالة المنتج بنجاح"),
          );
        }
        try {
          final jsonString = jsonEncode(
            allProducts.map((e) => e.toJson()).toList(),
          );
          AppStorage.cacheData('cache_admin_products', jsonString);
        } catch (_) {}
      },
    );
  }

  // Future<void> toggleProductStatus(int productId) async {
  //   final result = await _manageProductUseCase.toggleStatus(productId);
  //   result.fold(
  //     (failure) => emit(AdminProductsListError(failure.errorMessage)),
  //     (_) {
  //       emit(const AdminProductsListActionSuccess("تم تغيير حالة المنتج بنجاح"));
  //       getProducts();
  //     },
  //   );
  // }
}
