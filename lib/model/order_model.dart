import 'address_model.dart';
import 'item_model.dart';

class OrderModel {
  final String id;
  final List<ItemModel> items;
  final num totalPrice;
  final String status; // pending, confirmed, delivered, etc.
  final DateTime createdAt;
  final Address address;

  OrderModel({
    required this.id,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'items': items.map((e) => e.toOrderMap()).toList(),
      'totalPrice': totalPrice,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'address': address.toJson(),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> data) {
    return OrderModel(
      id: data['id'] ?? '',
      items:
          (data['items'] as List<dynamic>)
              .map((e) => ItemModel.fromOrderMap(e))
              .toList(),
      totalPrice: (data['totalPrice'] ?? 0) as num,
      status: data['status'] ?? 'pending',
      createdAt: DateTime.tryParse(data['createdAt'] ?? '') ?? DateTime.now(),
      address: Address.fromJson(
         '',
        data['address'] ?? {},
      ),
    );
  }

  OrderModel copyWith({
    String? id,
    List<ItemModel>? items,
    num? totalPrice,
    String? status,
    DateTime? createdAt,
    Address? address,
  }) {
    return OrderModel(
      id: id ?? this.id,
      items: items ?? this.items,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      address: address ?? this.address,
    );
  }
}
