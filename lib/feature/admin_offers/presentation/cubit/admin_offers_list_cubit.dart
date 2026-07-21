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
        if (!isClosed) emit(AdminOffersListLoaded(offers));
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
          if (!isClosed) {
            emit(AdminOffersListLoaded(offers));
          }
        },
      );
    } catch (e) {
      if (!isClosed) emit(AdminOffersListError(e.toString()));
    }
  }

  Future<void> deleteOffer(int offerId) async {
    if (!isClosed) {
      emit(AdminOffersListLoading());
    }
    try {
      final result = await _useCase.deleteOffer(offerId);
      result.fold(
        (failure) {
          if (!isClosed) emit(AdminOffersListError(failure.errorMessage));
        },
        (success) {
          offers.removeWhere((o) => o.id == offerId);
          if (!isClosed) {
            emit(const AdminOfferDeleteSuccess("تم حذف العرض بنجاح"));
            emit(AdminOffersListLoaded(offers));
          }
        },
      );
    } catch (e) {
      if (!isClosed) emit(AdminOffersListError(e.toString()));
    }
  }
}
