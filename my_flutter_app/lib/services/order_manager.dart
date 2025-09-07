import 'package:flutter/foundation.dart';

class OrderManager extends ChangeNotifier {
  static final OrderManager _instance = OrderManager._internal();
  factory OrderManager() => _instance;
  OrderManager._internal();

  final List<Map<String, dynamic>> orders = [];
  int _orderCounter = 1000;

  void createOrder({
    required List<Map<String, dynamic>> items,
    required double total,
    required String status,
  }) {
    final orderNumber = _orderCounter++;
    final order = {
      'orderNumber': orderNumber,
      'items': List<Map<String, dynamic>>.from(items),
      'total': total,
      'status': status,
      'date': DateTime.now().toIso8601String(),
      'estimatedDelivery': DateTime.now().add(const Duration(days: 2)).toIso8601String(),
    };
    orders.add(order);
    notifyListeners();
  }

  List<Map<String, dynamic>> getOrders() {
    return List<Map<String, dynamic>>.from(orders);
  }

  Map<String, dynamic>? getOrderByNumber(int orderNumber) {
    try {
      return orders.firstWhere((order) => order['orderNumber'] == orderNumber);
    } catch (e) {
      return null;
    }
  }

  void updateOrderStatus(int orderNumber, String newStatus) {
    final orderIndex = orders.indexWhere((order) => order['orderNumber'] == orderNumber);
    if (orderIndex != -1) {
      orders[orderIndex]['status'] = newStatus;
      notifyListeners();
    }
  }
}
