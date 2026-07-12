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

    final result = await _useCase.getAllOffers();
    result.fold((failure) => emit(AdminOffersListError(failure.errorMessage)), (
      data,
    ) {
      offers = data;
      emit(AdminOffersListLoaded(offers));
    });
  }

  Future<void> deleteOffer(int offerId) async {
    if (!isClosed) {
      emit(AdminOffersListLoading());
    }
    final result = await _useCase.deleteOffer(offerId);
    result.fold((failure) => emit(AdminOffersListError(failure.errorMessage)), (
      success,
    ) {
      offers.removeWhere((o) => o.id == offerId);
      emit(const AdminOfferDeleteSuccess("تم حذف العرض بنجاح"));
      emit(AdminOffersListLoaded(offers));
    });
  }
}
