import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/app_cached_network_image.dart';
import 'package:primo/core/widgets/admin_drawer.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';
import 'package:primo/core/widgets/custom_error_retry_widget.dart';
import 'package:primo/feature/admin_product/presentation/cubit/admin_products_list_cubit.dart';
import 'package:primo/feature/admin_product/presentation/cubit/admin_products_list_state.dart';
import '../cubit/admin_offers_cubit.dart';
import '../cubit/admin_offers_list_cubit.dart';
import '../cubit/admin_offers_list_state.dart';
import 'package:primo/core/widgets/app_shimmer_skeletons.dart';
import 'package:primo/core/widgets/app_empty_state.dart';

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
                    Navigator.pushNamed(context, Routes.adminNotificationsHistory);
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
                              return ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 5,
                                separatorBuilder: (context, index) => 16.verticalSpace,
                                itemBuilder: (context, index) => const ListTileShimmer(),
                              );
                            } else if (state is AdminOffersListError) {
                              return CustomErrorRetryWidget(
                                message: state.message,
                                onRetry: () => context
                                    .read<AdminOffersListCubit>()
                                    .getOffers(),
                              );
                            }

                            final offers = context
                                .read<AdminOffersListCubit>()
                                .offers;

                            if (offers.isEmpty) {
                              return AppEmptyState(
                                icon: Icons.campaign_outlined,
                                title: "لا توجد عروض حالياً",
                                subtitle: "كل شيء هادئ هنا في الوقت الحالي",
                                onRetry: () => context
                                    .read<AdminOffersListCubit>()
                                    .getOffers(),
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
                                String formatDate(String? rawDate) {
                                  if (rawDate == null || rawDate.trim().isEmpty) {
                                    return 'غير محدد';
                                  }
                                  try {
                                    final parsedDate = DateTime.parse(rawDate);
                                    return "${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}";
                                  } catch (e) {
                                    // خطة بديلة في حال كان التنسيق مختلفاً
                                    return rawDate
                                        .split('T')
                                        .first
                                        .split(' ')
                                        .first;
                                  }
                                }

                                // 💡 2. تطبيق الدالة على تاريخي البداية والنهاية
                                final cleanFromDate = formatDate(offer.from);
                                final cleanToDate = formatDate(offer.to);
                                return Container(
                                  padding: EdgeInsets.all(16.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(16.r),
                                    border: Border.all(
                                      color: AppColors.formBorder.withValues(alpha: 0.6),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.06),
                                        blurRadius: 16.r,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 72.w,
                                        height: 72.w,
                                        decoration: BoxDecoration(
                                          color: AppColors.greyBackground,
                                          borderRadius: BorderRadius.circular(14.r),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(14.r),
                                          child: offer.fullImageUrl != null
                                              ? AppCachedNetworkImage(
                                                  imageUrl: offer.fullImageUrl!,
                                                  fit: BoxFit.cover,
                                                  errorWidget: Icon(
                                                    Icons.local_offer_rounded,
                                                    color: AppColors.primary,
                                                    size: 28.sp,
                                                  ),
                                                )
                                              : Icon(
                                                  Icons.local_offer_rounded,
                                                  color: AppColors.primary,
                                                  size: 28.sp,
                                                ),
                                        ),
                                      ),
                                      16.horizontalSpace,
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              offer.productName ?? "منتج العرض",
                                              style: AppTextStyle.font16.copyWith(
                                                color: AppColors.textMain,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            6.verticalSpace,
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 8.w,
                                                vertical: 2.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppColors.primary.withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(6.r),
                                              ),
                                              child: Text(
                                                "الخصم: ${offer.discountValue ?? ''}",
                                                style: AppTextStyle.font12.copyWith(
                                                  color: AppColors.primary,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            6.verticalSpace,
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.calendar_today_rounded,
                                                  size: 12.sp,
                                                  color: AppColors.greyMedium3,
                                                ),
                                                4.horizontalSpace,
                                                Expanded(
                                                  child: Text(
                                                    "من $cleanFromDate إلى $cleanToDate",
                                                    style: AppTextStyle.font12.copyWith(
                                                      color: AppColors.greyMedium3,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              context
                                                  .read<AdminOffersCubit>()
                                                  .initForEdit(offer);
                                              Navigator.pushNamed(
                                                context,
                                                Routes.createOffer,
                                              );
                                            },
                                            borderRadius: BorderRadius.circular(8.r),
                                            child: Container(
                                              padding: EdgeInsets.all(6.w),
                                              decoration: BoxDecoration(
                                                color: AppColors.greyBackground,
                                                borderRadius: BorderRadius.circular(8.r),
                                              ),
                                              child: Icon(
                                                Icons.edit_outlined,
                                                color: AppColors.primary,
                                                size: 18.sp,
                                              ),
                                            ),
                                          ),
                                          8.verticalSpace,
                                          InkWell(
                                            onTap: () {
                                              if (offer.id != null) {
                                                context
                                                    .read<AdminOffersListCubit>()
                                                    .deleteOffer(offer.id!);
                                              }
                                            },
                                            borderRadius: BorderRadius.circular(8.r),
                                            child: Container(
                                              padding: EdgeInsets.all(6.w),
                                              decoration: BoxDecoration(
                                                color: Colors.red.withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(8.r),
                                              ),
                                              child: Icon(
                                                Icons.delete_outline_rounded,
                                                color: Colors.red.shade700,
                                                size: 18.sp,
                                              ),
                                            ),
                                          ),
                                        ],
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
