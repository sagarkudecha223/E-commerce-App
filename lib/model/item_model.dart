class ItemModel {
  final String id;
  final String name;
  final String categoryId;
  final num price;
  final String description;
  final String imageUrl;
  final bool isVegan;
  final bool available;
  final bool isFavorite;
  final bool isInCart;
  final int cartQuantity;

  ItemModel({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.price,
    required this.description,
    required this.imageUrl,
    this.isVegan = true,
    this.available = true,
    this.isFavorite = false,
    this.isInCart = false,
    this.cartQuantity = 0,
  });

  /// Factory from Firestore document
  factory ItemModel.fromMap(String id, Map<String, dynamic> data) {
    return ItemModel(
      id: id,
      name: data['name'] ?? '',
      categoryId: data['categoryId'] ?? '',
      price: (data['price'] ?? 0) as num,
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      isVegan: data['isVegan'] ?? true,
      available: data['available'] ?? true,
      isFavorite: data['isFavorite'] ?? false,
      isInCart: data['isInCart'] ?? false,
      cartQuantity: data['cartQuantity'] ?? 0,
    );
  }

  /// For saving to Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'categoryId': categoryId,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'isVegan': isVegan,
      'available': available,
      'isInCart': isInCart,
      'isFavorite': isFavorite,
      'cartQuantity': cartQuantity,
    };
  }

  /// Copy helper
  ItemModel copyWith({
    bool? isFavorite,
    bool? isInCart,
    int? cartQuantity,
  }) {
    return ItemModel(
      id: id,
      name: name,
      categoryId: categoryId,
      price: price,
      description: description,
      imageUrl: imageUrl,
      isVegan: isVegan,
      available: available,
      isFavorite: isFavorite ?? this.isFavorite,
      isInCart: isInCart ?? this.isInCart,
      cartQuantity: cartQuantity ?? this.cartQuantity,
    );
  }

  /// Convert for order storage (exclude favorite/cart flags if not needed)
  Map<String, dynamic> toOrderMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': cartQuantity,
      'imageUrl': imageUrl,
      'categoryId': categoryId,
    };
  }

  factory ItemModel.fromOrderMap(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'],
      name: json['name'],
      categoryId: json['categoryId'] ?? '',
      price: json['price'],
      description: '',
      imageUrl: json['imageUrl'] ?? '',
      cartQuantity: json['quantity'] ?? 0,
      isInCart: true,
    );
  }
}
