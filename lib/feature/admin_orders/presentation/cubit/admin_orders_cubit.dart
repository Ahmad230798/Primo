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
      case 'ملغي':
      case 'canceled':
        return 'canceled';
      default:
        return 'all';
    }
  }

  bool _isCancelledStatus(String status) {
    final st = status.trim().toLowerCase();
    return st == 'canceled' ||
        st == 'cancelled' ||
        st == 'rejected' ||
        st == 'refused' ||
        st == 'ملغي' ||
        st == 'مرفوض';
  }

  List<OrderModel> _applyStrictFilter(
    List<OrderModel> rawOrders,
    String filter,
  ) {
    if (filter == 'canceled') {
      return rawOrders.where((o) => _isCancelledStatus(o.status)).toList();
    } else if (filter == 'all') {
      return rawOrders.where((o) => !_isCancelledStatus(o.status)).toList();
    } else {
      return rawOrders.where((o) {
        if (_isCancelledStatus(o.status)) return false;
        final st = o.status.trim().toLowerCase();
        if (filter == 'pending') {
          return st == 'pending' || st == 'قيد الانتظار';
        } else if (filter == 'processing') {
          return st == 'processing' || st == 'قيد التجهيز';
        } else if (filter == 'completed') {
          return st == 'completed' ||
              st == 'delivered' ||
              st == 'approved' ||
              st == 'مكتمل' ||
              st == 'تم التسليم';
        }
        return true;
      }).toList();
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
        final rawOrders = jsonList.map((e) => OrderModel.fromJson(e)).toList();
        allOrders = _applyStrictFilter(rawOrders, currentFilter);
        hasCache = true;
        if (!isClosed) {
          emit(AdminOrdersLoaded(allOrders, activeFilter: currentFilter));
        }
      }
    } catch (_) {}

    if (!hasCache && !isClosed) {
      emit(AdminOrdersLoading());
    }

    try {
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
          allOrders = _applyStrictFilter(orders, currentFilter);
          try {
            final jsonString = jsonEncode(
              orders.map((e) => e.toJson()).toList(),
            );
            AppStorage.cacheData(cacheKey, jsonString);
          } catch (_) {}
          if (!isClosed) {
            emit(AdminOrdersLoaded(allOrders, activeFilter: currentFilter));
          }
        },
      );
    } catch (e) {
      if (!hasCache && !isClosed) {
        emit(AdminOrdersError(e.toString()));
      }
    }
  }

  Future<void> filterOrdersByStatus(String status) async {
    await getOrders(status: status);
  }

  Future<void> getOrderDetails(int orderId, {bool isSilent = false}) async {
    if (!isSilent) {
      emit(AdminOrdersLoading());
    }
    try {
      final result = await _getOrderDetailsUseCase(orderId);
      result.fold(
        (failure) {
          if (!isClosed) emit(AdminOrdersError(failure.errorMessage));
        },
        (order) {
          if (!isClosed) emit(AdminOrderDetailsLoaded(order));
        },
      );
    } catch (e) {
      if (!isClosed) emit(AdminOrdersError(e.toString()));
    }
  }

  Future<void> updateOrderStatus(int orderId, String newStatus) async {
    emit(AdminOrderStatusUpdating(orderId));
    try {
      final result = await _updateStatusUseCase(orderId, newStatus);

      result.fold(
        (failure) {
          if (!isClosed) emit(AdminOrdersError(failure.errorMessage));
        },
        (msg) {
          // 💡 قمنا بإزالة كلمة async من هنا لكي لا ننتظر التفاصيل
          final index = allOrders.indexWhere((o) => o.id == orderId);
          if (index != -1) {
            allOrders[index] = allOrders[index].copyWith(status: newStatus);
          }
          allOrders = _applyStrictFilter(allOrders, currentFilter);
          try {
            final cacheKey = 'cache_admin_orders_$currentFilter';
            final jsonString = jsonEncode(
              allOrders.map((e) => e.toJson()).toList(),
            );
            AppStorage.cacheData(cacheKey, jsonString);
          } catch (_) {}

          // 💡 1. نرسل التحديث للواجهة "فوراً" لكي يختفي اللودينغ ويشعر المستخدم بسرعة الاستجابة
          if (!isClosed) {
            emit(AdminOrderStatusSuccess(msg));
            emit(AdminOrdersLoaded(allOrders, activeFilter: currentFilter));
          }

          // 💡 2. نجلب التفاصيل في الخلفية بصمت "بدون await" لكي لا نؤخر استجابة الزر!
          getOrderDetails(orderId, isSilent: true);
        },
      );
    } catch (e) {
      if (!isClosed) emit(AdminOrdersError(e.toString()));
    }
  }
}
