import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/widgets/admin_drawer.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';

import '../widgets/suggestion_item_card.dart';
import '../widgets/suggestions_filter_tabs.dart';

class AdminSuggestionsScreen extends StatelessWidget {
  const AdminSuggestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      drawer: const AdminDrawer(currentRoute: Routes.adminSuggestions),

      body: SafeArea(
        child: Column(
          children: [
            // 1. شريط التنقل العلوي
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: CustomAppBar(
                title: "مقترحات الزبائن",
                // أيقونة الإشعارات على اليمين مع النقطة الحمراء (RTL)
                suffixsIcon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      Icons.notifications_none_rounded,
                      color: AppColors.textMain,
                      size: 26.sp,
                    ),
                    Positioned(
                      top: 2.h,
                      right: 2.w,
                      child: Container(
                        width: 10.w,
                        height: 10.w,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                // أيقونة القائمة (Menu) على اليسار
                icon: Icon(
                  Icons.menu_rounded,
                  color: AppColors.textMain,
                  size: 26.sp,
                ),
                showRightIcon: true,
              ),
            ),

            // 2. محتوى الصفحة
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.verticalSpace,

                    // شريط التبويبات (الجديدة، قيد المراجعة، تم التوفير)
                    const SuggestionsFilterTabs(),
                    24.verticalSpace,

                    // قائمة المقترحات
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          SuggestionItemCard(
                            customerName: "أحمد محمد",
                            customerType: "زبون مميز",
                            avatarLetter: "أم",
                            date: "12 أكتوبر",
                            suggestionTitle: "حليب خالي من اللاكتوز 1 لتر",
                            suggestionText:
                                '"نحتاجه بشكل دائم في المتجر، أرجو توفيره في أقرب وقت لعدم توفره في الفروع الأخرى."',
                            onAccept: () {},
                            onIgnore: () {},
                          ),
                          24.verticalSpace,
                          SuggestionItemCard(
                            customerName: "سارة محمود",
                            customerType: "زبون جديد",
                            avatarLetter: "سم",
                            date: "11 أكتوبر",
                            suggestionTitle: "قهوة عضوية محمصة",
                            suggestionText:
                                '"أتمنى إضافة أنواع أكثر من القهوة العضوية للماركات المحلية."',
                            onAccept: () {},
                            onIgnore: () {},
                          ),
                        ],
                      ),
                    ),
                    40.verticalSpace, // مساحة سفلية
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
