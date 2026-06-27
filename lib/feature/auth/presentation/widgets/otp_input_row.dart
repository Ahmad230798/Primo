import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/utils/apptextstyle/app_text_style.dart';

class OtpInputRow extends StatefulWidget {
  const OtpInputRow({super.key});

  @override
  State<OtpInputRow> createState() => _OtpInputRowState();
}

class _OtpInputRowState extends State<OtpInputRow> {
  // إنشاء 4 متحكمات وعُقد تركيز (FocusNodes)
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty) {
      // إذا تم إدخال رقم، انتقل للحقل التالي
      if (index < 3) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // إذا كان الحقل الأخير، أخفِ لوحة المفاتيح
        _focusNodes[index].unfocus();
      }
    } else {
      // إذا تم حذف الرقم، ارجع للحقل السابق
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // استخدمنا Directionality LTR لضمان ترتيب الحقول من اليسار لليمين (1-2-3-4)
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(4, (index) {
          return SizedBox(
            width: 64.w,
            height: 64.w,
            child: TextFormField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1, // رقم واحد فقط في كل حقل
              style: AppTextStyle.font32.copyWith(
                color: AppColors.textMain,
                fontWeight: FontWeight.bold,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // السماح بالأرقام فقط
              ],
              decoration: InputDecoration(
                counterText: "", // إخفاء عداد الحروف (0/1)
                filled: true,
                fillColor: AppColors.white,
                contentPadding: EdgeInsets.zero,

                // الحدود في الحالة العادية
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: const BorderSide(
                    color: AppColors.formBorder,
                    width: 1,
                  ),
                ),
                // الحدود عند التركيز (Focus) باللون الأحمر كما في التصميم
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
              onChanged: (value) => _onChanged(value, index),
            ),
          );
        }),
      ),
    );
  }
}
