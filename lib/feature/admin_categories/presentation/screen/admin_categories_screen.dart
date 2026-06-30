import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/admin_drawer.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';

import '../widgets/category_card.dart';

class AdminCategoriesScreen extends StatelessWidget {
  const AdminCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const AdminDrawer(currentRoute: Routes.adminCategories),
      // الزر العائم (FAB) مخصص ليكون في اليمين السفلي
      floatingActionButtonLocation:
          FloatingActionButtonLocation.startFloat, // Start في الـ RTL تعني يمين
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.addCategory);
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
            // 1. شريط التنقل العلوي
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: CustomAppBar(
                title: "Primo",
                // 2. عكسنا الأيقونات (suffixsIcon تظهر على اليمين في الـ RTL)
                suffixsIcon: InkWell(
                  onTap: () {
                    // الانتقال لصفحة الإشعارات
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
                // (icon تظهر على اليسار)
                icon: Icon(
                  Icons.menu_rounded,
                  color: AppColors.textMain,
                  size: 28.sp,
                ),
                showRightIcon: true,
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    24.verticalSpace,

                    // 2. العناوين (النصوص)
                    Text(
                      "إدارة الأقسام",
                      style: AppTextStyle.font30.copyWith(
                        color: AppColors.textMain,
                      ),
                    ),
                    4.verticalSpace,
                    Text(
                      "تحكم في فئات المنتجات، التعديل والإضافة.",
                      style: AppTextStyle.font14.copyWith(
                        color: AppColors.greyMedium3,
                      ),
                    ),
                    32.verticalSpace,

                    // 3. شبكة الأقسام (Grid)
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _dummyCategories.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.w,
                        mainAxisSpacing: 16.h,
                        childAspectRatio:
                            0.75, // نسبة العرض للطول لضمان مساحة كافية للمحتوى
                      ),
                      itemBuilder: (context, index) {
                        final category = _dummyCategories[index];
                        return CategoryCard(
                          title: category['title']!,
                          imagePath: category['image']!,
                          onEdit: () {},
                          onDelete: () {},
                        );
                      },
                    ),
                    100.verticalSpace, // مساحة سفلية للـ FAB
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

// بيانات وهمية مؤقتة مطابقة للصور
final List<Map<String, String>> _dummyCategories = [
  {"title": "الوجبات\nالخفيفة", "image": "assets/images/snacks.png"},
  {"title": "المشروبات", "image": "assets/images/beverages.png"},
  {"title": "المعلبات", "image": "assets/images/canns.png"},
  {"title": "الخضار\nوالفواكه", "image": "assets/images/vegetables.png"},
];
