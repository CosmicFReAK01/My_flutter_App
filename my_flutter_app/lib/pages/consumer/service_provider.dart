import 'package:flutter/foundation.dart';

class Service {
  final int id;
  final String name;
  final String description;
  final double price;
  final String unit;
  final String duration;
  final String category;
  bool active;

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.unit,
    required this.duration,
    required this.category,
    this.active = true,
  });

  // Convert Service to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'unit': unit,
      'duration': duration,
      'category': category,
      'active': active,
    };
  }

  // Create Service from Map
  factory Service.fromMap(Map<String, dynamic> map) {
    return Service(
      id: map['id'] as int,
      name: map['name'] as String,
      description: map['description'] as String,
      price: (map['price'] as num).toDouble(),
      unit: map['unit'] as String,
      duration: map['duration'] as String,
      category: map['category'] as String,
      active: map['active'] as bool? ?? true,
    );
  }
}

class ServiceProvider with ChangeNotifier {
  final List<Service> _services = [
    Service(
      id: 1,
      name: 'Wash & Fold',
      description: 'Professional washing and folding service',
      price: 1.50,
      unit: 'per lb',
      duration: '24 hours',
      category: 'Regular',
    ),
    Service(
      id: 2,
      name: 'Dry Cleaning',
      description: 'Premium dry cleaning for delicate items',
      price: 8.99,
      unit: 'per item',
      duration: '48 hours',
      category: 'Premium',
    ),
    Service(
      id: 3,
      name: 'Wash & Iron',
      description: 'Washing with professional pressing',
      price: 2.25,
      unit: 'per lb',
      duration: '36 hours',
      category: 'Regular',
    ),
    Service(
      id: 4,
      name: 'Express Wash',
      description: 'Quick same-day laundry service',
      price: 2.99,
      unit: 'per lb',
      duration: '6 hours',
      category: 'Express',
    ),
  ];

  // Get all services
  List<Service> get services => List.unmodifiable(_services);

  // Add a new service
  void addService(Service service) {
    _services.add(service);
    notifyListeners();
  }

  // Update an existing service
  void updateService(int id, Service updatedService) {
    final index = _services.indexWhere((service) => service.id == id);
    if (index != -1) {
      _services[index] = updatedService;
      notifyListeners();
    }
  }

  // Delete a service by ID
  void deleteService(int id) {
    _services.removeWhere((service) => service.id == id);
    notifyListeners();
  }

  // Toggle service active status
  void toggleServiceStatus(int id) {
    final index = _services.indexWhere((service) => service.id == id);
    if (index != -1) {
      _services[index].active = !_services[index].active;
      notifyListeners();
    }
  }

  // Get service by ID
  Service? getServiceById(int id) {
    try {
      return _services.firstWhere((service) => service.id == id);
    } catch (e) {
      return null;
    }
  }
}