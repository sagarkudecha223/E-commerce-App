import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../model/order_model.dart';

@lazySingleton
class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _uid => _auth.currentUser!.uid;

  CollectionReference<Map<String, dynamic>> get _ordersRef =>
      _firestore.collection('users').doc(_uid).collection('orders');

  Future<void> placeOrder(OrderModel order) async {
    final doc = _ordersRef.doc();

    final orderWithId = order.copyWith(id: doc.id);

    await doc.set(orderWithId.toMap());

    final cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(_uid)
        .collection('cart');

    final snapshot = await cartRef.get();

    WriteBatch batch = FirebaseFirestore.instance.batch();

    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  Future<void> deleteOrder(String orderId) async {
    final orderRef = _ordersRef.doc(orderId);
    await orderRef.delete();
  }

  Stream<List<OrderModel>> ordersStream() => _ordersRef
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map(
        (snapshot) =>
            snapshot.docs.map((doc) => OrderModel.fromMap(doc.data())).toList(),
      );

  Future<List<OrderModel>> fetchOrders() async {
    final snapshot =
        await _ordersRef.orderBy('createdAt', descending: true).get();
    return snapshot.docs.map((doc) => OrderModel.fromMap(doc.data())).toList();
  }
}
