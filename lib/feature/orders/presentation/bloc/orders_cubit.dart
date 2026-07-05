import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/core/models/order_model.dart';
import 'package:primo/feature/orders/domain/usecases/get_order_by_id_usecase.dart';
import 'package:primo/feature/orders/domain/usecases/get_orders_usecase.dart';
import 'package:primo/feature/orders/domain/usecases/rate_product_in_order_usecase.dart';
import 'package:primo/feature/orders/presentation/bloc/orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final GetOrdersUseCase _getOrdersUseCase;
  final GetOrderByIdUseCase _getOrderByIdUseCase;
  final RateProductInOrderUseCase _rateProductInOrderUseCase;

  List<OrderModel> currentOrders = [];

  OrdersCubit(
    this._getOrdersUseCase,
    this._getOrderByIdUseCase,
    this._rateProductInOrderUseCase,
  ) : super(OrdersInitial());

  Future<void> getOrders({String? status}) async {
    emit(OrdersLoading());
    final result = await _getOrdersUseCase(status: status);
    result.fold(
      (failure) => emit(OrdersError(failure.errorMessage)),
      (orders) {
        currentOrders = orders;
        emit(OrdersLoaded(orders));
      },
    );
  }

  Future<void> getOrderDetails(int id) async {
    emit(OrdersLoading());
    final result = await _getOrderByIdUseCase(id);
    result.fold(
      (failure) => emit(OrdersError(failure.errorMessage)),
      (order) => emit(SingleOrderLoaded(order)),
    );
  }

  Future<void> rateProduct(int productId, int orderId, int rating) async {
    emit(OrdersLoading());
    final result = await _rateProductInOrderUseCase(productId, orderId, rating);
    result.fold(
      (failure) => emit(OrdersError(failure.errorMessage)),
      (msg) {
        emit(OrderRatingSuccess(msg));
        getOrders(); // إعادة جلب القائمة بعد التقييم
      },
    );
  }
}
