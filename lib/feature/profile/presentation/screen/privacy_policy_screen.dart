import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
                title: "سياسة الخصوصية",
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
                      "1. مقدمة سياسة الخصوصية",
                      "مرحباً بك في تطبيق Primo. نحن نولي خصوصية بياناتك الشخصية أهمية قصوى ونلتزم بحمايتها وفقاً لأعلى معايير الأمان. توضح سياسة الخصوصية هذه كيفية جمع واستخدام وحماية البيانات التي تشاركها معنا عند استخدام تطبيقنا أو خدماتنا الإلكترونية.",
                    ),
                    16.verticalSpace,
                    _buildSection(
                      "2. البيانات التي نقوم بجمعها",
                      "نجمع البيانات الضرورية لتقديم تجربة تسوق سلسة وفعالة، ويشمل ذلك:\n- المعلومات الأساسية: الاسم الكامل، رقم الهاتف، والبريد الإلكتروني.\n- معلومات التوصيل: عناوين التوصيل، الإحداثيات الجغرافية، وملاحظات التوصيل.\n- بيانات الطلبات والتفاعل: سجل المشتريات، المفضلة، وسجل الإشعارات والعروض المطلوبة.",
                    ),
                    16.verticalSpace,
                    _buildSection(
                      "3. كيفية استخدام البيانات",
                      "تستخدم البيانات المجمعة للأغراض التالية فقط:\n- معالجة الطلبات وإيصال المنتجات إلى عنوانك بأسرع وقت.\n- تحسين جودة المنتجات والخدمات المقدمة في متجر Primo.\n- إرسال الإشعارات والعروض الترويجية أو التحديثات الهامة الخاصة بحسابك (يمكنك التحكم في الإشعارات من إعدادات حسابك).",
                    ),
                    16.verticalSpace,
                    _buildSection(
                      "4. حماية ومشاركة البيانات",
                      "نحن لا نقوم ببيع أو تأجير بياناتك الشخصية لأي طرف ثالث. تتم مشاركة بيانات التوصيل ورقم الهاتف فقط مع مندوبي التوصيل المعتمدين لدى Primo لضمان وصول الطلب بدقة وأمان.",
                    ),
                    16.verticalSpace,
                    _buildSection(
                      "5. حقوق المستخدم والتحكم في البيانات",
                      "يحق لك في أي وقت الوصول إلى بياناتك الشخصية المسجلة في تطبيق Primo وتعديلها أو تحديثها من خلال ملفك الشخصي. كما يمكنك التواصل مع فريق الدعم لطلب استفسارات إضافية حول خصوصية حسابك.",
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
