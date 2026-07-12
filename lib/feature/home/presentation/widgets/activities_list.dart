import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/feature/home/presentation/cubit/home_cubit.dart';
import 'package:primo/feature/home/presentation/cubit/home_state.dart';
import 'package:primo/feature/home/presentation/widgets/activity_card.dart';

class ActivitiesList extends StatelessWidget {
  const ActivitiesList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoaded && state.data.offers.isNotEmpty) {
          final offers = state.data.offers;
          return CarouselSlider(
            options: CarouselOptions(
              height: 180.h,
              autoPlay: offers.length > 1,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 700),
              autoPlayCurve: Curves.easeInOut,
              enlargeCenterPage: true,
              enableInfiniteScroll: offers.length > 1,
              viewportFraction: 0.85,
            ),
            items: offers.map((offer) {
              return ActivityCard(
                image: offer.fullImageUrl ?? "",
                offer: offer,
              );
            }).toList(),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
