// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/helper/navigation.dart';
import 'package:primo/core/helper/snack_bar_helper.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/app_button.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';
import 'package:primo/core/widgets/profile_image_holder.dart';
import 'package:primo/feature/profile/presentation/widgets/info_card.dart';
import 'package:primo/feature/addresses/presentation/bloc/adresses_cubit.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

class Profile extends StatelessWidget {
  final bool isFromBottomNav;
  const Profile({super.key, required this.isFromBottomNav});

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("حذف الحساب"),
        content: const Text(
          "هل أنت متأكد من رغبتك في حذف الحساب نهائياً؟ لا يمكن التراجع عن هذا الإجراء.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("إلغاء"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<ProfileCubit>().deleteAccount();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("حذف نهائياً"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is DeleteAccountSuccess) {
              context.showSuccess(state.message);
              context.pushNamedAndRemoveUntil(Routes.login);
            } else if (state is DeleteAccountError) {
              context.showError(state.message);
            } else if (state is ProfileError) {
              context.showError(state.message);
            } else if (state is LogoutSuccess) {
              context.showSuccess(state.message);
              context.pushNamedAndRemoveUntil(Routes.login);
            } else if (state is LogoutError) {
              context.showError(state.message);
            }
          },
          builder: (context, state) {
            final cubit = context.read<ProfileCubit>();
            final user = cubit.user;
            final isLoading =
                state is ProfileLoading || state is DeleteAccountLoading;

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomAppBar(
                      title: "Primo",
                      suffixsIcon: isFromBottomNav ? const SizedBox() : null,
                    ),
                    32.verticalSpace,
                    if (isLoading && user == null)
                      const Center(child: CircularProgressIndicator())
                    else ...[
                      ProfileImageHolder(
                        imagePath:
                            user?.fullAvatarUrl ??
                            user?.fullAvatarUrl ??
                            "assets/images/profile_image.jpg",
                        iconData: Icons.edit,
                        onTap: () => context.pushNamed(
                          Routes.editProfile,
                          arguments: cubit,
                        ),
                      ),
                      24.verticalSpace,
                      Text(
                        user?.name ?? "المستخدم",
                        style: AppTextStyle.font24.copyWith(
                          color: AppColors.textMain,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        user?.phone ?? "",
                        style: AppTextStyle.font16.copyWith(
                          color: AppColors.greyMedium2,
                        ),
                      ),
                    ],
                    24.verticalSpace,
                    InfoCard(
                      text: "تعديل الملف الشخصي",
                      iconData: Icons.person_outline,
                      onTap: () => context.pushNamed(
                        Routes.editProfile,
                        arguments: cubit,
                      ),
                    ),
                    8.verticalSpace,
                    InfoCard(
                      text: "عناويني المحفوظة",
                      iconData: Icons.location_on,
                      onTap: () {
                        AddressesCubit? addressesCubit;
                        try {
                          addressesCubit = context.read<AddressesCubit>();
                        } catch (_) {}
                        context.pushNamed(
                          Routes.addresses,
                          arguments: addressesCubit,
                        );
                      },
                    ),
                    8.verticalSpace,
                    InfoCard(
                      text: "سجل المشتريات",
                      iconData: Icons.receipt_long_outlined,
                      onTap: () => context.pushNamed(Routes.orderHistory),
                    ),
                    8.verticalSpace,
                    InfoCard(
                      text: "الإعدادات",
                      iconData: Icons.settings_outlined,
                      onTap: () =>
                          context.pushNamed(Routes.settings, arguments: cubit),
                    ),
                    8.verticalSpace,
                    InfoCard(
                      text: "إعدادات الإشعارات",
                      iconData: Icons.notifications_active_outlined,
                      onTap: () => context.pushNamed(Routes.notifications),
                    ),
                    8.verticalSpace,
                    InfoCard(
                      text: "مركز المساعدة والدعم",
                      iconData: Icons.support_agent_sharp,
                      onTap: () => context.pushNamed(Routes.helpCenter),
                    ),
                    32.verticalSpace,
                    AppButton(
                      isLoading: state is LogoutLoading,
                      text: "تسجيل الخروج",
                      icon: Icons.logout,

                      onPressed: () {
                        context.read<ProfileCubit>().logout();
                      },
                    ),
                    8.verticalSpace,
                    AppButton(
                      isLoading: state is DeleteAccountLoading,
                      text: "حذف الحساب نهائياً",

                      onPressed: () => _showDeleteAccountDialog(context),
                    ),
                    30.verticalSpace,
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
