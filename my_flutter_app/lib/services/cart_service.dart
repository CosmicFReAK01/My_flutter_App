import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CartItem {
  final String id;
  final String name;
  final double price;
  int quantity;
  final IconData icon;
  final Color color;
  final String? description;
  final String? category;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
    required this.icon,
    required this.color,
    this.description,
    this.category,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'quantity': quantity,
    'icon': icon.codePoint,
    'color': color.value,
    'description': description,
    'category': category,
  };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    id: json['id'] as String,
    name: json['name'] as String,
    price: (json['price'] as num).toDouble(),
    quantity: json['quantity'] as int? ?? 1,
    icon: IconData(
      json['icon'] as int,
      fontFamily: 'MaterialIcons',
    ),
    color: Color(json['color'] as int),
    description: json['description'] as String?,
    category: json['category'] as String?,
  );

  CartItem copyWith({
    String? id,
    String? name,
    double? price,
    int? quantity,
    IconData? icon,
    Color? color,
    String? description,
    String? category,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      description: description ?? this.description,
      category: category ?? this.category,
    );
  }
}

class CartService extends ChangeNotifier {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  double get subtotal {
    return _items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  double get deliveryFee => _items.isEmpty ? 0.0 : 50.0;
  
  double get tax => subtotal * 0.1; // 10% tax
  
  double get total => subtotal + deliveryFee + tax;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  void addItem(CartItem item) {
    final existingIndex = _items.indexWhere((i) => i.id == item.id);
    
    if (existingIndex != -1) {
      _items[existingIndex].quantity += item.quantity;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void removeItem(String itemId) {
    _items.removeWhere((item) => item.id == itemId);
    notifyListeners();
  }

  void updateQuantity(String itemId, int quantity) {
    final index = _items.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  void incrementQuantity(String itemId) {
    final index = _items.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity(String itemId) {
    final index = _items.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  bool isInCart(String itemId) {
    return _items.any((item) => item.id == itemId);
  }

  int getItemQuantity(String itemId) {
    final item = _items.firstWhere(
      (item) => item.id == itemId,
      orElse: () => CartItem(
        id: '',
        name: '',
        price: 0,
        icon: Icons.error,
        color: Colors.grey,
        quantity: 0,
      ),
    );
    return item.quantity;
  }

  // Initialize with some sample data (optional - can be removed later)
  void initializeSampleData() {
    if (_items.isEmpty) {
      _items.addAll([
        CartItem(
          id: 'wash_fold_001',
          name: 'Wash & Fold',
          price: 149.0,
          quantity: 5,
          icon: Iconsax.lamp_on,
          color: const Color(0xFF6366F1),
          description: 'Complete wash and fold service',
          category: 'Laundry',
        ),
        CartItem(
          id: 'dry_clean_001',
          name: 'Dry Cleaning',
          price: 349.0,
          quantity: 2,
          icon: Iconsax.broom,
          color: const Color(0xFF10B981),
          description: 'Professional dry cleaning service',
          category: 'Cleaning',
        ),
        CartItem(
          id: 'iron_001',
          name: 'Ironing',
          price: 99.0,
          quantity: 3,
          icon: Iconsax.icon,
          color: const Color(0xFFF59E0B),
          description: 'Steam ironing service',
          category: 'Ironing',
        ),
        CartItem(
          id: 'premium_001',
          name: 'Premium Service',
          price: 599.0,
          quantity: 1,
          icon: Iconsax.crown_1,
          color: const Color(0xFFEC4899),
          description: 'All-inclusive premium service',
          category: 'Premium',
        ),
      ]);
      notifyListeners();
    }
  }
}
