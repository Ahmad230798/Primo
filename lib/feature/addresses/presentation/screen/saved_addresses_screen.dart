import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/app_button.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';
import 'package:primo/core/helper/snack_bar_helper.dart';
import 'package:primo/feature/addresses/data/models/address_model.dart';
import 'package:primo/feature/addresses/presentation/bloc/adresses_cubit.dart';
import 'package:primo/feature/addresses/presentation/bloc/adresses_state.dart';
import 'package:primo/feature/addresses/presentation/widgets/address_card.dart';
import 'package:primo/feature/addresses/presentation/widgets/add_edit_address_sheet.dart';

class SavedAddressesScreen extends StatelessWidget {
  const SavedAddressesScreen({super.key});

  void _showAddEditSheet(BuildContext context, {AddressModel? address}) {
    final cubit = context.read<AddressesCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: AddEditAddressSheet(address: address),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, AddressModel address) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("حذف العنوان"),
        content: Text("هل أنت متأكد من رغبتك في حذف '${address.name}'؟"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("إلغاء"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              if (address.id != null) {
                context.read<AddressesCubit>().deleteAddress(address.id!);
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("حذف"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            const CustomAppBar(title: "العناوين", showRightIcon: false),

            Expanded(
              child: BlocConsumer<AddressesCubit, AddressesState>(
                listener: (context, state) {
                  if (state is AddressActionSuccess) {
                    context.showSuccess(state.message);
                  } else if (state is AddressActionError) {
                    context.showError(state.message);
                  } else if (state is AddressesError) {
                    context.showError(state.message);
                  }
                },
                builder: (context, state) {
                  final cubit = context.read<AddressesCubit>();
                  final savedAddresses = cubit.addresses;

                  if (state is AddressesLoading && savedAddresses.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (savedAddresses.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_off_outlined,
                            size: 64.sp,
                            color: AppColors.greyMedium3,
                          ),
                          16.verticalSpace,
                          Text(
                            "لا توجد عناوين محفوظة حالياً",
                            style: AppTextStyle.font16.copyWith(
                              color: AppColors.greyMedium3,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 20.h,
                    ),
                    itemCount: savedAddresses.length,
                    itemBuilder: (context, index) {
                      final address = savedAddresses[index];
                      return AddressCard(
                        title: address.name ?? '',
                        details: address.description ?? '',
                        icon: address.icon,
                        isDefault: address.isDefault,
                        onTap: () {
                          context.read<AddressesCubit>().setDefaultAddress(
                            address.id,
                          );
                        },
                        onEditTap: () =>
                            _showAddEditSheet(context, address: address),
                        onDeleteTap: () => _showDeleteDialog(context, address),
                      );
                    },
                  );
                },
              ),
            ),

            Container(
              padding: EdgeInsets.only(
                left: 24.w,
                right: 24.w,
                bottom: 24.h,
                top: 16.h,
              ),
              color: AppColors.background,
              child: AppButton(
                text: "إضافة عنوان جديد",
                icon: Icons.add,
                onPressed: () => _showAddEditSheet(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
