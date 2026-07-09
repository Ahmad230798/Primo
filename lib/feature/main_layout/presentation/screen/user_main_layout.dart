// // ignore_for_file: deprecated_member_use

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
// import 'package:primo/core/di/service_locator.dart';
// import 'package:primo/core/utils/appcolor/app_colors.dart';
// import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
// import 'package:primo/feature/cart/presentation/cubit/cart_cubit.dart';
// import 'package:primo/feature/cart/presentation/screens/cart.dart';
// import 'package:primo/feature/categories/presentation/screen/all_categories_screen.dart';

// // استدعاء شاشة الـ Home القديمة الخاصة بك
// import 'package:primo/feature/home/presentation/screen/home.dart';
// import 'package:primo/feature/orders/presentation/bloc/orders_cubit.dart';
// import 'package:primo/feature/orders/presentation/screens/order_history_screen.dart';
// import 'package:primo/feature/profile/presentation/screen/profile.dart';

// class UserMainLayout extends StatefulWidget {
//   const UserMainLayout({super.key});

//   @override
//   State<UserMainLayout> createState() => _UserMainLayoutState();
// }

// class _UserMainLayoutState extends State<UserMainLayout> {
//   // 1. جعلنا القيمة الافتراضية 4 لتبدأ الشاشة بـ "الرئيسية" الموجودة على اليسار
//   int _currentIndex = 4;

//   // قائمة الشاشات التي سيتم التنقل بينها
//   final List<Widget> _screens = [
//     BlocProvider(
//       create: (context) => getIt<OrdersCubit>()..getOrders(),
//       child: const Profile(isFromBottomNav: true),
//     ), // Index 0 (حسابي)
//     BlocProvider(
//       create: (context) => getIt<OrdersCubit>()..getOrders(),
//       child: const OrderHistoryScreen(isFromBottomNav: true),
//     ), // Index 1 (الطلبات)
//     BlocProvider(
//       create: (_) => getIt<CartCubit>()..getCart(),
//       child: const Cart(isFromBottomNav: true),
//     ), // Index 2 (السلة)
//     const AllCategoriesScreen(isFromBottomNav: true), // Index 3 (الأقسام)
//     const Home(), // Index 4 (الرئيسية)
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: AppColors.background,
//         extendBody: true, // مهمة جداً لجعل الشريط يطفو فوق المحتوى
//         body: IndexedStack(index: _currentIndex, children: _screens),
//         bottomNavigationBar: _buildFloatingBottomNavBar(),
//       ),
//     );
//   }

//   Widget _buildFloatingBottomNavBar() {
//     return Container(
//       margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 24.h),
//       padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(99.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.12),
//             blurRadius: 20,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Row(
//         // 2. استخدام spaceAround يعطي كل زر مساحته المريحة بدون ضغط أو Overflow
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           // ترتيب الأزرار لكي تظهر "حسابي" يميناً و"الرئيسية" يساراً
//           _buildNavItem(
//             index: 0,
//             icon: Icons.person_outline_rounded,
//             label: "حسابي",
//           ),
//           _buildNavItem(
//             index: 1,
//             icon: Icons.receipt_long_outlined,
//             label: "طلباتي",
//           ),
//           _buildNavItem(
//             index: 2,
//             icon: Icons.shopping_cart_outlined,
//             label: "السلة",
//             hasNotification: true,
//           ),
//           _buildNavItem(
//             index: 3,
//             icon: Icons.category_outlined,
//             label: "الأقسام",
//           ),
//           _buildNavItem(index: 4, icon: Icons.home_rounded, label: "الرئيسية"),
//         ],
//       ),
//     );
//   }

//   Widget _buildNavItem({
//     required int index,
//     required IconData icon,
//     required String label,
//     bool hasNotification = false,
//   }) {
//     final isActive = _currentIndex == index;

