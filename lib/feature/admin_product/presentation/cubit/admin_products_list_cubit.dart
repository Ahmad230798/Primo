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
        final cachedProducts =
            jsonList.map((e) => ProductModel.fromJson(e)).toList();
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
          final jsonString =
              jsonEncode(products.map((e) => e.toJson()).toList());
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
    final result = await _manageProductUseCase.toggleStatus(productId);
    result.fold(
      (failure) => emit(AdminProductsListError(failure.errorMessage)),
      (_) {
        emit(const AdminProductsListActionSuccess("تم تغيير حالة المنتج بنجاح"));
        getProducts();
      },
    );
  }
}
