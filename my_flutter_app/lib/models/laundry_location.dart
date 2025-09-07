class LaundryLocation {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String address;
  final double rating;
  final List<String> services;
  final String phone;
  final String? imageUrl;
  final bool isOpen;
  final String openingHours;
  final double distance; // in kilometers

  LaundryLocation({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.rating,
    required this.services,
    required this.phone,
    this.imageUrl,
    required this.isOpen,
    required this.openingHours,
    required this.distance,
  });

  factory LaundryLocation.fromJson(Map<String, dynamic> json) {
    return LaundryLocation(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      latitude: (json['location']?['lat'] ?? 0.0).toDouble(),
      longitude: (json['location']?['lng'] ?? 0.0).toDouble(),
      address: json['address'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      services: List<String>.from(json['services'] ?? []),
      phone: json['phone'] ?? '',
      imageUrl: json['imageUrl'],
      isOpen: json['isOpen'] ?? true,
      openingHours: json['openingHours'] ?? '9:00 AM - 9:00 PM',
      distance: (json['distance'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': {
        'lat': latitude,
        'lng': longitude,
      },
      'address': address,
      'rating': rating,
      'services': services,
      'phone': phone,
      'imageUrl': imageUrl,
      'isOpen': isOpen,
      'openingHours': openingHours,
      'distance': distance,
    };
  }
}
