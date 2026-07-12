import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/core/models/order_model.dart';
import 'package:primo/core/network/app_storage.dart';
import '../../domain/usecases/get_admin_order_details_usecase.dart';
import '../../domain/usecases/get_admin_orders_usecase.dart';
import '../../domain/usecases/update_order_status_usecase.dart';
import 'admin_orders_state.dart';

class AdminOrdersCubit extends Cubit<AdminOrdersState> {
  final GetAdminOrdersUseCase _getOrdersUseCase;
  final GetAdminOrderDetailsUseCase _getOrderDetailsUseCase;
  final UpdateOrderStatusUseCase _updateStatusUseCase;

  AdminOrdersCubit(
    this._getOrdersUseCase,
    this._getOrderDetailsUseCase,
    this._updateStatusUseCase,
  ) : super(AdminOrdersInitial());

  List<OrderModel> allOrders = [];
  String currentFilter = 'all';

  String _mapArabicFilterToBackend(String arabicOrCode) {
    switch (arabicOrCode) {
      case 'الكل':
      case 'all':
        return 'all';
      case 'قيد الانتظار':
      case 'pending':
        return 'pending';
      case 'قيد التجهيز':
      case 'processing':
        return 'processing';
      case 'مكتمل':
      case 'completed':
        return 'completed';
      default:
        return 'all';
    }
  }

  Future<void> getOrders({String status = 'all'}) async {
    currentFilter = _mapArabicFilterToBackend(status);
    final cacheKey = 'cache_admin_orders_$currentFilter';
    bool hasCache = false;
    try {
      final cached = await AppStorage.getCachedData(cacheKey);
      if (cached != null) {
        final List<dynamic> jsonList = jsonDecode(cached);
        allOrders = jsonList.map((e) => OrderModel.fromJson(e)).toList();
        hasCache = true;
        if (!isClosed) {
          emit(AdminOrdersLoaded(allOrders, activeFilter: currentFilter));
        }
      }
    } catch (_) {}

    if (!hasCache && !isClosed) {
      emit(AdminOrdersLoading());
    }

    final result = await _getOrdersUseCase(
      status: currentFilter == 'all' ? null : currentFilter,
    );

    result.fold(
      (failure) {
        if (!hasCache && !isClosed) {
          emit(AdminOrdersError(failure.errorMessage));
        }
      },
      (orders) {
        allOrders = orders;
        try {
          final jsonString =
              jsonEncode(orders.map((e) => e.toJson()).toList());
          AppStorage.cacheData(cacheKey, jsonString);
        } catch (_) {}
        if (!isClosed) {
          emit(AdminOrdersLoaded(orders, activeFilter: currentFilter));
        }
      },
    );
  }

  Future<void> filterOrdersByStatus(String status) async {
    await getOrders(status: status);
  }

  Future<void> getOrderDetails(int orderId) async {
    emit(AdminOrdersLoading());
    final result = await _getOrderDetailsUseCase(orderId);
    result.fold(
      (failure) {
        if (!isClosed) emit(AdminOrdersError(failure.errorMessage));
      },
      (order) {
        if (!isClosed) emit(AdminOrderDetailsLoaded(order));
      },
    );
  }

  Future<void> updateOrderStatus(int orderId, String newStatus) async {
    emit(AdminOrderStatusUpdating(orderId));
    final result = await _updateStatusUseCase(orderId, newStatus);
    result.fold(
      (failure) {
        if (!isClosed) emit(AdminOrdersError(failure.errorMessage));
      },
      (msg) async {
        if (!isClosed) {
          emit(AdminOrderStatusSuccess(msg));
          // Reactive Refresh: فوري وبدون إعادة تحميل يدوي
          await getOrders(status: currentFilter);
        }
      },
    );
  }
}
