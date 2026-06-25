import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // 1. استيراد المكتبة
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/app_button.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';
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

            // 2. تغليف المحتوى القابل للتغير بـ BlocBuilder
            Expanded(
              child: BlocBuilder<CheckoutCubit, CheckoutState>(
                builder: (context, state) {
                  // استدعاء نسخة الـ Cubit للوصول إلى المتغيرات والدوال
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
                                subtitle: "يصلك خلال 30 دقيقة",
                                icon: Icons.local_shipping,
                                // ربط حالة التحديد بمتغير الـ Cubit
                                isSelected: cubit.selectedDeliveryMethod == 0,
                                // استدعاء دالة التغيير عند النقر
                                onTap: () => cubit.changeDeliveryMethod(0),
                              ),
                            ),
                            16.horizontalSpace,
                            Expanded(
                              child: DeliveryMethodCard(
                                title: "استلام من المتجر",
                                subtitle: "جاهز خلال 15 دقيقة",
                                icon: Icons.storefront_outlined,
                                isSelected: cubit.selectedDeliveryMethod == 1,
                                onTap: () => cubit.changeDeliveryMethod(1),
                              ),
                            ),
                          ],
                        ),
                        32.verticalSpace,

                        // إظهار قسم العنوان فقط إذا كانت طريقة الاستلام هي التوصيل
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
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (_) => BlocProvider.value(
                                      // تمرير نفس الـ Cubit للنافذة المنبثقة لتتمكن من تغيير العنوان
                                      value: cubit,
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
                          Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "المنزل",
                                        style: AppTextStyle.font16.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textMain,
                                        ),
                                      ),
                                      8.verticalSpace,
                                      Text(
                                        "شارع التحلية، حي العليا، مبنى 45، شقة 12\nالرياض، المملكة العربية السعودية",
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
                          ),
                          child: Column(
                            children: [
                              // 3. استخدام المتغيرات المحسوبة من الـ Cubit للفاتورة
                              SummaryRow(
                                title: "المجموع الفرعي",
                                value:
                                    "${cubit.subTotal.toStringAsFixed(2)} ر.س",
                              ),
                              12.verticalSpace,
                              SummaryRow(
                                title: "رسوم التوصيل",
                                value:
                                    "${cubit.deliveryFee.toStringAsFixed(2)} ر.س",
                              ),
                              16.verticalSpace,
                              const Divider(
                                color: AppColors.formBorder,
                                thickness: 1,
                              ),
                              16.verticalSpace,
                              SummaryRow(
                                title: "الإجمالي",
                                value: "${cubit.total.toStringAsFixed(2)} ر.س",
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

            // 4. زر التأكيد مع BlocConsumer لمعالجة حالات التحميل، النجاح، والخطأ
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
                    // الانتقال لشاشة نجاح الطلب
                    // Navigator.pushNamed(context, '/order-success');
                  } else if (state is CheckoutError) {
                    // إظهار رسالة الخطأ
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return AppButton(
                    text: "تأكيد الطلب",
                    icon: Icons.lock_outline_rounded,
                    // يظهر مؤشر التحميل تلقائياً إذا كانت الحالة Loading
                    isLoading: state is CheckoutLoading,
                    onPressed: () {
                      // يمنع إرسال الطلب مرة أخرى إذا كان قيد التحميل
                      if (state! is CheckoutLoading) {
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
