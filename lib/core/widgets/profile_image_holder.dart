import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
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
    final double containerWidth = width ?? 96.w;
    final double containerHeight = hight ?? 96.h;

    return Stack(
      children: [
        Container(
          width: containerWidth,
          height: containerHeight,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              strokeAlign: BorderSide.strokeAlignInside,
              color: AppColors.primary,
              width: 4.w,
              style: BorderStyle.solid,
            ),
          ),
          child: ClipOval(
            child: _buildImageWidget(context, containerWidth, containerHeight),
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

  Widget _buildImageWidget(BuildContext context, double w, double h) {
    if (imagePath.trim().isEmpty) {
      return _buildFallbackIcon(w);
    }

    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        width: w,
        height: h,
        errorBuilder: (context, error, stackTrace) => _buildFallbackIcon(w),
      );
    }

    // التحقق أولاً ممّا إذا كان الملف موجوداً فعلياً على ذاكرة الهاتف المحلية (مثل التقاط صورة من المعرض)
    final file = File(imagePath);
    if (file.existsSync()) {
      return Image.file(
        file,
        fit: BoxFit.cover,
        width: w,
        height: h,
        errorBuilder: (context, error, stackTrace) => _buildFallbackIcon(w),
      );
    }

    // في حال لم يكن ملفاً محلياً، نتعامل معه كرابط شبكة (سواء كان رابطاً كاملاً أو نسبياً من السيرفر)
    String networkUrl = imagePath;
    if (!networkUrl.startsWith('http://') &&
        !networkUrl.startsWith('https://')) {
      const baseUrl = 'https://api.primo-market.cloud';
      if (networkUrl.startsWith('/')) {
        networkUrl = '$baseUrl$networkUrl';
      } else {
        networkUrl = '$baseUrl/$networkUrl';
      }
    }

    return CachedNetworkImage(
      imageUrl: networkUrl,
      cacheKey: networkUrl + DateTime.now().toString(),
      fit: BoxFit.cover,
      width: w,
      height: h,
      placeholder: (context, url) => Center(
        child: SizedBox(
          width: 24.w,
          height: 24.h,
          child: const CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      errorWidget: (context, url, error) => _buildFallbackIcon(w),
    );
  }

  Widget _buildFallbackIcon(double size) {
    return Container(
      color: AppColors.greyLight,
      child: Icon(Icons.person, size: size * 0.5, color: AppColors.greyMedium3),
    );
  }
}
