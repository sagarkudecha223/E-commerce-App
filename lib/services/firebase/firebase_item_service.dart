import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import '../../model/item_model.dart';

@singleton
class FirebaseItemService {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final StreamController<List<ItemModel>> _itemsController =
      StreamController<List<ItemModel>>.broadcast();
  final StreamController<List<ItemModel>> _favoritesController =
      StreamController<List<ItemModel>>.broadcast();
  final StreamController<List<ItemModel>> _cartController =
      StreamController<List<ItemModel>>.broadcast();

  List<ItemModel> _allItems = [];
  List<ItemModel> _cartItems = [];
  List<ItemModel> _favoriteItems = [];

  StreamSubscription? _itemSub;
  StreamSubscription? _favSub;
  StreamSubscription? _cartSub;

  String get _uid => _auth.currentUser!.uid;

  Future<void> init() async {
    _itemSub = _fireStore.collection('items').snapshots().listen((snapshot) {
      _allItems =
          snapshot.docs
              .map((doc) => ItemModel.fromMap(doc.id, doc.data()))
              .toList();
      _combineData();
    });

    _favSub = _fireStore
        .collection('users')
        .doc(_uid)
        .collection('favorites')
        .snapshots()
        .listen((snapshot) {
          _favoriteItems =
              snapshot.docs
                  .map((doc) => ItemModel.fromMap(doc.id, doc.data()))
                  .toList();
          _combineData();
        });

    _cartSub = _fireStore
        .collection('users')
        .doc(_uid)
        .collection('cart')
        .snapshots()
        .listen((snapshot) {
          _cartItems =
              snapshot.docs
                  .map((doc) => ItemModel.fromMap(doc.id, doc.data()))
                  .toList();
          _combineData();
        });
  }

  /// Streams
  Stream<List<ItemModel>> get itemsStream => _itemsController.stream;

  Stream<List<ItemModel>> get favoritesStream => _favoritesController.stream;

  Stream<List<ItemModel>> get cartStream => _cartController.stream;

  /// Getters
  List<ItemModel> get allItemsList => List.unmodifiable(_allItems);

  List<ItemModel> get cartList => List.unmodifiable(_cartItems);

  List<ItemModel> get favoriteList => List.unmodifiable(_favoriteItems);

  /// Merge data and push
  void _combineData() {
    final updated =
        _allItems.map((item) {
          final isFavorite = _favoriteItems.any((f) => f.id == item.id);
          final isInCart = _cartItems.any((c) => c.id == item.id);

          return item.copyWith(isFavorite: isFavorite, isInCart: isInCart);
        }).toList();

    _allItems = updated;
    _itemsController.add(updated);
    _favoritesController.add(updated.where((item) => item.isFavorite).toList());
    _cartController.add(updated.where((item) => item.isInCart).toList());
  }

  /// Toggle favorite
  Future<void> toggleFavorite(ItemModel item) async {
    final ref = _fireStore
        .collection('users')
        .doc(_uid)
        .collection('favorites')
        .doc(item.id);

    final exists = _favoriteItems.any((f) => f.id == item.id);

    if (exists) {
      await ref.delete();
    } else {
      await ref.set({
        ...item.toMap(),
        "isFavorite": true,
        "addedAt": FieldValue.serverTimestamp(),
      });
    }
  }

  /// Toggle cart
  Future<void> toggleCart(ItemModel item) async {
    final ref = _fireStore
        .collection('users')
        .doc(_uid)
        .collection('cart')
        .doc(item.id);

    final exists = _cartItems.any((c) => c.id == item.id);

    if (exists) {
      await ref.delete();
    } else {
      await ref.set({
        ...item.toMap(),
        "isInCart": true,
        "addedAt": FieldValue.serverTimestamp(),
      });
    }
  }

  void dispose() {
    _itemsController.close();
    _favoritesController.close();
    _cartController.close();
    _itemSub?.cancel();
    _favSub?.cancel();
    _cartSub?.cancel();
  }
}
