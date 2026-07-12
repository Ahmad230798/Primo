import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/core/models/offer_model.dart';
import 'package:primo/core/models/product_model.dart';
import 'package:primo/core/models/variant_model.dart';
import '../../data/models/create_offer_request_body.dart';
import '../../data/models/update_offer_request_body.dart';
import '../../domain/usecases/manage_offers_usecase.dart';
import 'admin_offers_state.dart';

class AdminOffersCubit extends Cubit<AdminOffersState> {
  final ManageOffersUseCase _manageOffersUseCase;

  AdminOffersCubit(this._manageOffersUseCase) : super(AdminOffersInitial()) {
    discountController.addListener(_onDiscountChanged);
  }

  void _onDiscountChanged() {
    _emitUIChange();
  }

  final TextEditingController discountController = TextEditingController();
  bool isPercentage = true;
  String selectedVariantId = "1";
  DateTime? startDate;
  DateTime? endDate;
  int? editingOfferId;
  File? selectedImage;

  List<VariantModel> availableVariants = [];
  VariantModel? selectedVariant;

  double get priceBeforeDiscount {
    if (selectedVariant != null) {
      return double.tryParse(selectedVariant!.price?.toString() ?? '') ?? 0.0;
    }
    return 0.0;
  }

  double get priceAfterDiscount {
    final before = priceBeforeDiscount;
    if (before <= 0) return 0.0;
    final discountVal = double.tryParse(discountController.text.trim()) ?? 0.0;
    if (isPercentage) {
      final after = before - (before * (discountVal / 100));
      return after < 0 ? 0.0 : after;
    } else {
      final after = before - discountVal;
      return after < 0 ? 0.0 : after;
    }
  }

  void onDiscountInputChanged() {
    _emitUIChange();
  }

  void selectVariant(VariantModel? variant) {
    selectedVariant = variant;
    if (variant?.id != null) {
      selectedVariantId = variant!.id!.toString();
    }
    _emitUIChange();
  }

  void loadVariantsFromProducts(List<ProductModel> products) {
    availableVariants.clear();
    for (final p in products) {
      if (p.variants != null) {
        for (final v in p.variants!) {
          availableVariants.add(v);
        }
      }
    }
    if (selectedVariant == null && availableVariants.isNotEmpty) {
      selectVariant(availableVariants.first);
    }
  }

  static String _formatDate(DateTime dt) =>
      "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";

  String get startDateText =>
      startDate != null ? _formatDate(startDate!) : "mm/dd/yyyy";
  String get endDateText =>
      endDate != null ? _formatDate(endDate!) : "mm/dd/yyyy";

  void initForEdit(OfferModel offer) {
    editingOfferId = offer.id;
    discountController.text =
        offer.discountValue?.toString() ?? offer.variantPrice?.toString() ?? "";
    if (offer.from != null) {
      try {
        startDate = DateTime.parse(offer.from!);
      } catch (_) {}
    }
    if (offer.to != null) {
      try {
        endDate = DateTime.parse(offer.to!);
      } catch (_) {}
    }
    if (offer.variantId != null) {
      selectedVariantId = offer.variantId.toString();
      try {
        selectedVariant = availableVariants.firstWhere(
          (v) => v.id.toString() == selectedVariantId,
        );
      } catch (_) {}
    }
    selectedImage = null;
    emit(AdminOffersInitial());
  }

  void clearForAdd() {
    editingOfferId = null;
    selectedVariant = availableVariants.isNotEmpty
        ? availableVariants.first
        : null;
    if (selectedVariant?.id != null) {
      selectedVariantId = selectedVariant!.id!.toString();
    }
    _resetForm();
    emit(AdminOffersInitial());
  }

  void changeOfferType(bool percentage) {
    isPercentage = percentage;
    _emitUIChange();
  }

  void setStartDate(DateTime date) {
    startDate = date;
    _emitUIChange();
  }

  void setEndDate(DateTime date) {
    endDate = date;
    _emitUIChange();
  }

  void _emitUIChange() {
    emit(
      AdminOffersUIChanged(
        isPercentage: isPercentage,
        fromDate: startDateText,
        toDate: endDateText,
        discountValue: discountController.text,
      ),
    );
  }

  void createOffer() async {
    if (discountController.text.trim().isEmpty) {
      emit(const AdminOffersError("حقل قيمة الخصم مطلوب"));
      return;
    }
    if (startDate == null || endDate == null) {
      emit(const AdminOffersError("يرجى تحديد تواريخ العرض كاملة"));
      return;
    }

    emit(AdminOffersLoading());

    final body = CreateOfferRequestBody(
      variantId: selectedVariantId,
      fromDate: startDateText,
      toDate: endDateText,
      discountPercentage: isPercentage ? discountController.text.trim() : null,
      discountValue: !isPercentage ? discountController.text.trim() : null,
    );

    final response = await _manageOffersUseCase.createOffer(body);

    response.fold((failure) => emit(AdminOffersError(failure.errorMessage)), (
      success,
    ) {
      _resetForm();
      emit(AdminOffersSuccess(success.message ?? "تم إضافة العرض بنجاح"));
    });
  }

  void updateOffer() async {
    if (editingOfferId == null) return;
    if (discountController.text.trim().isEmpty) {
      emit(const AdminOffersError("حقل قيمة الخصم مطلوب"));
      return;
    }
    if (startDate == null || endDate == null) {
      emit(const AdminOffersError("يرجى تحديد تواريخ العرض كاملة"));
      return;
    }

    emit(AdminOffersLoading());

    // optional image rule applied
    final body = UpdateOfferRequestBody(
      variantId: selectedVariantId,
      fromDate: startDateText,
      toDate: endDateText,
      discountPercentage: isPercentage ? discountController.text.trim() : null,
      discountValue: !isPercentage ? discountController.text.trim() : null,
      image: selectedImage,
    );

    final response = await _manageOffersUseCase.updateOffer(
      editingOfferId!,
      body,
    );

    response.fold((failure) => emit(AdminOffersError(failure.errorMessage)), (
      success,
    ) {
      emit(AdminOffersSuccess(success.message ?? "تم تعديل العرض بنجاح"));
    });
  }

  void _resetForm() {
    discountController.clear();
    startDate = null;
    endDate = null;
    isPercentage = true;
    selectedImage = null;
  }

  @override
  Future<void> close() {
    discountController.dispose();
    return super.close();
  }
}
