import 'address_model.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String profilePhotoUrl;
  final List<Address> addressList;
  final List<String> favoriteItems;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.profilePhotoUrl = '',
    this.addressList = const [],
    this.favoriteItems = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profilePhotoUrl': profilePhotoUrl,
      'addressList': addressList.map((a) => a.toJson()).toList(),
      'favoriteItems': favoriteItems,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profilePhotoUrl: json['profilePhotoUrl'] ?? '',
      addressList:
          (json['addressList'] as List<dynamic>? ?? [])
              .map((a) => Address.fromJson(a))
              .toList(),
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
      addressList: addressList ?? this.addressList,
      favoriteItems: favoriteItems ?? this.favoriteItems,
    );
  }
}
