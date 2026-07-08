import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/core/models/product_model.dart';
import 'package:primo/core/models/variant_model.dart';
import 'package:primo/feature/product/domain/usecases/get_product_details_usecase.dart';
import 'package:primo/feature/product/presentation/cubit/product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetProductDetailsUseCase _getProductDetailsUseCase;
  ProductModel? currentProduct;
  VariantModel? selectedVariant;
  int quantity = 1;

  ProductCubit(this._getProductDetailsUseCase) : super(ProductInitial());

  Future<void> getProductDetails(int productId) async {
    emit(ProductLoading());
    final result = await _getProductDetailsUseCase.execute(productId);
    result.fold(
      (failure) {
        if (!isClosed) {
          emit(ProductError(failure.errorMessage));
        }
      },
      (product) {
        currentProduct = product;
        quantity = 1;
        if (product.variants != null && product.variants!.isNotEmpty) {
          selectedVariant = product.variants!.first;
        } else {
          selectedVariant = null;
        }
        if (!isClosed) {
          emit(
            ProductLoaded(
              product,
              selectedVariant: selectedVariant,
              quantity: quantity,
            ),
          );
        }
      },
    );
  }

  void selectVariant(VariantModel variant) {
    if (currentProduct != null) {
      selectedVariant = variant;
      emit(
        ProductLoaded(
          currentProduct!,
          selectedVariant: selectedVariant,
          quantity: quantity,
        ),
      );
    }
  }

  void incrementQuantity() {
    if (currentProduct != null) {
      quantity++;
      emit(
        ProductLoaded(
          currentProduct!,
          selectedVariant: selectedVariant,
          quantity: quantity,
        ),
      );
    }
  }

  void decrementQuantity() {
    if (currentProduct != null && quantity > 1) {
      quantity--;
      emit(
        ProductLoaded(
          currentProduct!,
          selectedVariant: selectedVariant,
          quantity: quantity,
        ),
      );
    }
  }
}
