// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/network/app_storage.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';
import 'package:primo/core/widgets/profile_image_holder.dart';
import 'package:primo/feature/profile/presentation/widgets/info_card.dart';
import 'package:primo/feature/addresses/presentation/bloc/adresses_cubit.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.login,
                (route) => false,
              );
            } else if (state is DeleteAccountError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is ProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
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
                    CustomAppBar(title: "Primo"),
                    32.verticalSpace,
                    if (isLoading && user == null)
                      const Center(child: CircularProgressIndicator())
                    else ...[
                      ProfileImageHolder(
                        imagePath:
                            user?.fullAvatarUrl ??
                            user?.avatar ??
                            "assets/images/profile_image.jpg",
                        iconData: Icons.edit,
                        onTap: () => Navigator.pushNamed(
                          context,
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
                      onTap: () => Navigator.pushNamed(
                        context,
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
                        Navigator.pushNamed(
                          context,
                          Routes.addresses,
                          arguments: addressesCubit,
                        );
                      },
                    ),
                    8.verticalSpace,
                    InfoCard(
                      text: "سجل المشتريات",
                      iconData: Icons.receipt_long_outlined,
                      onTap: () =>
                          Navigator.pushNamed(context, Routes.orderHistory),
                    ),
                    8.verticalSpace,
                    InfoCard(
                      text: "الإعدادات",
                      iconData: Icons.settings_outlined,
                      onTap: () => Navigator.pushNamed(
                        context,
                        Routes.settings,
                        arguments: cubit,
                      ),
                    ),
                    8.verticalSpace,
                    InfoCard(
                      text: "مركز المساعدة",
                      iconData: Icons.support_agent_sharp,
                      onTap: () {},
                    ),
                    32.verticalSpace,
                    InfoCard(
                      text: "تسجيل الخروج",
                      iconData: Icons.logout,
                      iconContainerColor: AppColors.quantityBackground,
                      textColor: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      borderColor: AppColors.quantityBackground,
                      onTap: () async {
                        await AppStorage.clearAllData();
                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            Routes.login,
                            (route) => false,
                          );
                        }
                      },
                    ),
                    8.verticalSpace,
                    InfoCard(
                      text: "حذف الحساب نهائياً",
                      iconData: Icons.delete_forever,
                      iconContainerColor: Colors.red.withOpacity(0.1),
                      textColor: Colors.red,
                      fontWeight: FontWeight.w700,
                      borderColor: Colors.red.withOpacity(0.3),
                      onTap: () => _showDeleteAccountDialog(context),
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
