import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/network/app_storage.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  void _navigateToNext() async {
    // 💡 الانتظار لمدة ثانيتين للمصداقية البصرية وشعار العلامة التجارية
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final token = await AppStorage.getAccessToken();
    if (!mounted) return;
    if (token != null && token.isNotEmpty) {
      final role = AppStorage.getUserRole();
      if (role == 1) {
        Navigator.pushReplacementNamed(context, Routes.adminHome);
      } else {
        Navigator.pushReplacementNamed(context, Routes.userMainLayout);
      }
    } else {
      if (AppStorage.isFirstTime()) {
        Navigator.pushReplacementNamed(context, Routes.onboarding);
      } else {
        Navigator.pushReplacementNamed(context, Routes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBackGround,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeOutBack,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value.clamp(0.0, 1.0),
                    child: Transform.scale(
                      scale: 0.8 + (value * 0.2),
                      child: child,
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 28.w,
                        vertical: 16.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Text(
                        "Primo",
                        style: AppTextStyle.font32.copyWith(
                          color: AppColors.primary,
                          fontSize: 52.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    24.verticalSpace,
                    Text(
                      "سوبرماركت بريمو",
                      style: AppTextStyle.font20.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                      ),
                    ),
                    8.verticalSpace,
                    Text(
                      "خيارك الأول للتسوق السريع والآمن",
                      style: AppTextStyle.font14.copyWith(
                        color: AppColors.greyMedium3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 50.h,
              left: 0,
              right: 0,
              child: const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 2.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
