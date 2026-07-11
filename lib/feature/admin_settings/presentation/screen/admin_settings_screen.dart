// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:latlong2/latlong.dart';
import 'package:primo/core/helper/snack_bar_helper.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/admin_drawer.dart';
import 'package:primo/core/widgets/app_button.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';
import 'package:primo/feature/addresses/presentation/screen/map_picker_screen.dart';
import 'package:primo/feature/admin_settings/presentation/cubit/add_store_address_cubit.dart';
import 'package:primo/feature/admin_settings/presentation/cubit/add_store_address_state.dart';
import 'package:primo/feature/admin_settings/presentation/cubit/store_settings_cubit.dart';
import 'package:primo/feature/admin_settings/presentation/cubit/store_settings_state.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  final _priceController = TextEditingController();
  final _descController = TextEditingController();

  double? _selectedLat;
  double? _selectedLng;
  bool _isLocationSelected = false;
  bool _priceInitialized = false;

  @override
  void initState() {
    super.initState();
    context.read<StoreSettingsCubit>().getDeliveryPrice();
  }

  @override
  void dispose() {
    _priceController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _updatePrice() {
    final priceStr = _priceController.text.trim();
    if (priceStr.isEmpty) {
      context.showError("الرجاء إدخال سعر التوصيل");
      return;
    }
    final price = num.tryParse(priceStr);
    if (price == null) {
      context.showError("الرجاء إدخال رقم صحيح");
      return;
    }
    context.read<StoreSettingsCubit>().updateDeliveryPrice(price);
  }

  void _addAddress() {
    final desc = _descController.text.trim();
    if (desc.isEmpty) {
      context.showError("الرجاء إدخال وصف العنوان");
      return;
    }
    if (!_isLocationSelected || _selectedLat == null || _selectedLng == null) {
      context.showError("الرجاء تحديد موقع الفرع على الخريطة");
      return;
    }
    context.read<AddStoreAddressCubit>().addStoreAddress(
          description: desc,
          locationLat: _selectedLat!,
          locationLng: _selectedLng!,
        );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<StoreSettingsCubit, StoreSettingsState>(
          listener: (context, state) {
            if (state is StoreSettingsLoaded && !_priceInitialized) {
              _priceController.text = state.deliveryPriceModel.price.toString();
              _priceInitialized = true;
            } else if (state is StoreSettingsUpdateSuccess) {
              context.showSuccess(state.message);
            } else if (state is StoreSettingsError) {
              context.showError(state.message);
            }
          },
        ),
        BlocListener<AddStoreAddressCubit, AddStoreAddressState>(
          listener: (context, state) {
            if (state is AddStoreAddressSuccess) {
              context.showSuccess(state.message);
              setState(() {
                _descController.clear();
                _selectedLat = null;
                _selectedLng = null;
                _isLocationSelected = false;
              });
            } else if (state is AddStoreAddressError) {
              context.showError(state.message);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        drawer: const AdminDrawer(currentRoute: Routes.adminSettings),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomAppBar(
                    title: "إعدادات المتجر",
                    suffixsIcon: InkWell(
                      onTap: () => Navigator.pushNamed(context, Routes.notifications),
                      borderRadius: BorderRadius.circular(99.r),
                      child: Padding(
                        padding: EdgeInsets.all(4.w),
                        child: Icon(
                          Icons.notifications_none_rounded,
                          color: AppColors.textMain,
                          size: 28.sp,
                        ),
                      ),
                    ),
                    icon: Icon(
                      Icons.menu_rounded,
                      color: AppColors.textMain,
                      size: 28.sp,
                    ),
                    showRightIcon: true,
                  ),
                  24.verticalSpace,
                  _buildDeliveryPriceCard(),
                  24.verticalSpace,
                  _buildAddAddressCard(),
                  40.verticalSpace,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeliveryPriceCard() {
    return BlocBuilder<StoreSettingsCubit, StoreSettingsState>(
      builder: (context, state) {
        final isLoading = state is StoreSettingsUpdating;
        return Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.formBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.local_shipping_rounded, color: AppColors.primary, size: 24.sp),
                  12.horizontalSpace,
                  Text(
                    "سعر التوصيل الافتراضي",
                    style: AppTextStyle.font18.copyWith(
                      color: AppColors.textMain,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              16.verticalSpace,
              Text(
                "سعر التوصيل (ل.س)",
                style: AppTextStyle.font14.copyWith(fontWeight: FontWeight.w600),
              ),
              8.verticalSpace,
              TextFormField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: "أدخل سعر التوصيل...",
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: AppColors.formBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: AppColors.formBorder),
                  ),
                ),
              ),
              20.verticalSpace,
              AppButton(
                text: "تحديث سعر التوصيل",
                isLoading: isLoading,
                onPressed: isLoading ? null : _updatePrice,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddAddressCard() {
    return BlocBuilder<AddStoreAddressCubit, AddStoreAddressState>(
      builder: (context, state) {
        final isLoading = state is AddStoreAddressLoading;
        return Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.formBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.storefront_rounded, color: AppColors.primary, size: 24.sp),
                  12.horizontalSpace,
                  Text(
                    "إضافة موقع فرع المتجر",
                    style: AppTextStyle.font18.copyWith(
                      color: AppColors.textMain,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              16.verticalSpace,
              Text(
                "وصف العنوان أو اسم الفرع",
                style: AppTextStyle.font14.copyWith(fontWeight: FontWeight.w600),
              ),
              8.verticalSpace,
              TextFormField(
                controller: _descController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: "الفرع الرئيسي، شارع الملك فيصل...",
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: AppColors.formBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: AppColors.formBorder),
                  ),
                ),
              ),
              16.verticalSpace,
              Text(
                "موقع الفرع على الخريطة (إجباري)",
                style: AppTextStyle.font14.copyWith(fontWeight: FontWeight.w600),
              ),
              8.verticalSpace,
              InkWell(
                onTap: () async {
                  final selectedLatLng = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MapPickerScreen(
                        initialLat: _selectedLat ?? 33.5138,
                        initialLng: _selectedLng ?? 36.2765,
                      ),
                    ),
                  );
                  if (selectedLatLng != null && selectedLatLng is LatLng) {
                    setState(() {
                      _selectedLat = selectedLatLng.latitude;
                      _selectedLng = selectedLatLng.longitude;
                      _isLocationSelected = true;
                    });
                  }
                },
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    color: _isLocationSelected ? AppColors.white : AppColors.background,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: _isLocationSelected ? Colors.green : AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isLocationSelected ? Icons.location_on : Icons.map_outlined,
                        color: _isLocationSelected ? Colors.green : AppColors.primary,
                        size: 26.sp,
                      ),
                      12.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isLocationSelected
                                  ? "تم تحديد الموقع على الخريطة بنجاح"
                                  : "اضغط لتحديد موقع الفرع على الخريطة",
                              style: AppTextStyle.font14.copyWith(
                                fontWeight: FontWeight.w700,
                                color: _isLocationSelected
                                    ? Colors.green.shade800
                                    : AppColors.textMain,
                              ),
                            ),
                            4.verticalSpace,
                            Text(
                              _isLocationSelected
                                  ? "Lat: \${_selectedLat!.toStringAsFixed(6)} , Lng: \${_selectedLng!.toStringAsFixed(6)}"
                                  : "استخدم الخريطة التفاعلية لتحديد الموقع بدقة",
                              style: AppTextStyle.font12.copyWith(
                                color: AppColors.greyMedium3,
                              ),
                              textDirection: TextDirection.ltr,
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: _isLocationSelected ? Colors.green : AppColors.primary,
                        size: 16.sp,
                      ),
                    ],
                  ),
                ),
              ),
              20.verticalSpace,
              AppButton(
                text: "إضافة العنوان",
                isLoading: isLoading,
                onPressed: isLoading ? null : _addAddress,
              ),
            ],
          ),
        );
      },
    );
  }
}
