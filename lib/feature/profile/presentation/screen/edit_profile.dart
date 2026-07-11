import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';
import 'package:primo/core/widgets/profile_image_holder.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/edit_profile_form.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is UpdateProfileSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            } else if (state is UpdateProfileError) {
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
            final imagePath =
                cubit.selectedAvatar?.path ??
                cubit.user?.fullAvatarUrl ??
                cubit.user?.fullAvatarUrl ??
                "assets/images/profile_image.jpg";
            debugPrint("DEBUG_IMAGE_PATH: $imagePath");
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    CustomAppBar(
                      title: "تعديل الحساب",
                      onBackTap: () => Navigator.pop(context),
                    ),
                    32.verticalSpace,
                    ProfileImageHolder(
                      imagePath: imagePath,
                      width: 128.w,
                      hight: 128.h,
                      iconData: Icons.edit,
                      onTap: () => cubit.pickAvatar(),
                    ),
                    32.verticalSpace,
                    const EditProfileForm(),
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
