class Order {
  final String id;
  final String userId;
  final String customerName;
  final String customerPhone;
  final String deliveryAddress;
  final DateTime orderDate;
  final DateTime pickupDate;
  final DateTime deliveryDate;
  final double totalAmount;
  final String status; // Pending, In Progress, Completed, Cancelled
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.userId,
    required this.customerName,
    required this.customerPhone,
    required this.deliveryAddress,
    required this.orderDate,
    required this.pickupDate,
    required this.deliveryDate,
    required this.totalAmount,
    required this.status,
    required this.items,
  });
}

class OrderItem {
  final String id;
  final String serviceId;
  final String serviceName;
  final int quantity;
  final double price;

  OrderItem({
    required this.id,
    required this.serviceId,
    required this.serviceName,
    required this.quantity,
    required this.price,
  });

  double get totalPrice => quantity * price;
}
