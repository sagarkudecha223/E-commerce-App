class Address {
  final String id;
  final String label;
  final String street;
  final String cityStateCountry;
  final String postalCode;
  final String latLong;

  Address({
    required this.id,
    required this.label,
    required this.street,
    required this.cityStateCountry,
    required this.postalCode,
    required this.latLong,
  });

  Map<String, dynamic> toJson() => {
    'label': label,
    'street': street,
    'postalCode': postalCode,
    'latLong': latLong,
    'cityStateCountry': cityStateCountry,
  };

  factory Address.fromJson(String id, Map<String, dynamic> json) => Address(
    id: id,
    label: json['label'] ?? '',
    cityStateCountry: json['cityStateCountry'] ?? '',
    street: json['street'] ?? '',
    postalCode: json['postalCode'] ?? '',
    latLong: json['latLong'] ?? '',
  );

  Address copyWith({
    String? id,
    String? label,
    String? street,
    String? cityStateCountry,
    String? postalCode,
    String? latLong,
  }) {
    return Address(
      id: id ?? this.id,
      label: label ?? this.label,
      street: street ?? this.street,
      cityStateCountry: cityStateCountry ?? this.cityStateCountry,
      postalCode: postalCode ?? this.postalCode,
      latLong: latLong ?? this.latLong,
    );
  }
}
