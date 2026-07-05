import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:primo/feature/cart/data/models/cart_item_model.dart';
import 'package:primo/feature/cart/presentation/widgets/cart_item_card.dart';

class CartItemList extends StatelessWidget {
  final List<CartItemModel> items;

  const CartItemList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            CartItemCard(item: items[index]),
            8.verticalSpace,
          ],
        );
      },
    );
  }
}
