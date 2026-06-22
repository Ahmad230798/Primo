import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/feature/cart/presentation/widgets/cart_item_card.dart';

class CartItemList extends StatelessWidget {
  const CartItemList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 3,

      itemBuilder: (context, index) {
        return Column(children: [CartItemCard(), 8.verticalSpace]);
      },
    );
  }
}
