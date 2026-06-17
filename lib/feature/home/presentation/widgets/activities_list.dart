import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/feature/home/presentation/widgets/activity_card.dart';

class ActivitiesList extends StatelessWidget {
  const ActivitiesList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ActivityCard(image: "assets/images/SpecialOffer.png"),
          ActivityCard(image: "assets/images/SpecialOffer.png"),
          ActivityCard(image: "assets/images/SpecialOffer.png"),
        ],
      ),
    );
  }
}
