import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';
import 'package:primo/feature/profile/data/models/help_center_model.dart';

class HelpCenterScreen extends StatelessWidget {
  final HelpCenterModel model;

  const HelpCenterScreen({
    super.key,
    this.model = HelpCenterModel.dummy,
  });

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
                title: "مركز المساعدة والدعم",
                showRightIcon: false,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
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
                            "نحن هنا لمساعدتك!",
                            style: AppTextStyle.font18.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          8.verticalSpace,
                          Text(
                            "يمكنك التواصل مع فريق الدعم الفني أو إدارة متجر Primo في أي وقت للاستفسار أو تقديم الشكاوى.",
                            style: AppTextStyle.font14.copyWith(
                              color: AppColors.white.withValues(alpha: 0.9),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    24.verticalSpace,
                    Text(
                      "قنوات التواصل",
                      style: AppTextStyle.font16.copyWith(
                        color: AppColors.textMain,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    16.verticalSpace,
                    _buildContactCard(
                      icon: Icons.phone_in_talk_rounded,
                      title: "هاتف خدمة العملاء",
                      subtitle: model.supportPhone,
                      color: AppColors.primary,
                    ),
                    12.verticalSpace,
                    _buildContactCard(
                      icon: Icons.support_agent_rounded,
                      title: "هاتف الإدارة والمتابعة",
                      subtitle: model.managerPhone,
                      color: const Color(0xFFE65100),
                    ),
                    12.verticalSpace,
                    _buildContactCard(
                      icon: Icons.email_rounded,
                      title: "البريد الإلكتروني للدعم",
                      subtitle: model.supportEmail,
                      color: const Color(0xFF1E88E5),
                    ),
                    12.verticalSpace,
                    _buildContactCard(
                      icon: Icons.access_time_filled_rounded,
                      title: "أوقات العمل الرسمي",
                      subtitle: model.workingHours,
                      color: const Color(0xFF2E7D32),
                    ),
                    12.verticalSpace,
                    _buildContactCard(
                      icon: Icons.location_on_rounded,
                      title: "العنوان الرئيسي",
                      subtitle: model.address,
                      color: AppColors.greyDark,
                    ),
                    40.verticalSpace,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
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
                Text(
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
    );
  }
}
