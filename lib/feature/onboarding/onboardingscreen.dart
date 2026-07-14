import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/app_button.dart';
// تأكد من استيراد مسار الـ Navigation الصحيح لديك
// import 'package:primo/core/helper/navigation.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  // بيانات الشاشات الترحيبية
  final List<Map<String, String>> _onboardingData = [
    {
      "image": "assets/images/onboarding1.png", // تأكد من مسار الصورة الأولى
      "title": "أهلاً بك في Primo",
      "body":
          "آلاف المنتجات بين يديك.. تصفح الأقسام\nبكل سهولة واختر ما تحتاجه.",
    },
    {
      "image": "assets/images/onboarding2.png", // تأكد من مسار الصورة الثانية
      "title": "توصيل سريع لباب بيتك",
      "body":
          "حدد موقعك بدقة، وسنقوم بتوصيل طلبات\nPrimo بأسرع وقت وأفضل حالة.",
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentIndex == _onboardingData.length - 1;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // --- 1. الهيدر (زر التخطي وشعار Primo) ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // شعار Primo (يظهر في الشاشة الأولى فقط كما في التصميم)
                  _currentIndex == 0
                      ? Text(
                          "Primo",
                          style: AppTextStyle.font20.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.sp,
                          ),
                        )
                      : const SizedBox.shrink(),

                  // زر تخطي
                  InkWell(
                    onTap: () {
                      // الانتقال المباشر لشاشة تسجيل الدخول
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        Routes.login,
                        (route) => false,
                      );
                    },
                    borderRadius: BorderRadius.circular(8.r),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      child: Text(
                        "تخطي",
                        style: AppTextStyle.font16.copyWith(
                          color: AppColors.greyMedium3,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- 2. محتوى الـ PageView (الصور والنصوص) ---
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                reverse: true,
                physics: const BouncingScrollPhysics(),
                itemCount: _onboardingData.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // الصورة (مع إمكانية إضافة ClipRRect إذا كانت تحتاج حواف دائرية)
                        Image.asset(
                          _onboardingData[index]["image"]!,
                          height: 280.h,
                          fit: BoxFit.contain,
                        ),
                        40.verticalSpace,

                        // العنوان
                        Text(
                          _onboardingData[index]["title"]!,
                          textAlign: TextAlign.center,
                          style: AppTextStyle.font20.copyWith(
                            fontSize: 26.sp,
                            color:
                                AppColors.textMain, // أو الأسود حسب الـ Theme
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        16.verticalSpace,

                        // الوصف
                        Text(
                          _onboardingData[index]["body"]!,
                          textAlign: TextAlign.center,
                          style: AppTextStyle.font16.copyWith(
                            color: AppColors.greyMedium3, // لون رمادي أنيق
                            height: 1.5, // لتباعد الأسطر كما في التصميم
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // --- 3. قسم المؤشر (Dots) والأزرار ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
              child: Column(
                children: [
                  // المؤشر التفاعلي (Indicator)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onboardingData.length,
                      (index) => _buildDot(_onboardingData.length - 1 - index),
                    ),
                  ),
                  32.verticalSpace,

                  // الزر الرئيسي
                  AppButton(
                    text: isLastPage ? "ابدأ التسوق الآن" : "التالي",
                    isIconExist: false, // تفعيل الأيقونة في الصفحة الأخيرة
                    // 💡 ملاحظة: إذا كان زرك يدعم تمرير الأيقونة أضفها هنا مثل:
                    // icon: Icons.shopping_cart_rounded,
                    onPressed: () {
                      if (isLastPage) {
                        // الذهاب لصفحة تسجيل الدخول (أو الرئيسية)
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          Routes.login,
                          (route) => false,
                        );
                      } else {
                        // الانتقال للصفحة التالية بأنيميشن ناعم
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ودجت مساعد لبناء نقاط المؤشر الديناميكية
  Widget _buildDot(int index) {
    bool isActive = _currentIndex == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      height: 8.h,
      // النقطة النشطة تكون عريضة (Pill Shape) والغير نشطة دائرية
      width: isActive ? 28.w : 8.w,
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primary
            : AppColors.greyMedium3.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(99.r),
      ),
    );
  }
}
