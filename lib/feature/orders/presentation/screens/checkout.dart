import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/di/service_locator.dart';
import 'package:primo/core/helper/snack_bar_helper.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/app_button.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';
import 'package:primo/feature/addresses/presentation/bloc/adresses_cubit.dart';
import 'package:primo/feature/addresses/presentation/bloc/adresses_state.dart';
import 'package:primo/feature/cart/presentation/cubit/cart_cubit.dart';
import 'package:primo/feature/orders/presentation/bloc/checkout_cubit.dart';
import 'package:primo/feature/orders/presentation/bloc/checkout_state.dart';
import 'package:primo/feature/orders/presentation/widgets/adress_selection_sheet.dart';
import 'package:primo/feature/orders/presentation/widgets/delivery_method_card.dart';
import 'package:primo/feature/orders/presentation/widgets/summary_row.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: const CustomAppBar(
                title: "إتمام الطلب",
                showRightIcon: false,
              ),
            ),
            Expanded(
              child: BlocBuilder<CheckoutCubit, CheckoutState>(
                builder: (context, state) {
                  final cubit = context.read<CheckoutCubit>();

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 20.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "طريقة الاستلام",
                          style: AppTextStyle.font18.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textMain,
                          ),
                        ),
                        16.verticalSpace,
                        Row(
                          children: [
                            Expanded(
                              child: DeliveryMethodCard(
                                title: "توصيل للعنوان",
                                subtitle: "يصلك في أقرب وقت",
                                icon: Icons.local_shipping,
                                isSelected: cubit.selectedDeliveryMethod == 0,
                                onTap: () => cubit.changeDeliveryMethod(0),
                              ),
                            ),
                            16.horizontalSpace,
                            Expanded(
                              child: DeliveryMethodCard(
                                title: "استلام من المتجر",
                                subtitle: "جاهز للاستلام المباشر",
                                icon: Icons.storefront_outlined,
                                isSelected: cubit.selectedDeliveryMethod == 1,
                                onTap: () => cubit.changeDeliveryMethod(1),
                              ),
                            ),
                          ],
                        ),
                        32.verticalSpace,

                        if (cubit.selectedDeliveryMethod == 0) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "عنوان التوصيل",
                                style: AppTextStyle.font18.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textMain,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  final addressesCubit = context.read<AddressesCubit>();
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (_) => MultiBlocProvider(
                                      providers: [
                                        BlocProvider.value(value: cubit),
                                        BlocProvider.value(value: addressesCubit),
                                      ],
                                      child: const AddressSelectionSheet(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "تغيير",
                                  style: AppTextStyle.font14.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          16.verticalSpace,
                          BlocBuilder<AddressesCubit, AddressesState>(
                            builder: (context, addrState) {
                              final addresses = context.read<AddressesCubit>().addresses;
                              final selectedAddr = addresses.where(
                                (a) => a.id.toString() == cubit.selectedAddressId,
                              ).firstOrNull;

                              return Container(
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(
                                    color: AppColors.formBorder.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            selectedAddr?.name ?? "لم يتم تحديد عنوان",
                                            style: AppTextStyle.font16.copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.textMain,
                                            ),
                                          ),
                                          8.verticalSpace,
                                          Text(
                                            selectedAddr?.description ?? "الرجاء النقر على (تغيير) لاختيار عنوان توصيل",
                                            style: AppTextStyle.font14.copyWith(
                                              color: AppColors.greyMedium3,
                                              height: 1.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    12.horizontalSpace,
                                    Container(
                                      padding: EdgeInsets.all(8.w),
                                      decoration: const BoxDecoration(
                                        color: AppColors.greyBackground,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.location_on,
                                        color: AppColors.greyMedium1,
                                        size: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          32.verticalSpace,
                        ],

                        Text(
                          "ملخص الطلب",
                          style: AppTextStyle.font18.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textMain,
                          ),
                        ),
                        16.verticalSpace,
                        Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: AppColors.formBorder.withValues(alpha: 0.3),
                            ),
                          ),
                          child: state is CheckoutPriceLoading
                              ? Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20.h),
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : Column(
                                  children: [
                                    SummaryRow(
                                      title: "المجموع الفرعي",
                                      value: "${cubit.subTotal.toStringAsFixed(2)} ل.س",
                                    ),
                                    12.verticalSpace,
                                    SummaryRow(
                                      title: "رسوم التوصيل",
                                      value: "${cubit.deliveryFee.toStringAsFixed(2)} ل.س",
                                    ),
                                    16.verticalSpace,
                                    const Divider(
                                      color: AppColors.formBorder,
                                      thickness: 1,
                                    ),
                                    16.verticalSpace,
                                    SummaryRow(
                                      title: "الإجمالي",
                                      value: "${cubit.total.toStringAsFixed(2)} ل.س",
                                      isTotal: true,
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
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
              decoration: const BoxDecoration(color: AppColors.background),
              child: BlocConsumer<CheckoutCubit, CheckoutState>(
                listener: (context, state) {
                  if (state is CheckoutSuccess) {
                    getIt<CartCubit>().getCart();
                    context.showSuccess("تم تأكيد الطلب بنجاح!");
                    Navigator.pushReplacementNamed(context, Routes.orderHistory);
                  } else if (state is CheckoutError) {
                    context.showError(state.message);
                  }
                },
                builder: (context, state) {
                  return AppButton(
                    text: "تأكيد الطلب",
                    icon: Icons.lock_outline_rounded,
                    isLoading: state is CheckoutLoading,
                    onPressed: () {
                      if (state is! CheckoutLoading) {
                        context.read<CheckoutCubit>().submitOrder();
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
