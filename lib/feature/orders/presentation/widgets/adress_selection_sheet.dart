// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/helper/navigation.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/feature/addresses/presentation/bloc/adresses_cubit.dart';
import 'package:primo/feature/addresses/presentation/bloc/adresses_state.dart';
import 'package:primo/feature/orders/presentation/bloc/checkout_cubit.dart';
import 'package:primo/feature/orders/presentation/bloc/checkout_state.dart';

class AddressSelectionSheet extends StatelessWidget {
  const AddressSelectionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: 1.sw,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "اختر عنوان التوصيل",
                  style: AppTextStyle.font20.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textMain),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            16.verticalSpace,
            BlocBuilder<AddressesCubit, AddressesState>(
              builder: (context, addrState) {
                final addresses = context.read<AddressesCubit>().addresses;
                if (addrState is AddressesLoading && addresses.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (addresses.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Text(
                        "لا توجد عناوين محفوظة حالياً",
                        style: AppTextStyle.font16.copyWith(
                          color: AppColors.greyMedium3,
                        ),
                      ),
                    ),
                  );
                }

                return BlocBuilder<CheckoutCubit, CheckoutState>(
                  builder: (context, checkoutState) {
                    final selectedId = context
                        .read<CheckoutCubit>()
                        .selectedAddressId;

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: addresses.length,
                      separatorBuilder: (context, index) =>
                          Divider(color: AppColors.formBorder, height: 24.h),
                      itemBuilder: (context, index) {
                        final address = addresses[index];
                        final idStr = address.id.toString();

                        return InkWell(
                          onTap: () {
                            context.read<CheckoutCubit>().changeAddress(idStr);
                            Navigator.pop(context);
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: const BoxDecoration(
                                  color: AppColors.greyBackground,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.location_on,
                                  color: AppColors.greyMedium1,
                                ),
                              ),
                              12.horizontalSpace,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      address.name ?? "عنوان",
                                      style: AppTextStyle.font16.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    4.verticalSpace,
                                    Text(
                                      address.description ?? "",
                                      style: AppTextStyle.font14.copyWith(
                                        color: AppColors.greyMedium3,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Radio<String>(
                                value: idStr,
                                groupValue: selectedId,
                                activeColor: AppColors.primary,
                                onChanged: (value) {
                                  if (value != null) {
                                    context.read<CheckoutCubit>().changeAddress(
                                      value,
                                    );
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
            24.verticalSpace,
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  final addressesCubit = context.read<AddressesCubit>();
                  context.pop();
                  context.pushNamed(
                    Routes.addresses,
                    arguments: addressesCubit,
                  );
                },
                icon: const Icon(
                  Icons.add_location_alt_outlined,
                  color: AppColors.primary,
                ),
                label: Text(
                  "إدارة / إضافة عنوان جديد",
                  style: AppTextStyle.font14.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  side: const BorderSide(color: AppColors.primary, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
              ),
            ),
            16.verticalSpace,
          ],
        ),
      ),
    );
  }
}
