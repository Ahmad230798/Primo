import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class SettingsToggleItem extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  const SettingsToggleItem({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<SettingsToggleItem> createState() => _SettingsToggleItemState();
}

class _SettingsToggleItemState extends State<SettingsToggleItem> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: widget.iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(widget.icon, color: widget.iconColor, size: 20.sp),
              ),
              12.horizontalSpace,
              Text(
                widget.title,
                style: AppTextStyle.font16.copyWith(
                  color: AppColors.textMain,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          // زر التبديل (Switch)
          Transform.scale(
            scale: 0.8, // تصغير الزر قليلاً ليتناسب مع التصميم
            child: CupertinoSwitch(
              value: _value,
              activeColor: AppColors.primary,
              trackColor: AppColors.formBorder,
              onChanged: (val) {
                setState(() => _value = val);
                widget.onChanged(val);
              },
            ),
          ),
        ],
      ),
    );
  }
}
