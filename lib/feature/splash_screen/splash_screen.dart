import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBackGround,
      body: SafeArea(
        child: Center(
          child: Stack(
            children: [
              Positioned(
                top: 0.36.sh,
                left: -0.16.sw,
                child: Container(
                  width: 1.sw,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.09),
                        AppColors.primary.withOpacity(0.05),
                        AppColors.primary.withOpacity(0.01),
                      ],
                      center: AlignmentGeometry.center,

                      radius: 0.5,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Primo",
                    style: AppTextStyle.font32.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  20.verticalSpace,
                  Text(
                    "سوبرماركت بريمو - خيارك الأول",
                    style: AppTextStyle.font20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
