import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:primo/core/di/service_locator.dart';
import 'package:primo/core/helper/snack_bar_helper.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';
import 'package:primo/feature/profile/presentation/cubit/help_center_cubit.dart';
import 'package:primo/feature/profile/presentation/cubit/help_center_state.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  Future<void> _launchInstagramUrl(BuildContext context, String url) async {
    const String placeholder = 'INSTAGRAM_URL_HERE';
    final String targetUrl = url.trim().isEmpty ? placeholder : url.trim();

    if (targetUrl == placeholder) {
      final Uri placeholderUri = Uri.parse(placeholder);
      try {
        if (await canLaunchUrl(placeholderUri)) {
          await launchUrl(placeholderUri, mode: LaunchMode.externalApplication);
        } else {
          if (context.mounted) {
            context.showSuccess('رابط إنستغرام: $placeholder');
          }
        }
      } catch (_) {
        if (context.mounted) {
          context.showSuccess('رابط إنستغرام: $placeholder');
        }
      }
      return;
    }

    final Uri? uri = Uri.tryParse(
      targetUrl.startsWith('http') ? targetUrl : 'https://$targetUrl',
    );
    if (uri != null) {
      try {
        final bool launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (!launched && context.mounted) {
          context.showError('تعذر فتح رابط إنستغرام');
        }
      } catch (_) {
        if (context.mounted) {
          context.showError('تعذر فتح رابط إنستغرام');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HelpCenterCubit(getIt())..getHelpCenterData(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: const CustomAppBar(
                  title: "من نحن - مركز المساعدة والدعم",
                  showRightIcon: false,
                ),
              ),
              Expanded(
                child: BlocBuilder<HelpCenterCubit, HelpCenterState>(
                  builder: (context, state) {
                    if (state is HelpCenterLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    }

                    final model = state is HelpCenterLoaded ? state.model : null;
                    final supportPhone = model?.supportPhone ?? '';
                    final managerPhone = model?.managerPhone ?? '';
                    final facebookAccount = model?.facebookAccount ?? '';
                    final instagramAccount = model?.instagramAccount ?? 'INSTAGRAM_URL_HERE';
                    final workingHours = model?.workingHours ?? '';
                    final address = model?.address ?? '';

                    return SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 24.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20.w),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "عن Primo ونحن هنا لمساعدتك!",
                                  style: AppTextStyle.font18.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                8.verticalSpace,
                                Text(
                                  "Primo هو متجرك المتكامل للتسوق الإلكتروني السريع والآمن. يمكنك التواصل مع فريق الدعم الفني أو متابعتنا على مواقع التواصل في أي وقت.",
                                  style: AppTextStyle.font14.copyWith(
                                    color: AppColors.white.withValues(
                                      alpha: 0.9,
                                    ),
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          24.verticalSpace,
                          Text(
                            "تابعنا وتواصل معنا",
                            style: AppTextStyle.font16.copyWith(
                              color: AppColors.textMain,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          16.verticalSpace,
                          _buildInstagramCard(
                            context: context,
                            instagramUrl: instagramAccount,
                          ),
                          12.verticalSpace,
                          _buildContactCard(
                            context: context,
                            icon: Icons.phone_in_talk_rounded,
                            title: "هاتف خدمة العملاء",
                            subtitle: supportPhone,
                            color: AppColors.primary,
                            isLtr: true,
                            isCopyable: true,
                          ),
                          12.verticalSpace,
                          _buildContactCard(
                            context: context,
                            icon: Icons.support_agent_rounded,
                            title: "هاتف الإدارة والمتابعة",
                            subtitle: managerPhone,
                            color: const Color(0xFFE65100),
                            isLtr: true,
                            isCopyable: true,
                          ),
                          12.verticalSpace,
                          _buildContactCard(
                            context: context,
                            icon: Icons.facebook,
                            title: "حساب فيسبوك",
                            subtitle: facebookAccount,
                            color: const Color(0xFF1877F2),
                            isLtr: true,
                            isCopyable: true,
                          ),
                          12.verticalSpace,
                          _buildContactCard(
                            context: context,
                            icon: Icons.access_time_filled_rounded,
                            title: "أوقات العمل الرسمي",
                            subtitle: workingHours,
                            color: const Color(0xFF2E7D32),
                          ),
                          12.verticalSpace,
                          _buildContactCard(
                            context: context,
                            icon: Icons.location_on_rounded,
                            title: "العنوان الرئيسي",
                            subtitle: address,
                            color: const Color(0xFF7B1FA2),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstagramCard({
    required BuildContext context,
    required String instagramUrl,
  }) {
    const String placeholder = 'INSTAGRAM_URL_HERE';
    final String displayUrl =
        instagramUrl.trim().isNotEmpty ? instagramUrl.trim() : placeholder;

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF833AB4),
            Color(0xFFFD1D1D),
            Color(0xFFF77737),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE1306C).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () => _launchInstagramUrl(context, displayUrl),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: FaIcon(
                    FontAwesomeIcons.instagram,
                    color: Colors.white,
                    size: 26.sp,
                  ),
                ),
                14.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "تابعنا على إنستغرام",
                        style: AppTextStyle.font14.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      4.verticalSpace,
                      Text(
                        displayUrl,
                        style: AppTextStyle.font12.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "زيارة",
                        style: AppTextStyle.font12.copyWith(
                          color: const Color(0xFFE1306C),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      4.horizontalSpace,
                      Icon(
                        Icons.open_in_new_rounded,
                        color: const Color(0xFFE1306C),
                        size: 14.sp,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // تم تحديث الدالة لاستقبال BuildContext وتفعيل ميزة النسخ
  Widget _buildContactCard({
    required BuildContext? context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    bool isLtr = false,
    bool isCopyable = false, // تمت إضافة المتغير هنا
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.formBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      // استخدام Material و InkWell لإعطاء تأثير بصري عند الضغط المطول
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onLongPress: isCopyable
              ? () async {
                  if (subtitle.isNotEmpty) {
                    // نسخ النص إلى الحافظة
                    await Clipboard.setData(ClipboardData(text: subtitle));

                    // التأكد من أن الشاشة لا تزال مفتوحة قبل عرض الإشعار
                    if (!context!.mounted) return;

                    // إظهار إشعار سفلي لتأكيد النسخ
                    context.showSuccess('تم نسخ $title بنجاح');
                  }
                }
              : null,
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(icon, color: color, size: 24.sp),
                ),
                14.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyle.font12.copyWith(
                          color: AppColors.greyDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      4.verticalSpace,
                      isLtr
                          ? Directionality(
                              textDirection: TextDirection.ltr,
                              child: SizedBox(
                                width: double.infinity,
                                child: Text(
                                  subtitle,
                                  textAlign: TextAlign.left,
                                  style: AppTextStyle.font14.copyWith(
                                    color: AppColors.textMain,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          : Text(
                              subtitle,
                              style: AppTextStyle.font14.copyWith(
                                color: AppColors.textMain,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
