import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/custom_counter.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(1),
      direction: DismissDirection.startToEnd,
      background: Container(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        // محاذاة الأيقونة لتكون على اليمين أثناء السحب
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Icon(Icons.delete_outline, color: AppColors.white, size: 30.sp),
      ),

      // 4. الحدث الذي يقع بعد اكتمال السحب (هنا نرسل حدث الحذف للـ BLoC)
      onDismissed: (direction) {
        // TODO: استدعاء دالة الحذف من BLoC
        // مثلاً: context.read<CartBloc>().add(RemoveItemEvent(id));

        // رسالة تأكيد للمستخدم (اختياري)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("تم حذف المنتج من السلة")));
      },

      // 5. تأكيد الحذف (ميزة احترافية لإظهار نافذة تأكيد قبل الحذف النهائي)
      confirmDismiss: (direction) async {
        // إذا أرجعت true سيتم الحذف، وإذا أرجعت false سيعود العنصر لمكانه
        return true; // يمكنك تغييرها لإظهار Dialog تأكيد
      },
      child: Container(
        width: 1.sw,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 94.w,
              height: 94.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage("assets/images/oil.jpg"),
                ),
              ),
            ),
            17.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "زيت زيتون بكر ممتاز أرجنتيني",
                    style: AppTextStyle.font20.copyWith(
                      color: AppColors.textMain,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    "750 مل",
                    style: AppTextStyle.font14.copyWith(
                      color: AppColors.greyMedium2,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          "85.00 ل.س",
                          style: AppTextStyle.font20.copyWith(
                            color: AppColors.textMain,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 3,
                        child: CustomCounter(
                          horizontalPadding: 12.w,
                          verticalPadding: 12.h,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
