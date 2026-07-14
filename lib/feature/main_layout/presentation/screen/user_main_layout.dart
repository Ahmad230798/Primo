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
import 'package:primo/feature/suggestions/presentation/cubit/suggestions_cubit.dart';
import 'package:primo/feature/suggestions/presentation/screens/suggest_product_page.dart';

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
      child: const NotificationSettingsScreen(
        isFromBottomNav: true,
      ), // Index 5 (الإشعارات)
    ),
    BlocProvider(
      create: (context) => getIt<ProfileCubit>(),
      child: const SettingsScreen(isFromBottomNav: true),
    ), // Index 6 (الإعدادات)
    BlocProvider(
      create: (context) => getIt<FavoritesCubit>(),
      child: const FavoritesPage(isFromBottomNav: true),
    ), // Index 7 (المفضلة)
    BlocProvider(
      create: (context) => getIt<SuggestionsCubit>(),
      child: const SuggestProductPage(isFromBottomNav: true),
    ), // Index 7 (المفضلة)
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
                  child: FadeIndexedStack(
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

class FadeIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget> children;
  final Duration duration;

  const FadeIndexedStack({
    super.key,
    required this.index,
    required this.children,
    this.duration = const Duration(milliseconds: 300), // مدة التلاشي
  });

  @override
  State<FadeIndexedStack> createState() => _FadeIndexedStackState();
}

class _FadeIndexedStackState extends State<FadeIndexedStack>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _controller.forward();
  }

  @override
  void didUpdateWidget(FadeIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    // إذا تغير التبويب، نُعيد تشغيل الأنميشن من الصفر ليظهر التلاشي
    if (widget.index != oldWidget.index) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: IndexedStack(index: widget.index, children: widget.children),
    );
  }
}
