import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/feature/home/presentation/widgets/category_chip.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CategoryChip(iconData: Icons.cookie, text: "تسالي"),
        CategoryChip(iconData: Icons.coffee_rounded, text: "مشروبات"),
        CategoryChip(
          icon: FaIcon(FontAwesomeIcons.jar, color: AppColors.greyMedium2),
          text: "معلبات",
        ),
        CategoryChip(
          iconData: Icons.cleaning_services_rounded,
          text: "مشروبات",
        ),
      ],
    );
  }
}
