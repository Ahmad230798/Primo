import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/core/models/order_model.dart';
import 'package:primo/core/network/app_storage.dart';
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

  String activeStatus = 'all';

  Future<void> getOrders({String? status}) async {
    if (status != null) {
      activeStatus = status;
    }
    final cacheKey = 'cache_user_orders_$activeStatus';
    bool hasCache = false;
    try {
      final cached = await AppStorage.getCachedData(cacheKey);
      if (cached != null) {
        final List<dynamic> jsonList = jsonDecode(cached);
        currentOrders =
            jsonList.map((e) => OrderModel.fromJson(e)).toList();
        hasCache = true;
        if (!isClosed) emit(OrdersLoaded(currentOrders));
      }
    } catch (_) {}

    if (!hasCache && !isClosed) {
      emit(OrdersLoading());
    }

    try {
      final result = await _getOrdersUseCase(status: activeStatus);
      result.fold(
        (failure) {
          if (!hasCache && !isClosed) emit(OrdersError(failure.errorMessage));
        },
        (orders) {
          List<OrderModel> filtered = orders;
          if (activeStatus != 'all' && activeStatus.isNotEmpty) {
            if (activeStatus == 'completed') {
              filtered = orders
                  .where(
                    (o) =>
                        o.status.toLowerCase() == 'completed' ||
                        o.status.toLowerCase() == 'delivered',
                  )
                  .toList();
            } else {
              filtered = orders
                  .where(
                    (o) => o.status.toLowerCase() == activeStatus.toLowerCase(),
                  )
                  .toList();
            }
          }
          currentOrders = filtered;
          try {
            final jsonString =
                jsonEncode(filtered.map((e) => e.toJson()).toList());
            AppStorage.cacheData(cacheKey, jsonString);
          } catch (_) {}
          if (!isClosed) emit(OrdersLoaded(filtered));
        },
      );
    } catch (e) {
      if (!hasCache && !isClosed) emit(OrdersError(e.toString()));
    }
  }

  Future<void> getOrderDetails(int id) async {
    emit(OrdersLoading());
    try {
      final result = await _getOrderByIdUseCase(id);
      result.fold(
        (failure) {
          if (!isClosed) emit(OrdersError(failure.errorMessage));
        },
        (order) {
          if (!isClosed) emit(SingleOrderLoaded(order));
        },
      );
    } catch (e) {
      if (!isClosed) emit(OrdersError(e.toString()));
    }
  }

  Future<void> rateProduct(int productId, int orderId, int rating) async {
    emit(OrdersLoading());
    try {
      final result = await _rateProductInOrderUseCase(productId, orderId, rating);
      result.fold(
        (failure) {
          if (!isClosed) emit(OrdersError(failure.errorMessage));
        },
        (msg) {
          if (!isClosed) {
            emit(OrderRatingSuccess(msg));
            getOrderDetails(orderId);
            getOrders(status: activeStatus);
          }
        },
      );
    } catch (e) {
      if (!isClosed) emit(OrdersError(e.toString()));
    }
  }
}
