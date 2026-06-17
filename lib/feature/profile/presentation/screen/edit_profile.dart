import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';
import 'package:primo/core/widgets/profile_image_holder.dart';
import 'package:primo/feature/profile/presentation/widgets/edit_profile_form.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                CustomAppBar(title: "تعديل الحساب"),
                32.verticalSpace,
                ProfileImageHolder(
                  imagePath: "assets/images/profile_image.jpg",
                  width: 128.w,
                  hight: 128.h,
                  iconData: Icons.edit,
                ),
                32.verticalSpace,
                EditProfileForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
