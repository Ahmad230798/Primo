import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';
import 'package:primo/feature/categories/presentation/widgets/category_grid_card.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // مصفوفة بيانات وهمية مطابقة للصورة المرفقة
    final List<Map<String, String>> categories = [
      {"title": "المشروبات", "image": "assets/images/coffe.png"},
      {"title": "المقرمشات", "image": "assets/images/snacks.png"},
      {"title": "منظفات العناية", "image": "assets/images/coffe.png"},
      {"title": "المعلبات", "image": "assets/images/canns.png"},
      {"title": "المخبوزات", "image": "assets/images/coffe.png"},
      {"title": "الخضار والفواكه", "image": "assets/images/groceries.jpg"},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // --- 1. الـ AppBar مع إضافة أيقونة البحث ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: CustomAppBar(
                title: "تصفح أقسام Primo",
                showRightIcon: true,
                icon: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.searchResults);
                  },
                  child: Icon(
                    Icons.search,
                    color: AppColors.textMain,
                    size: 26.sp,
                  ),
                ),
              ),
            ),

            // --- 2. شبكة الأقسام (GridView) ---
            Expanded(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                itemCount: categories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // عدد الأعمدة (2)
                  crossAxisSpacing: 16.w, // المسافة الأفقية بين البطاقتين
                  mainAxisSpacing: 16.h, // المسافة العمودية بين الصفوف
                  childAspectRatio:
                      0.95, // نسبة الطول للعرض (شبه مربعة لتطابق الصورة)
                ),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return CategoryGridCard(
                    title: category["title"]!,
                    imagePath: category["image"]!,
                    onTap: () {
                      // ملاحظة: حالياً تأخذه لشاشة المنتجات، لاحقاً سنمرر الـ id
                      Navigator.pushNamed(context, Routes.productDetails);
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
