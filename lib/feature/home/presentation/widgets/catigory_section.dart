import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/feature/home/presentation/widgets/catigory_chip.dart';

class CatigorySection extends StatelessWidget {
  const CatigorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CatigoryChip(iconData: Icons.cookie, text: "تسالي"),
        CatigoryChip(iconData: Icons.coffee_rounded, text: "مشروبات"),
        CatigoryChip(
          icon: FaIcon(FontAwesomeIcons.jar, color: AppColors.greyMedium2),
          text: "معلبات",
        ),
        CatigoryChip(
          iconData: Icons.cleaning_services_rounded,
          text: "مشروبات",
        ),
      ],
    );
  }
}
