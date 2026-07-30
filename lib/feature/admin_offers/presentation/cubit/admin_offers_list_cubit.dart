import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/core/models/offer_model.dart';
import 'package:primo/core/network/app_storage.dart';
import '../../domain/usecases/manage_offers_usecase.dart';
import 'admin_offers_list_state.dart';

class AdminOffersListCubit extends Cubit<AdminOffersListState> {
  final ManageOffersUseCase _useCase;
  List<OfferModel> offers = [];

  AdminOffersListCubit(this._useCase) : super(AdminOffersListInitial());

  Future<void> getOffers() async {
    bool hasCache = false;
    try {
      final cached = await AppStorage.getCachedData('cache_admin_offers');
      if (cached != null) {
        final List<dynamic> jsonList = jsonDecode(cached);
        offers = jsonList.map((e) => OfferModel.fromJson(e)).toList();
        hasCache = true;
        // 💡 إعطاء نسخة جديدة من القائمة لضمان تحديث الواجهة
        if (!isClosed) emit(AdminOffersListLoaded(List.from(offers)));
      }
    } catch (_) {}

    if (!hasCache && !isClosed) {
      emit(AdminOffersListLoading());
    }

    try {
      final result = await _useCase.getAllOffers();
      result.fold(
        (failure) {
          if (!isClosed) emit(AdminOffersListError(failure.errorMessage));
        },
        (data) {
          offers = data;
          try {
            final jsonString = jsonEncode(
              offers.map((e) => e.toJson()).toList(),
            );
            AppStorage.cacheData('cache_admin_offers', jsonString);
          } catch (_) {}

          if (!isClosed) {
            // 💡 إرسال حالة ابتدائية ثم إعطاء نسخة جديدة كلياً لكسر عناد الـ Bloc
            emit(AdminOffersListInitial());
            emit(AdminOffersListLoaded(List.from(offers)));
          }
        },
      );
    } catch (e) {
      if (!isClosed) emit(AdminOffersListError(e.toString()));
    }
  }

  void deleteOffer(int id) async {
    if (!isClosed) emit(AdminOffersListLoading());

    try {
      final response = await _useCase.deleteOffer(id);

      response.fold(
        (failure) {
          if (!isClosed) emit(AdminOffersListError(failure.errorMessage));
        },
        (success) {
          if (!isClosed) {
            // 1. الحذف من القائمة محلياً
            offers.removeWhere((offer) => offer.id == id);

            // 2. تحديث الكاش فوراً
            try {
              final jsonString = jsonEncode(
                offers.map((e) => e.toJson()).toList(),
              );
              AppStorage.cacheData('cache_admin_offers', jsonString);
            } catch (_) {}

            // 3. 💡 السطر السحري:
            // استخدام List.from يصنع مرجعاً جديداً بالذاكرة للقائمة
            // وبذلك ينتبه فلاتر أن هناك تغييراً ويقوم برسم الشاشة فوراً!
            emit(AdminOffersListInitial());
            emit(AdminOffersListLoaded(List.from(offers)));
          }
        },
      );
    } catch (e) {
      if (!isClosed) emit(AdminOffersListError(e.toString()));
    }
  }
}
