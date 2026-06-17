// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';

class ProfileImageHolder extends StatelessWidget {
  final String imagePath;
  final IconData? iconData;
  final Widget? icon;
  final Function()? onTap;
  final double? width;
  final double? hight;

  const ProfileImageHolder({
    super.key,
    required this.imagePath,
    this.icon,
    this.onTap,
    this.iconData,
    this.width,
    this.hight,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: width ?? 96.w,
          height: hight ?? 96.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              strokeAlign: BorderSide.strokeAlignInside,
              color: AppColors.primary,
              width: 4.w,
              style: BorderStyle.solid,
            ),
            image: DecorationImage(image: _getImageProvider(imagePath)),
          ),
        ),
        icon ??
            Positioned(
              bottom: 1,
              right: 2,
              child: CircleAvatar(
                backgroundColor: AppColors.primary,
                child: InkWell(
                  onTap: onTap,
                  child: Icon(iconData, color: Colors.white),
                ),
              ),
            ),
      ],
    );
  }
}

ImageProvider _getImageProvider(String path) {
  if (path.startsWith('http')) {
    return NetworkImage(path); // صورة من السيرفر
  } else if (path.startsWith('assets/')) {
    return AssetImage(path); // صورة افتراضية من ملفات التطبيق
  } else {
    return FileImage(File(path)); // صورة من استوديو الهاتف (image_picker)
  }
}
