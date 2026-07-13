import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/app_cached_network_image.dart';
import 'package:primo/core/widgets/admin_drawer.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';
import 'package:primo/feature/admin_product/presentation/cubit/admin_products_list_cubit.dart';
import 'package:primo/feature/admin_product/presentation/cubit/admin_products_list_state.dart';
import '../cubit/admin_offers_cubit.dart';
import '../cubit/admin_offers_list_cubit.dart';
import '../cubit/admin_offers_list_state.dart';

class AdminOffersScreen extends StatefulWidget {
  const AdminOffersScreen({super.key});

  @override
  State<AdminOffersScreen> createState() => _AdminOffersScreenState();
}

class _AdminOffersScreenState extends State<AdminOffersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncProductsWithOffers();
    });
  }

  // دالة المزامنة بين الكيوبت الخاص بالمنتجات والكيوبت الخاص بالعروض
  void _syncProductsWithOffers() {
    if (!mounted) return;

    final offersCubit = context.read<AdminOffersCubit>();
    final productsCubit = context.read<AdminProductsListCubit>();

    if (productsCubit.allProducts.isNotEmpty &&
        offersCubit.availableVariants.isEmpty) {
      offersCubit.loadVariantsFromProducts(productsCubit.allProducts);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const AdminDrawer(currentRoute: Routes.adminOffers),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<AdminOffersCubit>().clearForAdd();
          Navigator.pushNamed(context, Routes.createOffer);
        },
        backgroundColor: AppColors.primary,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Icon(Icons.add_rounded, color: AppColors.white, size: 32.sp),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: CustomAppBar(
                title: "Primo",
                suffixsIcon: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.notifications);
                  },
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
            ),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async {
                  await context.read<AdminOffersListCubit>().getOffers();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      24.verticalSpace,
                      Text(
                        "العروض والخصومات",
                        style: AppTextStyle.font30.copyWith(
                          color: AppColors.textMain,
                        ),
                      ),
                      4.verticalSpace,
                      Text(
                        "إدارة العروض الترويجية والخصومات المتاحة للزبائن.",
                        style: AppTextStyle.font14.copyWith(
                          color: AppColors.greyMedium3,
                        ),
                      ),
                      24.verticalSpace,

                      BlocListener<
                        AdminProductsListCubit,
                        AdminProductsListState
                      >(
                        listener: (context, state) {
                          _syncProductsWithOffers(); // تحديث القائمة المنسدلة فور وصول المنتجات
                        },
                        child: BlocBuilder<AdminOffersListCubit, AdminOffersListState>(
                          builder: (context, state) {
                            if (state is AdminOffersListLoading) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.all(40.h),
                                  child: const CircularProgressIndicator(
                                    color: AppColors.primary,
                                  ),
                                ),
                              );
                            } else if (state is AdminOffersListError) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.all(40.h),
                                  child: Text(
                                    state.message,
                                    style: AppTextStyle.font16.copyWith(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              );
                            }

                            final offers = context
                                .read<AdminOffersListCubit>()
                                .offers;

                            if (offers.isEmpty) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.all(40.h),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.campaign_outlined,
                                        size: 64.sp,
                                        color: AppColors.greyMedium3,
                                      ),
                                      16.verticalSpace,
                                      Text(
                                        "لا توجد عروض حالياً",
                                        style: AppTextStyle.font16.copyWith(
                                          color: AppColors.textMain,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: offers.length,
                              separatorBuilder: (context, index) =>
                                  16.verticalSpace,
                              itemBuilder: (context, index) {
                                final offer = offers[index];
                                return Container(
                                  padding: EdgeInsets.all(16.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(16.r),
                                    border: Border.all(
                                      color: AppColors.formBorder,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 64.w,
                                        height: 64.w,
                                        decoration: BoxDecoration(
                                          color: AppColors.greyBackground,
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                          child: offer.fullImageUrl != null
                                              ? AppCachedNetworkImage(
                                                  imageUrl: offer.fullImageUrl!,
                                                  fit: BoxFit.cover,
                                                  errorWidget: Icon(
                                                    Icons.local_offer_rounded,
                                                    color: AppColors.primary,
                                                  ),
                                                )
                                              : Icon(
                                                  Icons.local_offer_rounded,
                                                  color: AppColors.primary,
                                                ),
                                        ),
                                      ),
                                      16.horizontalSpace,
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              offer.productName ?? "منتج العرض",
                                              style: AppTextStyle.font16
                                                  .copyWith(
                                                    color: AppColors.textMain,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            4.verticalSpace,
                                            Text(
                                              "الخصم: ${offer.discountValue ?? ''}",
                                              style: AppTextStyle.font14
                                                  .copyWith(
                                                    color: AppColors.primary,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            4.verticalSpace,
                                            Text(
                                              "من ${offer.from ?? ''} إلى ${offer.to ?? ''}",
                                              style: AppTextStyle.font12
                                                  .copyWith(
                                                    color:
                                                        AppColors.greyMedium3,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          context
                                              .read<AdminOffersCubit>()
                                              .initForEdit(offer);
                                          Navigator.pushNamed(
                                            context,
                                            Routes.createOffer,
                                          );
                                        },
                                        icon: Icon(
                                          Icons.edit_rounded,
                                          color: AppColors.primary,
                                          size: 22.sp,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          if (offer.id != null) {
                                            context
                                                .read<AdminOffersListCubit>()
                                                .deleteOffer(offer.id!);
                                          }
                                        },
                                        icon: Icon(
                                          Icons.delete_outline_rounded,
                                          color: AppColors.primary,
                                          size: 22.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      100.verticalSpace,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
