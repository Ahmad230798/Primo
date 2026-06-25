import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo/core/utils/appcolor/app_colors.dart';
import 'package:primo/core/widgets/app_button.dart';
import 'package:primo/core/widgets/custom_app_bar.dart';
import 'package:primo/feature/addresses/presentation/bloc/addresses_cubit.dart';
import 'package:primo/feature/addresses/presentation/bloc/adresses_state.dart';
import 'package:primo/feature/addresses/presentation/widgets/address_card.dart';

class SavedAddressesScreen extends StatelessWidget {
  const SavedAddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(title: "العناوين", showRightIcon: false),

            // --- تغليف القائمة بـ BlocBuilder لكي تتحدث تلقائياً ---
            Expanded(
              child: BlocBuilder<AddressesCubit, AddressesState>(
                builder: (context, state) {
                  // إذا كانت الحالة هي تحميل البيانات
                  if (state is AddressesLoaded) {
                    final savedAddresses = state.addresses;

                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 20.h,
                      ),
                      itemCount: savedAddresses.length,
                      itemBuilder: (context, index) {
                        final address = savedAddresses[index];
                        return AddressCard(
                          title: address["title"],
                          details: address["details"],
                          icon: address["icon"],
                          isDefault: address["isDefault"],
                          onTap: () {
                            // المنطق السحري: استدعاء الدالة وتمرير الـ ID
                            context.read<AddressesCubit>().setDefaultAddress(
                              address["id"],
                            );
                          },
                          onEditTap: () {
                            // TODO: الانتقال لصفحة تعديل العنوان
                          },
                          onDeleteTap: () {
                            // TODO: استدعاء دالة الحذف
                          },
                        );
                      },
                    );
                  }

                  // حالة مبدئية فارغة أو مؤشر تحميل
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),

            Container(
              padding: EdgeInsets.only(
                left: 24.w,
                right: 24.w,
                bottom: 24.h,
                top: 16.h,
              ),
              color: AppColors.background,
              child: AppButton(
                text: "إضافة عنوان جديد",
                icon: Icons.add,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
