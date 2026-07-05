// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/password_input_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // 1. شريط التنقل العلوي
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: CustomAppBar(
                title: "تغيير كلمة المرور",
                suffixsIcon: Icon(
                  Icons.arrow_back,
                  color: AppColors.primary,
                  size: 26.sp,
                ),
                showRightIcon: false,
                onBackTap: () => Navigator.pop(context),
              ),
            ),

            // 2. محتوى الصفحة
            Expanded(
              child: BlocConsumer<ProfileCubit, ProfileState>(
                listener: (context, state) {
                  if (state is ChangePasswordSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context);
                  } else if (state is ChangePasswordError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  final isLoading = state is ChangePasswordLoading;

                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          32.verticalSpace,

                          // الأيقونة والنص التوضيحي
                          Container(
                            width: 64.w,
                            height: 64.w,
                            decoration: const BoxDecoration(
                              color: AppColors.greyBackground,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.lock_outline_rounded,
                              color: AppColors.greyDark,
                              size: 32.sp,
                            ),
                          ),
                          16.verticalSpace,
                          Text(
                            "يرجى إدخال كلمة المرور الحالية لتتمكن من تعيين\nكلمة مرور جديدة.",
                            style: AppTextStyle.font14.copyWith(
                              color: AppColors.greyMedium3,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          32.verticalSpace,

                          // حقول الإدخال
                          PasswordInputField(
                            label: "كلمة المرور الحالية",
                            controller: _currentPasswordController,
                            validator: (val) => val == null || val.isEmpty
                                ? "الرجاء إدخال كلمة المرور الحالية"
                                : null,
                          ),
                          20.verticalSpace,
                          PasswordInputField(
                            label: "كلمة المرور الجديدة",
                            controller: _newPasswordController,
                            validator: (val) => val == null || val.length < 6
                                ? "يجب أن تكون كلمة المرور 6 أحرف على الأقل"
                                : null,
                          ),
                          20.verticalSpace,
                          PasswordInputField(
                            label: "تأكيد كلمة المرور الجديدة",
                            controller: _confirmPasswordController,
                            validator: (val) {
                              if (val != _newPasswordController.text) {
                                return "كلمة المرور غير متطابقة";
                              }
                              return null;
                            },
                          ),

                          40.verticalSpace,

                          // زر التحديث
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        context.read<ProfileCubit>().changePassword(
                                              currentPassword:
                                                  _currentPasswordController.text,
                                              newPassword:
                                                  _newPasswordController.text,
                                              newPasswordConfirmation:
                                                  _confirmPasswordController.text,
                                            );
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                elevation: 0,
                                minimumSize: Size(double.infinity, 56.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                              ),
                              child: isLoading
                                  ? SizedBox(
                                      width: 24.w,
                                      height: 24.w,
                                      child: const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      "تحديث كلمة المرور",
                                      style: AppTextStyle.font18.copyWith(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),

                          40.verticalSpace,
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
