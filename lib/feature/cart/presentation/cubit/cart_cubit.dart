import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/feature/cart/data/models/cart_item_model.dart';
import 'package:primo/feature/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:primo/feature/cart/domain/usecases/delete_from_cart_usecase.dart';
import 'package:primo/feature/cart/domain/usecases/get_cart_usecase.dart';
import 'package:primo/feature/cart/domain/usecases/update_cart_quantity_usecase.dart';
import 'package:primo/feature/cart/presentation/cubit/cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final GetCartUseCase _getCartUseCase;
  final AddToCartUseCase _addToCartUseCase;
  final UpdateCartQuantityUseCase _updateCartQuantityUseCase;
  final DeleteFromCartUseCase _deleteFromCartUseCase;

  List<CartItemModel> currentItems = [];

  CartCubit(
    this._getCartUseCase,
    this._addToCartUseCase,
    this._updateCartQuantityUseCase,
    this._deleteFromCartUseCase,
  ) : super(CartInitial());

  double calculateTotal(List<CartItemModel> items) {
    double sum = 0.0;
    for (var item in items) {
      sum += (item.newPrice * item.quantity).toDouble();
    }
    return sum;
  }

  Future<void> getCart({bool showLoading = true}) async {
    if (showLoading) {
      if(!isClosed)
      {emit(CartLoading());}
    }
    final result = await _getCartUseCase();
    result.fold(
      (failure) {
        if (!isClosed) emit(CartError(failure.errorMessage)); // 💡 حماية
      },
      (items) {
        currentItems = items;
        if (!isClosed) {
          // 💡 حماية
          emit(CartLoaded(items: items, totalPrice: calculateTotal(items)));
        }
      },
    );
  }

  Future<void> addToCart(int variantId, int count) async {
    if (!isClosed) emit(CartLoading());
    final result = await _addToCartUseCase(variantId, count);
    result.fold(
      (failure) {
        if (!isClosed) emit(CartError(failure.errorMessage)); // 💡 حماية
      },
      (msg) {
        // 2. إرسال حالة النجاح مع تمرير رسالة السيرفر (msg) للواجهة
        if (!isClosed) {
          emit(
            CartLoaded(
              items: currentItems,
              totalPrice: calculateTotal(currentItems),
              actionMessage:
                  msg, // 💡 رسالة السيرفر الحقيقية ("تمت الإضافة بنجاح" مثلاً)
            ),
          );
        }
        // 3. تحديث السلة في الخلفية بصمت
        if (!isClosed) getCart(showLoading: false);
      },
    );
  }

  Future<void> updateQuantity(int cartId, int newCount) async {
    if (newCount <= 0) {
      deleteFromCart(cartId);
      return;
    }

    // التحديث اللحظي في الواجهة (Optimistic UI Update)
    final index = currentItems.indexWhere((item) => item.id == cartId);
    if (index != -1) {
      final oldItem = currentItems[index];
      final updatedItem = oldItem.copyWith(
        quantity: newCount,
        totalPrice: oldItem.newPrice * newCount,
      );
      currentItems = List.from(currentItems)..[index] = updatedItem;
      emit(
        CartLoaded(
          items: currentItems,
          totalPrice: calculateTotal(currentItems),
        ),
      );
    }

    final result = await _updateCartQuantityUseCase(cartId, newCount);
    result.fold((failure) {
      emit(CartError(failure.errorMessage));
      getCart(showLoading: false); // إعادة جلب عند الخطأ
    }, (_) => getCart(showLoading: false));
  }

  Future<void> deleteFromCart(int cartId) async {
    // التحديث اللحظي
    currentItems = currentItems.where((item) => item.id != cartId).toList();
    emit(
      CartLoaded(
        items: currentItems,
        totalPrice: calculateTotal(currentItems),
        actionMessage: "تم حذف المنتج من السلة",
      ),
    );

    final result = await _deleteFromCartUseCase(cartId);
    result.fold((failure) {
      emit(CartError(failure.errorMessage));
      getCart(showLoading: false);
    }, (_) => getCart(showLoading: false));
  }
}
