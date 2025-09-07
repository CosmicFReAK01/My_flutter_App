class Address {
  final String id;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String? label; // Home, Work, Shop, etc.
  final bool isShopAddress; // For consumers
  final String? shopName; // For consumers
  final String? operatingHours; // For consumers

  Address({
    required this.id,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    this.label,
    this.isShopAddress = false,
    this.shopName,
    this.operatingHours,
  });

  // Add fromJson/toJson methods when connecting to backend
}
