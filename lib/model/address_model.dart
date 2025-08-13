class Address {
  final String label;
  final String street;
  final String city;
  final String state;
  final String postalCode;
  final String country;

  Address({
    required this.label,
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
  });

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'street': street,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
    };
  }

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      label: json['label'] ?? '',
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      postalCode: json['postalCode'] ?? '',
      country: json['country'] ?? '',
    );
  }
}
