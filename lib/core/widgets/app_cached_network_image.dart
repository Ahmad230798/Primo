import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';

class AppCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? errorWidget;

  const AppCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    String fullUrl = imageUrl.trim();
    if (fullUrl.isEmpty) {
      return _buildError();
    }
    if (fullUrl.startsWith('/storage') || fullUrl.startsWith('storage')) {
      final path = fullUrl.startsWith('/') ? fullUrl : '/$fullUrl';
      fullUrl = 'https://api.primo-market.cloud$path';
    } else if (!fullUrl.startsWith('http://') && !fullUrl.startsWith('https://')) {
      final path = fullUrl.startsWith('/') ? fullUrl : '/$fullUrl';
      fullUrl = 'https://api.primo-market.cloud$path';
    }

    Widget img = CachedNetworkImage(
      imageUrl: fullUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder:
          (context, url) => Container(
            width: width,
            height: height,
            color: AppColors.greyBackground,
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            ),
          ),
      errorWidget: (context, url, error) => _buildError(),
    );

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: img);
    }
    return img;
  }

  Widget _buildError() {
    Widget err = Container(
      width: width,
      height: height,
      color: AppColors.greyBackground,
      child: errorWidget ??
          const Center(
            child: Icon(
              Icons.image_not_supported_outlined,
              color: AppColors.greyMedium3,
            ),
          ),
    );
    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: err);
    }
    return err;
  }
}
