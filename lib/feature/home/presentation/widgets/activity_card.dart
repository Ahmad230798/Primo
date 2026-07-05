import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/models/offer_model.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class ActivityCard extends StatelessWidget {
  final String image;
  final OfferModel? offer;
  const ActivityCard({super.key, required this.image, this.offer});

  @override
  Widget build(BuildContext context) {
    final imgUrl = offer?.fullImageUrl ?? image;
    final isNetwork = imgUrl.startsWith('http://') || imgUrl.startsWith('https://');

    return Padding(
      padding: EdgeInsets.only(left: 16.w),
      child: Container(
        width: 0.8.sw,
        height: 180.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.greyBackground,
          image: imgUrl.isNotEmpty
              ? DecorationImage(
                  image: isNetwork
                      ? NetworkImage(imgUrl) as ImageProvider
                      : AssetImage(imgUrl),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
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
                        offer?.discountValue != null ? "خصم ${offer!.discountValue}%" : "عرض خاص",
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
      ),
    );
  }
}
