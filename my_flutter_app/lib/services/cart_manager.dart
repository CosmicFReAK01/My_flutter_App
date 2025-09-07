import 'package:flutter/foundation.dart';

class CartManager extends ChangeNotifier {
  static final CartManager _instance = CartManager._internal();
  factory CartManager() => _instance;
  CartManager._internal();

  final List<Map<String, dynamic>> items = [];

  void addItem({
    required String title,
    required String providerName,
    required List<String> services,
    required String price,
  }) {
    items.add({
      'title': title,
      'provider': providerName,
      'services': services,
      'price': price,
    });
    notifyListeners();
  }

  void removeAt(int index) {
    if (index >= 0 && index < items.length) {
      items.removeAt(index);
      notifyListeners();
    }
  }

  void clear() {
    items.clear();
    notifyListeners();
  }

  double calculateTotal() {
    double sum = 0;
    for (final item in items) {
      final raw = (item['price'] ?? '').toString();
      final numeric = raw.replaceAll(RegExp(r'[^0-9.]'), '');
      if (numeric.isNotEmpty) {
        sum += double.tryParse(numeric) ?? 0;
      }
    }
    return sum;
  }
}


