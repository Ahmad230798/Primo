import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/admin_drawer.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';

import '../widgets/inventory_product_card.dart';
import '../widgets/search_and_filter_widget.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const AdminDrawer(currentRoute: Routes.adminInventory),

      // زر الإضافة العائم (FAB) -> يذهب لصفحة إضافة منتج
      floatingActionButton: SizedBox(
        height: 56.h,
        child: FloatingActionButton.extended(
          onPressed: () {
            // إضافة منتج جديد
            Navigator.pushNamed(context, Routes.addProducts);
          },
          backgroundColor: AppColors.primary,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          icon: Icon(Icons.add, color: AppColors.white, size: 24.sp),
          label: Text(
            "إضافة منتج جديد",
            style: AppTextStyle.font14.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: CustomAppBar(
                title: "Primo",
                // أيقونة الإشعارات (تظهر يميناً)
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
                // أيقونة فتح القائمة الجانبية
                icon: Builder(
                  builder: (ctx) => InkWell(
                    onTap: () => Scaffold.of(ctx).openDrawer(),
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Icon(
                        Icons.menu_rounded,
                        color: AppColors.textMain,
                        size: 28.sp,
                      ),
                    ),
                  ),
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
                    16.verticalSpace,
                    Text(
                      "إدارة المخزون",
                      style: AppTextStyle.font30.copyWith(
                        color: AppColors.textMain,
                      ),
                    ),
                    4.verticalSpace,
                    Text(
                      "تحكم في توافر المنتجات وتحديث الكميات",
                      style: AppTextStyle.font14.copyWith(
                        color: AppColors.greyMedium3,
                      ),
                    ),
                    24.verticalSpace,
                    const SearchAndFilterWidget(),
                    24.verticalSpace,

                    // قائمة المنتجات
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _dummyProducts.length,
                      separatorBuilder: (context, index) => 16.verticalSpace,
                      itemBuilder: (context, index) {
                        final product = _dummyProducts[index];
                        return InkWell(
                          onTap: () {
                            // الذهاب لصفحة تعديل المنتج
                            Navigator.pushNamed(context, Routes.editProduct);
                          },
                          child: InventoryProductCard(
                            category: product['category'],
                            name: product['name'],
                            sku: product['sku'],
                            price: product['price'],
                            quantity: product['quantity'],
                            isAvailable: product['isAvailable'],
                            imagePath: product['imagePath'],
                          ),
                        );
                      },
                    ),
                    100.verticalSpace,
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

// بيانات وهمية مؤقتة مطابقة للتصميم للاختبار
final List<Map<String, dynamic>> _dummyProducts = [
  {
    'category': 'الزيوت والبهارات',
    'name': 'زيت زيتون بكر ممتاز - عصرة أولى',
    'sku': 'SKU: PR-10042',
    'price': '145',
    'quantity': 42,
    'isAvailable': true,
    'imagePath': 'assets/images/olive_oil.png', // استبدلها بصورتك
  },
  {
    'category': 'عسل ومربى',
    'name': 'عسل سدر طبيعي فاخر 500 جرام',
    'sku': 'SKU: PR-10089',
    'price': '280',
    'quantity': 0,
    'isAvailable': false,
    'imagePath': 'assets/images/honey.png', // استبدلها بصورتك
  },
  {
    'category': 'مشروبات',
    'name': 'قهوة عربية مختصة محمصة بالهيل',
    'sku': 'SKU: PR-10112',
    'price': '85',
    'quantity': 18,
    'isAvailable': true,
    'imagePath': 'assets/images/coffee.png', // استبدلها بصورتك
  },
  {
    'category': 'الزيوت والبهارات',
    'name': 'زعفران سوبر نقيل درجة أولى 5 جرام',
    'sku': 'SKU: PR-10023',
    'price': '120',
    'quantity': 0,
    'isAvailable': false,
    'imagePath': 'assets/images/saffron.png', // استبدلها بصورتك
  },
];
