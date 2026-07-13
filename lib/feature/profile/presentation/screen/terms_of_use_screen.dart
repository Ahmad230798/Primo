import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: CustomAppBar(
                title: "شروط الاستخدام",
                showRightIcon: false,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection(
                      "1. القبول بشروط الخدمة",
                      "إن استخدامك لتطبيق متجر Primo يعني موافقتك الكاملة على جميع الشروط والأحكام الموضحة أدناه. إذا كنت لا توافق على أي من هذه الشروط، يرجى التوقف عن استخدام التطبيق.",
                    ),
                    16.verticalSpace,
                    _buildSection(
                      "2. إنشاء الحساب ومسؤولية المستخدم",
                      "يلتزم المستخدم بتقديم بيانات صحيحة ودقيقة عند التسجيل (الاسم ورقم الهاتف والعناوين). يتحمل المستخدم المسؤولية الكاملة عن الحفاظ على سرية حسابه وبيانات الدخول الخاصة به.",
                    ),
                    16.verticalSpace,
                    _buildSection(
                      "3. الأسعار والعروض والمنتجات",
                      "يبذل متجر Primo أقصى جهد لضمان دقة أسعار وتوفر المنتجات والعروض الترويجية. نحتفظ بالحق في تعديل الأسعار أو تحديث كميات المخزون أو إلغاء الطلبات في حال وجود خطأ تقني أو عدم توفر المنتج في المخزون، مع إبلاغ العميل فوراً.",
                    ),
                    16.verticalSpace,
                    _buildSection(
                      "4. سياسة التوصيل والاستلام",
                      "يتم توصيل الطلبات إلى العنوان المحدد من قبل العميل ضمن الأوقات المتاحة. يرجى التأكد من تواجد شخص لاستلام الطلب والرد على اتصال مندوب التوصيل لضمان جودة وسرعة الخدمة.",
                    ),
                    16.verticalSpace,
                    _buildSection(
                      "5. سياسة الاسترجاع والاستبدال",
                      "يحق للعميل فحص المنتجات عند الاستلام. في حال وجود أي تلف أو خطأ في المنتج المستلم، يرجى التواصل مع مركز المساعدة والدعم في Primo فوراً لترتيب الاستبدال أو المعالجة وفقاً لسياسة المتجر.",
                    ),
                    32.verticalSpace,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String body) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.formBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyle.font16.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          12.verticalSpace,
          Text(
            body,
            style: AppTextStyle.font14.copyWith(
              color: AppColors.textMain,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}
