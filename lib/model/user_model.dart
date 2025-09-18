import 'address_model.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String profilePhotoUrl;
  final List<String> favoriteItems;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.profilePhotoUrl = '',
    this.favoriteItems = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profilePhotoUrl': profilePhotoUrl,
      'favoriteItems': favoriteItems,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profilePhotoUrl: json['profilePhotoUrl'] ?? '',
      favoriteItems: List<String>.from(json['favoriteItems'] ?? []),
    );
  }

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? profilePhotoUrl,
    List<Address>? addressList,
    List<String>? favoriteItems,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      favoriteItems: favoriteItems ?? this.favoriteItems,
    );
  }
}
