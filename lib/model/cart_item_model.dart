import 'item_model.dart';

class CartItemModel {
  final ItemModel item;
  int quantity;

  CartItemModel({required this.item, this.quantity = 1});

  num get totalPrice => item.price * quantity;
}
