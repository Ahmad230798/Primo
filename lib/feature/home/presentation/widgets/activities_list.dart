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
          return SizedBox(
            height: 180.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.data.offers.length,
              itemBuilder: (context, index) {
                final offer = state.data.offers[index];
                return ActivityCard(
                  image: offer.fullImageUrl ?? "",
                  offer: offer,
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
