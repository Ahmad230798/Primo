import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/widgets/app_button.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';
import 'package:primo/feature/favorites/presentation/widgets/favorite_product_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // مصفوفة وهمية لتجربة الـ UI قبل ربطها بالـ API
    final List<Map<String, String>> favoriteItems = [
      {
        "title": "قهوة إثيوبية مختصة",
        "weight": "250 جرام",
        "price": "45 ر.س",
        "image": "assets/images/coffe.png",
      },
      {
        "title": "شوكولاتة داكنة 85%",
        "weight": "100 جرام",
        "price": "28 ر.س",
        "image": "assets/images/coffe.png",
      },
      {
        "title": "ماتشا احتفالية فاخرة",
        "weight": "50 جرام",
        "price": "120 ر.س",
        "image": "assets/images/coffe.png",
      },
      {
        "title": "كريمة البندق والكاكاو",
        "weight": "350 جرام",
        "price": "42 ر.س",
        "image": "assets/images/coffe.png",
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // 1. الـ AppBar
            const CustomAppBar(title: "المفضلة", showRightIcon: false),

            // 2. شبكة المنتجات (GridView)
            Expanded(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                itemCount: favoriteItems.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // عمودين
                  crossAxisSpacing: 16.w, // المسافة الأفقية
                  mainAxisSpacing: 16.h, // المسافة العمودية
                  childAspectRatio:
                      0.68, // نسبة الطول للعرض (تمنع طفح البكسلات)
                ),
                itemBuilder: (context, index) {
                  final item = favoriteItems[index];
                  return FavoriteProductCard(
                    title: item["title"]!,
                    weight: item["weight"]!,
                    price: item["price"]!,
                    imagePath: item["image"]!,
                    onFavoriteTap: () {
                      // TODO: استدعاء دالة الحذف من المفضلة عبر الـ Cubit
                    },
                    onAddTap: () {
                      // TODO: إضافة هذا المنتج المحدد فقط إلى السلة
                    },
                  );
                },
              ),
            ),

            // 3. زر الإضافة للكل الثابت في الأسفل
            Container(
              padding: EdgeInsets.only(
                left: 24.w,
                right: 24.w,
                bottom: 24.h,
                top: 16.h,
              ),
              decoration: const BoxDecoration(color: AppColors.background),
              child: AppButton(
                text: "إضافة الكل إلى السلة",
                icon: Icons.add_shopping_cart,
                onPressed: () {
                  // TODO: إضافة القائمة كاملة للسلة
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
