import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/helper/navigation.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';
import 'package:primo/core/widgets/app_button.dart';
import 'package:primo/core/widgets/app_text_form_field.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

class EditProfileForm extends StatefulWidget {
  const EditProfileForm({super.key});

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final user = context.read<ProfileCubit>().user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoaded) {
          if (_nameController.text.isEmpty && state.user.name != null) {
            _nameController.text = state.user.name!;
          }
          if (_phoneController.text.isEmpty && state.user.phone != null) {
            _phoneController.text = state.user.phone!;
          }
        }
      },
      builder: (context, state) {
        final isLoading = state is UpdateProfileLoading;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          width: 1.sw,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(width: 1, color: AppColors.formBorder),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "المعلومات الشخصية",
                  style: AppTextStyle.font20.copyWith(
                    letterSpacing: 0,
                    color: AppColors.textMain,
                  ),
                ),
                16.verticalSpace,
                Text(
                  "الاسم الكامل",
                  style: AppTextStyle.font14.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.greyMedium2,
                  ),
                ),
                8.verticalSpace,
                AppTextFormField(
                  hinttText: "أحمد المحمد",
                  controller: _nameController,
                  validator: (val) => val == null || val.trim().isEmpty
                      ? "الرجاء إدخال الاسم"
                      : null,
                  focusColor: AppColors.formBorder,
                  isFilled: true,
                  fillColor: AppColors.background,
                ),
                16.verticalSpace,
                Text(
                  "رقم الهاتف",
                  style: AppTextStyle.font14.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.greyMedium2,
                  ),
                ),
                8.verticalSpace,
                AppTextFormField(
                  hinttText: "09xxxxxxxx",
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  textDirection: TextDirection.ltr,
                  readOnly: true,
                  enabled: false,
                  focusColor: AppColors.formBorder,
                  isFilled: true,
                  fillColor: AppColors.quantityBackground,
                ),
                32.verticalSpace,
                AppButton(
                  text: "حفظ التغييرات",
                  isLoading: isLoading,
                  onPressed: isLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            context.read<ProfileCubit>().updateProfile(
                                  name: _nameController.text.trim(),
                                  phone: _phoneController.text.trim(),
                                );
                          }
                        },
                ),
                24.verticalSpace,
                Center(
                  child: Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      text: "هل تود تغيير كلمة المرور؟ ",
                      style: AppTextStyle.font14.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.greyMedium3,
                      ),
                      children: [
                        TextSpan(
                          text: "اضغط هنا",
                          style: AppTextStyle.font14.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.greyMedium3,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.pushNamed(Routes.changePassword, arguments: context.read<ProfileCubit>());
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
