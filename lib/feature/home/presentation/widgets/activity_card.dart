import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/models/offer_model.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/app_cached_network_image.dart';

class ActivityCard extends StatelessWidget {
  final String image;
  final OfferModel? offer;
  const ActivityCard({super.key, required this.image, this.offer});

  @override
  Widget build(BuildContext context) {
    final imgUrl = offer?.fullImageUrl ?? image;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Material(
        color: AppColors.greyBackground,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if (offer != null) {
              Navigator.pushNamed(
                context,
                Routes.productDetails,
                arguments: offer,
              );
            }
          },
          child: SizedBox(
            width: double.infinity,
            height: 180.h,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (imgUrl.isNotEmpty)
                  AppCachedNetworkImage(imageUrl: imgUrl, fit: BoxFit.cover),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.textMain.withValues(alpha: 0),
                        AppColors.textMain.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 5.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                "عروض الأسبوع",
                                style: AppTextStyle.font12.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                            8.verticalSpace,
                            if (offer?.discountValue != null || offer != null)
                              Text(
                                offer?.discountValue != null
                                    ? "خصم ${offer!.discountValue}"
                                    : "عرض خاص",
                                style: AppTextStyle.font24.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            2.verticalSpace,
                            if (offer?.productName != null)
                              Text(
                                offer!.productName!,
                                style: AppTextStyle.font16.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
