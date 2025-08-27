import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import '../../core/enum.dart';
import '../../model/item_model.dart';

@singleton
class FirebaseItemService {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final StreamController<List<ItemModel>> _itemsController =
      StreamController<List<ItemModel>>.broadcast();

  List<ItemModel> _allItems = [];

  String get _uid => _auth.currentUser!.uid;

  /// Initialize stream listener
  Future<void> init() async {
    _fireStore.collection('items').snapshots().listen((snapshot) async {
      _allItems =
          snapshot.docs
              .map((doc) => ItemModel.fromMap(doc.id, doc.data()))
              .toList();

      // 🔹 ensure user has collections
      final favSnap = await _ensureCollectionExists('favorites');
      final cartSnap = await _ensureCollectionExists('cart');

      final favoriteIds = favSnap.docs.map((doc) => doc.id).toSet();
      final cartIds = cartSnap.docs.map((doc) => doc.id).toSet();

      // 🔹 merge flags into items
      final itemsWithFlags =
          _allItems.map((item) {
            return item.copyWith(
              isFavorite: favoriteIds.contains(item.id),
              isInCart: cartIds.contains(item.id),
            );
          }).toList();

      _itemsController.add(itemsWithFlags);
    });
  }

  /// Ensure subcollection exists, return snapshot
  Future<QuerySnapshot<Map<String, dynamic>>> _ensureCollectionExists(
    String collectionName,
  ) async {
    final colRef = _fireStore
        .collection('users')
        .doc(_uid)
        .collection(collectionName);

    final snap = await colRef.get();
    if (snap.docs.isEmpty) {
      // create placeholder doc then delete
      final temp = await colRef.add({"init": true});
      await temp.delete();
      return await colRef.get();
    }
    return snap;
  }

  /// Add to favorites
  Future<void> addToFavorites(String itemId) async {
    await _fireStore
        .collection('users')
        .doc(_uid)
        .collection('favorites')
        .doc(itemId)
        .set({"addedAt": DateTime.now().toIso8601String()});
  }

  /// Remove from favorites
  Future<void> removeFromFavorites(String itemId) async {
    await _fireStore
        .collection('users')
        .doc(_uid)
        .collection('favorites')
        .doc(itemId)
        .delete();
  }

  /// Add to cart
  Future<void> addToCart(String itemId, {int quantity = 1}) async {
    await _fireStore
        .collection('users')
        .doc(_uid)
        .collection('cart')
        .doc(itemId)
        .set({
          "quantity": quantity,
          "addedAt": DateTime.now().toIso8601String(),
        }, SetOptions(merge: true));
  }

  /// Remove from cart
  Future<void> removeFromCart(String itemId) async {
    await _fireStore
        .collection('users')
        .doc(_uid)
        .collection('cart')
        .doc(itemId)
        .delete();
  }

  /// Update quantity in cart
  Future<void> updateCartQuantity(String itemId, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(itemId);
    } else {
      await _fireStore
          .collection('users')
          .doc(_uid)
          .collection('cart')
          .doc(itemId)
          .set({"quantity": quantity}, SetOptions(merge: true));
    }
  }

  Stream<List<ItemModel>> get itemsStream => _itemsController.stream;

  Stream<List<ItemModel>> itemsByCategory(FoodMenuOptions category) =>
      itemsStream.map(
        (list) => list.where((i) => i.categoryId == category.name).toList(),
      );

  void dispose() => _itemsController.close();
}
