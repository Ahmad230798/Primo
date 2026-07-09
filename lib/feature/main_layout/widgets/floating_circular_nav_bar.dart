import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/feature/main_layout/presentation/cubit/main_layout_cubit.dart';
import 'package:primo/feature/main_layout/presentation/cubit/main_layout_state.dart';
import 'package:primo/feature/main_layout/widgets/semi_circule_divider.dart';

class FloatingCircularNavBar extends StatefulWidget {
  const FloatingCircularNavBar({super.key});

  @override
  State<FloatingCircularNavBar> createState() => _FloatingCircularNavBarState();
}

class _FloatingCircularNavBarState extends State<FloatingCircularNavBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // نستخدم BlocConsumer للاستماع لأوامر الـ Cubit وتشغيل الأنميشن
    return BlocConsumer<MainLayoutCubit, MainLayoutState>(
      listenWhen: (previous, current) =>
          previous.isMenuOpen != current.isMenuOpen,
      listener: (context, state) {
        if (state.isMenuOpen) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              // خلفية مظلمة عند الفتح
              if (state.isMenuOpen)
                GestureDetector(
                  onTap: () => context.read<MainLayoutCubit>().closeMenu(),
                  child: AnimatedBuilder(
                    animation: _expandAnimation,
                    builder: (context, child) => Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black.withOpacity(
                        _expandAnimation.value * 0.7,
                      ),
                    ),
                  ),
                ),

              // القائمة الدائرية النصفية
              Positioned(
                bottom: 70.h, // ترتفع فوق الشريط بقليل
                child: _buildCircularMenu(context),
              ),

              // شريط التنقل السفلي
              _buildBottomBar(context, state.currentIndex),
            ],
          ),
        );
      },
    );
  }

  // داخل ملف floating_circular_nav_bar.dart
  Widget _buildCircularMenu(BuildContext context) {
    final double radius = 170.w;

    return AnimatedBuilder(
      animation: _expandAnimation,
      builder: (context, child) {
        if (_expandAnimation.value == 0) return const SizedBox.shrink();

        return SizedBox(
          height: radius,
          width: radius * 2,
          child: Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              // 1. الدائرة الخلفية الرمادية
              Transform.scale(
                scale: _expandAnimation.value,
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: radius * 2,
                  height: radius,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(radius),
                      topRight: Radius.circular(radius),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                ),
              ),

              // 2. 💡 رسم الخطوط الفاصلة التفاعلية
              CustomPaint(
                size: Size(radius * 2, radius),
                painter: SemiCircleDividerPainter(_expandAnimation.value),
              ),

              // 3. عناصر القائمة
              _buildMenuItem(
                context,
                icon: Icons.notifications,
                title: "الاشعارات",
                angle: math.pi * 0.95,
                radius: radius * 0.65,
                bgColor: Colors.blue.withValues(alpha: 0.15),
                iconColor: Colors.blue,
                onTap: () => context.read<MainLayoutCubit>().changeIndex(
                  5,
                ), // الانتقال إلى صفحة الإشعارات
              ),
              _buildMenuItem(
                context,
                icon: Icons.settings_suggest_outlined,
                title: "الاعدادات",
                angle: math.pi * 0.66,
                radius: radius * 0.60,
                bgColor: Colors.orange.withValues(alpha: 0.15),
                iconColor: Colors.orange,
                onTap: () => context.read<MainLayoutCubit>().changeIndex(
                  6,
                ), // الانتقال إلى صفحة الإعدادات
              ),
              _buildMenuItem(
                context,
                icon: Icons.favorite,
                title: "المفضلة",
                angle: math.pi * 0.36,
                radius: radius * 0.60,
                bgColor: Colors.purple.withValues(alpha: 0.15),
                iconColor: Colors.purple,
                onTap: () => context.read<MainLayoutCubit>().changeIndex(
                  7,
                ), // الانتقال إلى صفحة المفضلة
              ),
              _buildMenuItem(
                context,
                icon: Icons.autorenew,
                title: "الخدمات",
                angle: math.pi * 0.05,
                radius: radius * 0.65,
                bgColor: AppColors.primary.withValues(alpha: 0.15),
                iconColor: AppColors.primary,
              ),
            ],
          ),
        );
      },
    );
  }

  // 💡 تم تحديث الدالة لتستقبل الألوان وترسم خلفية دائرية للأيقونة
  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required double angle,
    required double radius,
    required Color bgColor,
    required Color iconColor,
    void Function()? onTap,
  }) {
    final double x = radius * math.cos(angle);
    final double y = -radius * math.sin(angle);

    return Transform.translate(
      offset: Offset(x * _expandAnimation.value, y * _expandAnimation.value),
      child: Opacity(
        opacity: _expandAnimation.value,
        child: InkWell(
          onTap: () {
            context.read<MainLayoutCubit>().closeMenu();
            onTap?.call();
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 💡 إضافة الحاوية الدائرية التي تحمل لون الخلفية للأيقونة
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 24.sp),
              ),
              6.verticalSpace,
              Text(
                title,
                style: AppTextStyle.font12.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain,
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, int currentIndex) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                currentIndex,
                0,
                Icons.person_outline,
                "حسابي",
              ),
              _buildNavItem(
                context,
                currentIndex,
                1,
                Icons.receipt_long,
                "طلباتي",
              ),
              SizedBox(width: 60.w), // مساحة للزر المركزي
              _buildNavItem(
                context,
                currentIndex,
                2,
                Icons.shopping_cart_outlined,
                "السلة",
                hasNotification: true,
              ),
              _buildNavItem(
                context,
                currentIndex,
                4,
                Icons.home_rounded,
                "الرئيسية",
              ),
            ],
          ),
          Positioned(
            bottom: 25.h,
            child: GestureDetector(
              onTap: () => context.read<MainLayoutCubit>().toggleMenu(),
              child: AnimatedBuilder(
                animation: _expandAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _expandAnimation.value * math.pi / 4,
                    child: Container(
                      width: 65.w,
                      height: 65.w,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        context.read<MainLayoutCubit>().state.isMenuOpen
                            ? Icons.add
                            : Icons.widgets_outlined,
                        color: Colors.white,
                        size: 32.sp,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int currentIndex,
    int index,
    IconData icon,
    String label, {
    bool hasNotification = false,
  }) {
    final isActive = currentIndex == index;
    return GestureDetector(
      onTap: () => context.read<MainLayoutCubit>().changeIndex(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                icon,
                color: isActive ? AppColors.primary : AppColors.greyMedium3,
                size: 26.sp,
              ),
              if (hasNotification && !isActive)
                Positioned(
                  top: -2,
                  right: -2,
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
          4.verticalSpace,
          Text(
            label,
            style: AppTextStyle.font12.copyWith(
              color: isActive ? AppColors.primary : AppColors.greyMedium3,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}