//     return GestureDetector(
//       onTap: () => setState(() => _currentIndex = index),
//       behavior: HitTestBehavior.opaque,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 250),
//         curve: Curves.easeOut,
//         // 3. مسافات داخلية مريحة تمنع قص الحروف العربية التي تنزل عن السطر
//         padding: EdgeInsets.symmetric(
//           horizontal: isActive ? 16.w : 8.w,
//           vertical: isActive ? 10.h : 6.h,
//         ),
//         decoration: BoxDecoration(
//           color: isActive ? AppColors.primary : Colors.transparent,
//           borderRadius: BorderRadius.circular(99.r),
//           boxShadow: isActive
//               ? [
//                   BoxShadow(
//                     color: AppColors.primary.withOpacity(0.3),
//                     blurRadius: 12,
//                     offset: const Offset(0, 4),
//                   ),
//                 ]
//               : null,
//         ),
//         transform: isActive
//             ? Matrix4.translationValues(0, -4, 0)
//             : Matrix4.identity(),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Stack(
//               clipBehavior: Clip.none,
//               children: [
//                 Icon(
//                   icon,
//                   color: isActive ? AppColors.white : AppColors.greyMedium3,
//                   size: 24.sp,
//                 ),
//                 if (hasNotification && !isActive)
//                   Positioned(
//                     top: -2,
//                     right: -2,
//                     child: Container(
//                       width: 10.w,
//                       height: 10.w,
//                       decoration: BoxDecoration(
//                         color: AppColors.primary,
//                         shape: BoxShape.circle,
//                         border: Border.all(color: AppColors.white, width: 2),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//             6.verticalSpace,
//             // 4. إزالة الـ Overflow وزيادة وضوح الخط (Bold)
//             Text(
//               label,
//               style: AppTextStyle.font12.copyWith(
//                 color: isActive ? AppColors.white : AppColors.greyMedium3,
//                 fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
//                 fontSize: 11.sp, // حجم خط مثالي
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }0
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/di/service_locator.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/feature/cart/presentation/cubit/cart_cubit.dart';
import 'package:primo/feature/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:primo/feature/favorites/presentation/screens/favorites_screen.dart';
import 'package:primo/feature/main_layout/widgets/floating_circular_nav_bar.dart';
import 'package:primo/feature/notifications/presentation/cubit/notification_settings_cubit.dart';
import 'package:primo/feature/notifications/presentation/screen/notification_settings_screen.dart';
import 'package:primo/feature/orders/presentation/bloc/orders_cubit.dart';
import 'package:primo/feature/profile/presentation/cubit/profile_cubit.dart';

// استيراد الشاشات
import 'package:primo/feature/profile/presentation/screen/profile.dart';
import 'package:primo/feature/orders/presentation/screens/order_history_screen.dart';
import 'package:primo/feature/cart/presentation/screens/cart.dart';
import 'package:primo/feature/categories/presentation/screen/all_categories_screen.dart';
import 'package:primo/feature/home/presentation/screen/home.dart';
import 'package:primo/feature/profile/presentation/screen/settings_screen.dart';

// استيراد الكيوبت والويدجت المعزول
import '../cubit/main_layout_cubit.dart';
import '../cubit/main_layout_state.dart';

class UserMainLayout extends StatelessWidget {
  UserMainLayout({super.key});

  final List<Widget> _screens = [
    BlocProvider(
      create: (context) => getIt<OrdersCubit>()..getOrders(),
      child: const Profile(isFromBottomNav: true),
    ), // Index 0 (حسابي)
    BlocProvider(
      create: (context) => getIt<OrdersCubit>()..getOrders(),
      child: const OrderHistoryScreen(isFromBottomNav: true),
    ), // Index 1 (الطلبات)
    BlocProvider(
      create: (_) => getIt<CartCubit>()..getCart(),
      child: const Cart(isFromBottomNav: true),
    ), // Index 2 (السلة)
    const AllCategoriesScreen(isFromBottomNav: true), // Index 3 (الأقسام)
    const Home(), // Index 4 (الرئيسية)
    BlocProvider(
      create: (context) => getIt<NotificationSettingsCubit>(),
      child: const NotificationSettingsScreen(), // Index 5 (الإشعارات)
    ),
    BlocProvider(
      create: (context) => getIt<ProfileCubit>(),
      child: const SettingsScreen(isFromBottomNav: true),
    ), // Index 6 (الإعدادات)
    BlocProvider(
      create: (context) => getIt<FavoritesCubit>(),
      child: const FavoritesPage(isFromBottomNav: true),
    ), // Index 6 (الإعدادات)


  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        extendBody: true,
        body: Stack(
          children: [
            // 1. محتوى الشاشات
            BlocBuilder<MainLayoutCubit, MainLayoutState>(
              buildWhen: (previous, current) =>
                  previous.currentIndex != current.currentIndex,
              builder: (context, state) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 85.h),
                  child: IndexedStack(
                    index: state.currentIndex,
                    children: _screens,
                  ),
                );
              },
            ),

            // 2. شريط التنقل والقائمة المنبثقة (ويدجت معزول بالكامل)
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: FloatingCircularNavBar(),
            ),
          ],
        ),
      ),
    );
  }
}
