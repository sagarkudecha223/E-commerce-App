import 'package:flutter/material.dart';
import 'food_menu/food_menu_view.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [FoodMenuView(viewOnly: true)],
    );
  }
}
