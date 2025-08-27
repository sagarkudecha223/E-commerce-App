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

  factory ItemModel.fromMap(String id, Map<String, dynamic> data) => ItemModel(
    id: id,
    name: data['name'],
    categoryId: data['categoryId'],
    price: data['price'] ?? 0,
    description: data['description'] ?? '',
    imageUrl: data['imageUrl'] ?? '',
    isVegan: data['isVegan'] ?? true,
    available: data['available'] ?? true,
  );

  Map<String, dynamic> toMap() => {
    'name': name,
    'categoryId': categoryId,
    'price': price,
    'description': description,
    'imageUrl': imageUrl,
    'isVegan': isVegan,
    'available': available,
  };

  ItemModel copyWith({bool? isFavorite, bool? isInCart, int? cartQuantity}) {
    return ItemModel(
      id: id,
      name: name,
      imageUrl: imageUrl,
      price: price,
      categoryId: categoryId,
      description: description,
      isFavorite: isFavorite ?? this.isFavorite,
      isInCart: isInCart ?? this.isInCart,
      cartQuantity: cartQuantity ?? this.cartQuantity,
    );
  }
}
