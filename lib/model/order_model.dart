import 'cart_item_model.dart';

class Order {
  final String id;
  final String userId;
  final List<CartItemModel> items;
  final double totalAmount;
  final String status;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
  });

  factory Order.fromMap(
    String id,
    Map<String, dynamic> data,
    List<CartItemModel> items,
  ) {
    return Order(
      id: id,
      userId: data['userId'],
      items: items,
      totalAmount: (data['totalAmount'] as num).toDouble(),
      status: data['status'],
      createdAt: (data['createdAt'] as DateTime),
    );
  }
}
